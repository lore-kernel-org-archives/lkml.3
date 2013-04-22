Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab3DVJNO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 05:13:14 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51870 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753469Ab3DVJNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 05:13:12 -0400
Date: Mon, 22 Apr 2013 11:13:10 +0200
From: Borislav Petkov <bp@alien8.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: paulmck@linux.vnet.ibm.com, x86-ml <x86@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: irq 16: nobody cared
Message-ID: <20130422091310.GA4637@pd.tnic>
References: <20130420185330.GA4654@pd.tnic>
 <20130420235206.GA3509@linux.vnet.ibm.com>
 <20130421103403.GA4594@pd.tnic>
 <20130421163002.GB3509@linux.vnet.ibm.com>
 <s5hfvyj55ke.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <s5hfvyj55ke.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 10:32:17AM +0200, Takashi Iwai wrote:
> Hm, if it's really due to a stray irq, just adding the missing
> synchronize_irq() like below would help?
> 
> 
> Takashi
> 
> ---
> diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
> index 7b213d5..262dbf1 100644
> --- a/sound/pci/hda/hda_intel.c
> +++ b/sound/pci/hda/hda_intel.c
> @@ -2682,6 +2682,8 @@ static void azx_stop_chip(struct azx *chip)
>  	/* disable interrupts */
>  	azx_int_disable(chip);
>  	azx_int_clear(chip);
> +	if (chip->irq >= 0)
> +		synchronize_irq(chip->irq);

Nope, it doesn't help - I see the same splat.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
