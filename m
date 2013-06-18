Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab3FRIlF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 04:41:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:62427 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754717Ab3FRIlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 04:41:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,887,1363158000"; 
   d="scan'208";a="355247535"
Date: Tue, 18 Jun 2013 10:40:17 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lee.jones@linaro.org,
        Miguel Aguilar <miguel.aguilar@ridgerun.com>
Subject: Re: [PATCH Resend 1/1] mfd: davinci_voicecodec: Convert to use
 devm_* APIs
Message-ID: <20130618084017.GA7161@zurbaran>
References: <1371025182-31386-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1371025182-31386-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sachin,

On Wed, Jun 12, 2013 at 01:49:42PM +0530, Sachin Kamat wrote:
> devm_* APIs are device managed and make code simpler.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Miguel Aguilar <miguel.aguilar@ridgerun.com>
> ---
> CC'd Lee Jones
>  
> Patch is based on mfd-next tree and compile tested.
> This driver gives following compilation error (not introduced by this patch):
> drivers/mfd/davinci_voicecodec.c:86:3: error: implicit declaration
> of function ‘io_v2p’ [-Werror=implicit-function-declaration]
>    (dma_addr_t)(io_v2p(davinci_vc->base) + DAVINCI_VC_WFIFO);
> 
> In order to test my changes I added the following to davinci_voicecodec.h file:
> +#define IO_OFFSET      0xfd000000 /* Virtual IO = 0xfec00000 */
> +#define io_v2p(va)     ((va) - IO_OFFSET)
> 
> I am not sure if these changes are right fix for the above error.
io_v2p is define in davinci's mach/hardware.h so I believe this is what
you should include in davinci_voicecodec.h.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
