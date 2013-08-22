Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab3HVUg6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 16:36:58 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42123 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab3HVUg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 16:36:56 -0400
Message-ID: <52167665.90602@wwwdotorg.org>
Date: Thu, 22 Aug 2013 14:36:53 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Richard Zhao <rizhao@nvidia.com>
CC: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, vinod.koul@intel.com,
        djbw@fb.com, grant.likely@linaro.org, rob.herring@calxeda.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2] DMA: add help function to check whether dma controller
 registered
References: <1375423458-6868-1-git-send-email-rizhao@nvidia.com> <1377153781-18006-1-git-send-email-rizhao@nvidia.com>
In-Reply-To: <1377153781-18006-1-git-send-email-rizhao@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2013 12:43 AM, Richard Zhao wrote:
> DMA client device driver usually needs to know at probe time whether
> dma controller has been registered to deffer probe. So add a help
> function of_dma_check_controller.
> 
> DMA request channel functions can also used to check it, but they
> are usually called at open() time.

This new function is almost identical to the existing
of_dma_request_slave_channel(). Surely the code should be shared?

But that said, I don't see any need for a new function; why can't
drivers simply call of_dma_request_slave_channel() at probe time; from
what I can see, that function doesn't actually request the channel, but
rather simply looks it up, just like this one. The only difference is
that of_dma_xlate() is also called, but that's just doing some data
transformation, not actually recording channel ownership.
