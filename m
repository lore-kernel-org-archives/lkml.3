Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883AbaBDE7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 23:59:12 -0500
Received: from mail.skyhub.de ([78.46.96.112]:50816 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394AbaBDE7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 23:59:07 -0500
Date: Tue, 4 Feb 2014 05:59:04 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Richard Weinberger <richard@nod.at>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] Clarify CONFIG_DEBUG_INFO's bloaty nature
Message-ID: <20140204045904.GA4340@pd.tnic>
References: <1391452183-2160-1-git-send-email-bp@alien8.de>
 <alpine.DEB.2.02.1402031358390.9768@chino.kir.corp.google.com>
 <CA+55aFzwB0-fcqa_RaNDE1jjS+awM=j3BGroA5C3wRnK_G7UHg@mail.gmail.com>
 <20140203145718.5bc9ba1619aff8ea0754b0ab@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140203145718.5bc9ba1619aff8ea0754b0ab@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 02:57:18PM -0800, Andrew Morton wrote:
> On Mon, 3 Feb 2014 14:47:15 -0800 Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Mon, Feb 3, 2014 at 2:00 PM, David Rientjes <rientjes@google.com> wrote:
> > >
> > > How do you define "huge bloat" if the size of vmlinux doesn't increase?
> > 
> > Don't be silly. The size of all the object files increase *hugely*.
> 
> yup, I disable this in my allmodconfig testing, to great effect.
> 
> That being said, I do think the text should make clear that the bloat
> is a compile-time impact and not a runtime one.  Something like
> 
> --- a/lib/Kconfig.debug~lib-kconfigdebug-clarify-config_debug_infos-bloaty-nature-fix
> +++ a/lib/Kconfig.debug
> @@ -128,9 +128,9 @@ config DEBUG_INFO
>  	  tools like crash, kgdb, LKCD, gdb, etc on the kernel.
>  
>  	  If you only want to have resolved symbols in kernel traces and
> -	  are not going to need support for those tools above, you don't need
> -	  to enable this as it is a huge bloat and build slowdown;
> -	  enable CONFIG_KALLSYMS instead.
> +	  are not going to need support for the above tools, you don't need
> +	  to enable this.  It hugely bloat object files' on-disk sizes and slows
> +	  the build.  Enable CONFIG_KALLSYMS instead.

Yes, this is better.

Andrew, can you add that or you want me to send a new version?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
