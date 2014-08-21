Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbaHULKj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 07:10:39 -0400
Received: from mail.cs.hut.fi ([130.233.192.7]:42598 "EHLO mail.cs.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754086AbaHULKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 07:10:38 -0400
Date: Thu, 21 Aug 2014 14:10:34 +0300 (EEST)
From: Ari Sundholm <asundhol@cs.hut.fi>
To: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
cc: Matthew Garrett <matthew.garrett@nebula.com>, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] toshiba_acpi.c - fix busted keyboard backlight logic
In-Reply-To: <17794.1408561003@turing-police.cc.vt.edu>
Message-ID: <alpine.GSO.2.03.1408211406540.23797@mannerheim.cs.hut.fi>
References: <17794.1408561003@turing-police.cc.vt.edu>
User-Agent: Alpine 2.03 (GSO 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 20 Aug 2014, Valdis Kletnieks wrote:

> Both the original and the first attempted patch managed to get the logic wrong.
> So we fix it so we only continue if sscanf returns exactly one value, and it
> has to be either 1 or 2.  Apparently, programmers are getting out and hacking
> code without remembering de Morgan's Laws...
> 
> Patch is against the file that results from Ari's revert of the previous
> patch.
> 
> Signed-Off-By: Valdis Kletnieks <valdis.kletnieks@vt.edu>
> 
> --
> --- drivers/platform/x86/toshiba_acpi.c.orig	2014-08-20 14:45:52.159898938 -0400
> +++ drivers/platform/x86/toshiba_acpi.c	2014-08-20 14:47:55.102444985 -0400
> @@ -1258,7 +1258,7 @@ static ssize_t toshiba_kbd_bl_mode_store
>  	int mode = -1;
>  	int time = -1;
>  
> -	if (sscanf(buf, "%i", &mode) != 1 && (mode != 2 || mode != 1))
> +	if (sscanf(buf, "%i", &mode) != 1 || !(mode == 2 || mode == 1))
>  		return -EINVAL;
>  
>  	/* Set the Keyboard Backlight Mode where:

Looks good to me.

It seems Matthew already reverted the bad commit in mainline commit 
8039aabb6c9f802bca04cc77ca210060a5b53916, but didn't fix the original 
logic yet.

Matthew, could you apply Valdis' patch so this gets fixed once and for 
all?

Best regards,
Ari Sundholm
asundhol@cs.hut.fi
