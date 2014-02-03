Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbaBCWAF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 17:00:05 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:48147 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbaBCWAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 17:00:03 -0500
Date: Mon, 3 Feb 2014 14:00:00 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Borislav Petkov <bp@alien8.de>
cc: LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Richard Weinberger <richard@nod.at>, Borislav Petkov <bp@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Clarify CONFIG_DEBUG_INFO's bloaty nature
In-Reply-To: <1391452183-2160-1-git-send-email-bp@alien8.de>
Message-ID: <alpine.DEB.2.02.1402031358390.9768@chino.kir.corp.google.com>
References: <1391452183-2160-1-git-send-email-bp@alien8.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Feb 2014, Borislav Petkov wrote:

> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index dbf94a7d25a8..9095c2078095 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -126,7 +126,11 @@ config DEBUG_INFO
>  	  This adds debug symbols to the kernel and modules (gcc -g), and
>  	  is needed if you intend to use kernel crashdump or binary object
>  	  tools like crash, kgdb, LKCD, gdb, etc on the kernel.
> -	  Say Y here only if you plan to debug the kernel.
> +
> +	  If you only want to have resolved symbols in kernel traces and
> +	  are not going to need support for those tools above, you don't need
> +	  to enable this as it is a huge bloat and build slowdown;

How do you define "huge bloat" if the size of vmlinux doesn't increase?  
Would some people consider that to be acceptable but now mysteriously 
confused because we don't know what "huge bloat" you're referring to?

It also begs the question about the meaning of DEBUG_INFO_REDUCED and this 
comment doesn't even allow us to see that it's an option.

So this doesn't look good.

> +	  enable CONFIG_KALLSYMS instead.
>  
>  	  If unsure, say N.
>  
