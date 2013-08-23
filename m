Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576Ab3HWP5s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 11:57:48 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55036 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190Ab3HWP5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 11:57:46 -0400
Message-ID: <52178677.6090001@wwwdotorg.org>
Date: Fri, 23 Aug 2013 09:57:43 -0600
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
References: <1375408800-11789-1-git-send-email-rizhao@nvidia.com> <20130822051904.GA2685@rizhao-lap> <52167213.6090604@wwwdotorg.org> <20130823012911.GB17925@rizhao-lap>
In-Reply-To: <20130823012911.GB17925@rizhao-lap>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2013 07:29 PM, Richard Zhao wrote:
> On Fri, Aug 23, 2013 at 04:18:27AM +0800, Stephen Warren wrote:
>> On 08/21/2013 11:19 PM, Richard Zhao wrote:
>>> On Fri, Aug 02, 2013 at 10:00:00AM +0800, Richard Zhao wrote:
>>>> pass of_phandle_args dma_spec to dma_request_channel in of_dma_simple_xlate,
>>>> so the filter function could access of_node in of_phandle_args.
>>>>
>>>> It also remove restriction of #dma-cells has to be one.
>>>>
>>>> Signed-off-by: Richard Zhao <rizhao@nvidia.com>
>>>> ---
>>>>  drivers/dma/edma.c     |  7 +++++--
>>>>  drivers/dma/of-dma.c   | 10 ++++------
>>>>  drivers/dma/omap-dma.c |  6 ++++--
>>>>  3 files changed, 13 insertions(+), 10 deletions(-)
>>>>
>>>
>>> Hi Vinod,
>>>
>>> Can you please pick up this change?
>>>
>>> Hi Stephen,
>>>
>>> Can you please give a ack or reviewed-by etc?
>>
>> Hmm. Looking at the patch, I'm not sure it's right.
>>
>> This patch simply passes all the specfier args to the filter function,
>> and the code to check the equality of the of_node to the filter args is
>> still duplicated in each DMA driver. Instead, the DMA core should be
>> implementing the equality check, and only even calling the
>> driver-specific filter function for devices where the client's phandle
>> matches the DMA providing device's of_node handle.
> 
> Filter function is called in dmaengine core code, independent of dt.

The core code can still check if a dmaengine's driver was instantiated
from DT and take additional actions in that case.

> And the reason why the driver has to write its own filter function is
> it has to store slave id there in its own way.

I'm not saying don't call the driver's filter function, but rather that
the dmaengine core should perform the common checks before doing so.
