Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020AbbATNHb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 08:07:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50790 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543AbbATNH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 08:07:29 -0500
Date: Tue, 20 Jan 2015 14:07:27 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
cc: Steven Miao <realmz6@gmail.com>, Sonic Zhang <sonic.zhang@analog.com>,
        Randy Dunlap <rdunlap@infradead.org>, Christoph Lameter <cl@linux.com>,
        Masanari Iida <standby24x7@gmail.com>,
        adi-buildroot-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blackfin: mach-common: ints-priority:  Remove unused
 function
In-Reply-To: <1420304509-13072-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Message-ID: <alpine.LNX.2.00.1501201407050.10817@pobox.suse.cz>
References: <1420304509-13072-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Jan 2015, Rickard Strandqvist wrote:

> Remove the function bfin_sec_resume() that is not used anywhere.
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

This doesn't seem to be present in linux-next as of today, so I am picking 
it up.

> ---
>  arch/blackfin/mach-common/ints-priority.c |    8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/arch/blackfin/mach-common/ints-priority.c b/arch/blackfin/mach-common/ints-priority.c
> index dd2af74..7236bdf 100644
> --- a/arch/blackfin/mach-common/ints-priority.c
> +++ b/arch/blackfin/mach-common/ints-priority.c
> @@ -429,14 +429,6 @@ static void init_software_driven_irq(void)
>  	bfin_sec_enable_ssi(37);
>  }
>  
> -void bfin_sec_resume(void)
> -{
> -	bfin_write_SEC_SCI(0, SEC_CCTL, SEC_CCTL_RESET);
> -	udelay(100);
> -	bfin_write_SEC_GCTL(SEC_GCTL_EN);
> -	bfin_write_SEC_SCI(0, SEC_CCTL, SEC_CCTL_EN | SEC_CCTL_NMI_EN);
> -}
> -
>  void handle_sec_sfi_fault(uint32_t gstat)
>  {
>  
> -- 
> 1.7.10.4
> 

-- 
Jiri Kosina
SUSE Labs
