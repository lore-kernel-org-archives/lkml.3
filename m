Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758258Ab3GMS1j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 14:27:39 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46407 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758064Ab3GMS1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 14:27:37 -0400
Date: Sat, 13 Jul 2013 20:27:34 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-omap@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH] omapfb: In omapfb_probe return -EPROBE_DEFER when
 display driver is not loaded yet
Message-ID: <20130713182733.GA25019@amd.pavel.ucw.cz>
References: <1373461739-10168-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1373461739-10168-1-git-send-email-pali.rohar@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2013-07-10 15:08:59, Pali Rohár wrote:
> * On RX-51 probing for acx565akm driver is later then for omapfb which cause that omapfb probe fail and framebuffer is not working
> * EPROBE_DEFER causing that kernel try to probe for omapfb later again which fixing this problem
> 
> * Without this patch display on Nokia RX-51 (N900) phone not working
> 
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>

Tested-by: Pavel Machek <pavel@ucw.cz>

(Actually, do we know which commit broke the ordering? We may want to
simply revert that one...)

BTW I'm currently trying to set-up automated scripts for n900/qemu
testing. I guess I'll try to run them on mainline kernel to catch such
stuff earlier.

One thing I'd like to know: how do you configure kernel to get output
on qemu? I was doing CONFIG_DEBUG_LL with specific uart, but that
needed patching the kernel, you apparently have something more clever.

I tried doing:

# CONFIG_DEBUG_LL is not set
CONFIG_DEBUG_LL_INCLUDE="mach/debug-macro.S"
CONFIG_UNCOMPRESS_INCLUDE="debug/uncompress.h"

but no output on console...

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
