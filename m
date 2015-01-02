Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbbABNVN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 08:21:13 -0500
Received: from cassarossa.samfundet.no ([193.35.52.29]:38679 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbbABNVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 08:21:12 -0500
Date: Fri, 2 Jan 2015 14:21:06 +0100
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch: avr32: mach-at32ap: at32ap700x:  Remove unused
 function
Message-ID: <20150102132106.GA8951@samfundet.no>
References: <1420134742-1142-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420134742-1142-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Thu 01 Jan 2015 18:52:22 +0100 or thereabout, Rickard Strandqvist wrote:
> Remove the function set_ebi_sfr_bits() that is not used anywhere.
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Hmmm, nack, I suspect there was non-upstreamed boards that used this to
fiddle with the hmatrix. I even think Atmel still has an appnote about how to
do this.

At least NGW100 was used to verify that fiddling with hmatrix worked.

> ---
>  arch/avr32/mach-at32ap/at32ap700x.c |   11 -----------
>  1 file changed, 11 deletions(-)
> 
> diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
> index 37b7560..d84516c 100644
> --- a/arch/avr32/mach-at32ap/at32ap700x.c
> +++ b/arch/avr32/mach-at32ap/at32ap700x.c
> @@ -744,17 +744,6 @@ struct clk at32_hmatrix_clk = {
>  	.users		= 1,
>  };
>  
> -/*
> - * Set bits in the HMATRIX Special Function Register (SFR) used by the
> - * External Bus Interface (EBI). This can be used to enable special
> - * features like CompactFlash support, NAND Flash support, etc. on
> - * certain chipselects.
> - */
> -static inline void set_ebi_sfr_bits(u32 mask)
> -{
> -	hmatrix_sfr_set_bits(HMATRIX_SLAVE_EBI, mask);
> -}
> -
>  /* --------------------------------------------------------------------
>   *  Timer/Counter (TC)
>   * -------------------------------------------------------------------- */
-- 
mvh
Hans-Christian Egtvedt
