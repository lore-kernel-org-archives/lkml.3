Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883AbaLIMsx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 07:48:53 -0500
Received: from mail.skyhub.de ([78.46.96.112]:49449 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756643AbaLIMsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 07:48:51 -0500
Date: Tue, 9 Dec 2014 13:48:46 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi <linux-efi@vger.kernel.org>, Laszlo Ersek <lersek@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: Shorten efi regions output
Message-ID: <20141209124845.GB3990@pd.tnic>
References: <20141209095843.GA3990@pd.tnic>
 <CAKv+Gu_F+o6NKb5JJ8ZQ7AJbjvASeQF1YcuUXv8seOMa5oaxgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_F+o6NKb5JJ8ZQ7AJbjvASeQF1YcuUXv8seOMa5oaxgg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2014 at 01:42:44PM +0100, Ard Biesheuvel wrote:
> The |] thing is easily fixed, though.
> 
> [...]
> > diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> > index 8590099ac148..6734072980ee 100644
> > --- a/drivers/firmware/efi/efi.c
> > +++ b/drivers/firmware/efi/efi.c
> [...]
> > @@ -490,15 +490,15 @@ char * __init efi_md_typeattr_format(char *buf, size_t size,
> >                 snprintf(pos, size, "|attr=0x%016llx]",
> >                          (unsigned long long)attr);
> >         else
> > -               snprintf(pos, size, "|%3s|%2s|%2s|%2s|%3s|%2s|%2s|%2s|%2s]",
> > -                        attr & EFI_MEMORY_RUNTIME ? "RUN" : "",
> > -                        attr & EFI_MEMORY_XP      ? "XP"  : "",
> > -                        attr & EFI_MEMORY_RP      ? "RP"  : "",
> > -                        attr & EFI_MEMORY_WP      ? "WP"  : "",
> > -                        attr & EFI_MEMORY_UCE     ? "UCE" : "",
> > -                        attr & EFI_MEMORY_WB      ? "WB"  : "",
> > -                        attr & EFI_MEMORY_WT      ? "WT"  : "",
> > -                        attr & EFI_MEMORY_WC      ? "WC"  : "",
> > -                        attr & EFI_MEMORY_UC      ? "UC"  : "");
> > +               snprintf(pos, size, "|%s%s%s%s%s%s%s%s%s]",
> 
> Drop the leading | here
> 
> > +                        attr & EFI_MEMORY_RUNTIME ? "RT|"  : "",
> > +                        attr & EFI_MEMORY_XP      ? "XP|"  : "",
> > +                        attr & EFI_MEMORY_RP      ? "RP|"  : "",
> > +                        attr & EFI_MEMORY_WP      ? "WP|"  : "",
> > +                        attr & EFI_MEMORY_UCE     ? "UCE|" : "",
> > +                        attr & EFI_MEMORY_WB      ? "WB|"  : "",
> > +                        attr & EFI_MEMORY_WT      ? "WT|"  : "",
> > +                        attr & EFI_MEMORY_WC      ? "WC|"  : "",
> > +                        attr & EFI_MEMORY_UC      ? "UC"   : "");
> 
> and move all the | to the beginning of the string here, including "UC"

Haha, of course! :-)

/me slaps forehead.

Thanks!

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
