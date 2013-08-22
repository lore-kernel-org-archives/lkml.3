Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357Ab3HVUSc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 16:18:32 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:34650 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221Ab3HVUSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 16:18:30 -0400
Message-ID: <52167213.6090604@wwwdotorg.org>
Date: Thu, 22 Aug 2013 14:18:27 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Richard Zhao <rizhao@nvidia.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "djbw@fb.com" <djbw@fb.com>
Subject: Re: [PATCH] DMA: let filter functions of of_dma_simple_xlate possible
 check of_node
References: <1375408800-11789-1-git-send-email-rizhao@nvidia.com> <20130822051904.GA2685@rizhao-lap>
In-Reply-To: <20130822051904.GA2685@rizhao-lap>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2013 11:19 PM, Richard Zhao wrote:
> On Fri, Aug 02, 2013 at 10:00:00AM +0800, Richard Zhao wrote:
>> pass of_phandle_args dma_spec to dma_request_channel in of_dma_simple_xlate,
>> so the filter function could access of_node in of_phandle_args.
>>
>> It also remove restriction of #dma-cells has to be one.
>>
>> Signed-off-by: Richard Zhao <rizhao@nvidia.com>
>> ---
>>  drivers/dma/edma.c     |  7 +++++--
>>  drivers/dma/of-dma.c   | 10 ++++------
>>  drivers/dma/omap-dma.c |  6 ++++--
>>  3 files changed, 13 insertions(+), 10 deletions(-)
>>
> 
> Hi Vinod,
> 
> Can you please pick up this change?
> 
> Hi Stephen,
> 
> Can you please give a ack or reviewed-by etc?

Hmm. Looking at the patch, I'm not sure it's right.

This patch simply passes all the specfier args to the filter function,
and the code to check the equality of the of_node to the filter args is
still duplicated in each DMA driver. Instead, the DMA core should be
implementing the equality check, and only even calling the
driver-specific filter function for devices where the client's phandle
matches the DMA providing device's of_node handle.

