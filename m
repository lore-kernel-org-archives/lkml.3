Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab3LSQgN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:36:13 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:33917 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791Ab3LSQgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 11:36:10 -0500
Date: Thu, 19 Dec 2013 17:36:06 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        the arch/x86 maintainers <x86@kernel.org>, linux-fbdev@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>, stable@vger.kernel.org
Subject: Re: [PATCH v3] x86: sysfb: remove sysfb when probing real hw
Message-ID: <20131219163606.GA29243@gmail.com>
References: <1387374611-12493-1-git-send-email-dh.herrmann@gmail.com>
 <1387448038-8260-1-git-send-email-dh.herrmann@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387448038-8260-1-git-send-email-dh.herrmann@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Herrmann <dh.herrmann@gmail.com> wrote:

> --- a/drivers/video/fbmem.c
> +++ b/drivers/video/fbmem.c
> @@ -35,6 +35,9 @@
>  
>  #include <asm/fb.h>
>  
> +#if IS_ENABLED(CONFIG_X86)
> +#include <asm/sysfb.h>
> +#endif

I think this can be written as:

#ifdef CONFIG_X86
# include <asm/sysfb.h>
#endif

also ... the dependency on a large, unrelated option like CONFIG_X86 
looks pretty ugly here - is there no other, more specific CONFIG_ 
option that can be used here - such as CONFIG_FB_SIMPLE or 
CONFIG_X86_SYSFB?

> +#if IS_ENABLED(CONFIG_X86)
> +	sysfb_unregister(apert, primary);
> +#endif

Ditto.

Thanks,

	Ingo 
