Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526AbaBCXe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 18:34:57 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:37549 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533AbaBCXey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 18:34:54 -0500
Date: Mon, 3 Feb 2014 15:34:51 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Richard Weinberger <richard@nod.at>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] Clarify CONFIG_DEBUG_INFO's bloaty nature
In-Reply-To: <20140203145718.5bc9ba1619aff8ea0754b0ab@linux-foundation.org>
Message-ID: <alpine.DEB.2.02.1402031532480.7643@chino.kir.corp.google.com>
References: <1391452183-2160-1-git-send-email-bp@alien8.de> <alpine.DEB.2.02.1402031358390.9768@chino.kir.corp.google.com> <CA+55aFzwB0-fcqa_RaNDE1jjS+awM=j3BGroA5C3wRnK_G7UHg@mail.gmail.com> <20140203145718.5bc9ba1619aff8ea0754b0ab@linux-foundation.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Feb 2014, Andrew Morton wrote:

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
>  
>  	  If unsure, say N.
>  

Um, I still don't think this is right since CONFIG_DEBUG_INFO_REDUCED 
requires you to say yes here and that config option actually specifies 
the tools for which it is effective.  Are you suggesting that we decouple 
CONFIG_DEBUG_INFO from CONFIG_DEBUG_INFO_REDUCED and make 
CONFIG_DEBUG_INFO select the reduced variant?  Or... what?
