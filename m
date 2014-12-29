Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989AbaL2HyM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 02:54:12 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:46104 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbaL2HyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 02:54:07 -0500
Message-ID: <54A10868.70001@ti.com>
Date: Mon, 29 Dec 2014 09:53:12 +0200
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>
CC: Rob Herring <robh+dt@kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH] arch: arm: common: edma.c:  Remove some unused functions
References: <1417906406-5527-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1417906406-5527-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2014 12:53 AM, Rickard Strandqvist wrote:
> Removes some functions that are not used anywhere:
> edma_shadow0_read() edma_or_array()
> 
> This was partially found by using a static code analysis program called cppcheck.

Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  arch/arm/common/edma.c |    8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
> index d86771a..163273d 100644
> --- a/arch/arm/common/edma.c
> +++ b/arch/arm/common/edma.c
> @@ -160,10 +160,6 @@ static inline void edma_modify_array(unsigned ctlr, int offset, int i,
>  {
>  	edma_modify(ctlr, offset + (i << 2), and, or);
>  }
> -static inline void edma_or_array(unsigned ctlr, int offset, int i, unsigned or)
> -{
> -	edma_or(ctlr, offset + (i << 2), or);
> -}
>  static inline void edma_or_array2(unsigned ctlr, int offset, int i, int j,
>  		unsigned or)
>  {
> @@ -174,10 +170,6 @@ static inline void edma_write_array2(unsigned ctlr, int offset, int i, int j,
>  {
>  	edma_write(ctlr, offset + ((i*2 + j) << 2), val);
>  }
> -static inline unsigned int edma_shadow0_read(unsigned ctlr, int offset)
> -{
> -	return edma_read(ctlr, EDMA_SHADOW0 + offset);
> -}
>  static inline unsigned int edma_shadow0_read_array(unsigned ctlr, int offset,
>  		int i)
>  {
> 


-- 
Péter
