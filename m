Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab3HVRb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 13:31:57 -0400
Received: from 6.mo5.mail-out.ovh.net ([178.32.119.138]:42516 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753787Ab3HVRb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 13:31:56 -0400
Date: Thu, 22 Aug 2013 18:54:28 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Bo Shen <voice.shen@atmel.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [PATCH 3/4] arm: atmel: sama5: enable kernel uncompress info
 output
Message-ID: <20130822165428.GE18627@ns203013.ovh.net>
References: <1372922202-28606-1-git-send-email-voice.shen@atmel.com>
 <1372922202-28606-4-git-send-email-voice.shen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372922202-28606-4-git-send-email-voice.shen@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Ovh-Tracer-Id: 4760304807977200435
X-Ovh-Remote: 91.121.171.124 (ns203013.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrgeefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrgeefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15:16 Thu 04 Jul     , Bo Shen wrote:
> enable kernel uncompress info output, which will show as following:
> ---8>---
> Uncompressing Linux... done, booting the kernel.
> ---<8---

squash it with the precedent patch

Best Regards,
J,
> 
> Signed-off-by: Bo Shen <voice.shen@atmel.com>
> ---
>  arch/arm/mach-at91/include/mach/uncompress.h |   12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/arch/arm/mach-at91/include/mach/uncompress.h b/arch/arm/mach-at91/include/mach/uncompress.h
> index 5659f7c..fe097e6 100644
> --- a/arch/arm/mach-at91/include/mach/uncompress.h
> +++ b/arch/arm/mach-at91/include/mach/uncompress.h
> @@ -94,6 +94,15 @@ static const u32 uarts_sam9x5[] = {
>  	0,
>  };
>  
> +static const u32 uarts_sama5[] = {
> +	AT91_BASE_DBGU1,
> +	SAMA5D3_BASE_USART0,
> +	SAMA5D3_BASE_USART1,
> +	SAMA5D3_BASE_USART2,
> +	SAMA5D3_BASE_USART3,
> +	0,
> +};
> +
>  static inline const u32* decomp_soc_detect(void __iomem *dbgu_base)
>  {
>  	u32 cidr, socid;
> @@ -123,6 +132,9 @@ static inline const u32* decomp_soc_detect(void __iomem *dbgu_base)
>  
>  	case ARCH_ID_AT91SAM9X5:
>  		return uarts_sam9x5;
> +
> +	case ARCH_ID_SAMA5D3:
> +		return uarts_sama5;
>  	}
>  
>  	/* at91sam9g10 */
> -- 
> 1.7.9.5
> 
