Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab3LAUZF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 15:25:05 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53916 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab3LAUZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 15:25:02 -0500
Date: Sun, 1 Dec 2013 21:25:00 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: sre@ring0.de, sre@debian.org, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Compile failure on linux-n900 branch -- MEDIA_CAMERA_SUPPORT
 needed for n900 compilation
Message-ID: <20131201202500.GA24067@amd.pavel.ucw.cz>
References: <20131127125149.GA9389@amd.pavel.ucw.cz>
 <201312011050.18256@pali>
 <20131201192120.GD9743@amd.pavel.ucw.cz>
 <201312012025.13622@pali>
 <20131201200112.GE9743@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131201200112.GE9743@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi!

> > I just hit this one:
> > 
> >   CC      arch/arm/mach-omap2/board-rx51-camera.o
> > In file included from
> > arch/arm/mach-omap2/board-rx51-camera.c:34:0:
> > arch/arm/mach-omap2/../../../drivers/media/platform/omap3isp/
> > isp.h: In function 'isp_pad_buffer_type':
> > arch/arm/mach-omap2/../../../drivers/media/platform/omap3isp/i
> > sp.h:347:19: error: 'const struct v4l2_subdev' has no member
> > named 'entity'
> > arch/arm/mach-omap2/../../../drivers/media/platform/omap3isp/
> > isp.h:350:12: error: 'const struct v4l2_subdev' has no member
> > named 'entity' make[1]: ***
> > [arch/arm/mach-omap2/board-rx51-camera.o] Error 1 make: ***
> > [arch/arm/mach-omap2] Error 2
> > make: *** Waiting for unfinished jobs....
> > Command exited with non-zero status 2
> > 
> > Problem seems to be that isp.h expects CONFIG_MEDIA_CONTROLLER
> > to be set, but board-rx51-camera.c is always compiled. We
> > could do

Interesting; with Sebastian DT config
(http://elektranox.org/n900-kernel-config.txt), I get the same



[   17.967651] omap_i2c 48070000.i2c: Too much work in one IRQ
[   17.968109] omap_i2c 48070000.i2c: Too much work in one IRQ
[   17.968566] omap_i2c 48070000.i2c: Too much work in one IRQ
[   17.969055] omap_i2c 48070000.i2c: Too much work in one IRQ
[   17.969512] omap_i2c 48070000.i2c: Too much work in one IRQ
[   17.969970] omap_i2c 48070000.i2c: Too much work in one IRQ
[   17.970428] omap_i2c 48070000.i2c: Too much work in one IRQ
[   17.970886] omap_i2c 48070000.i2c: Too much work in one IRQ
[   17.971313] omap_i2c 48070000.i2c: Too much work in one IRQ
[   17.967651] omap_i2c 48070000.i2c: Too much work in one IRQ
[   17.968109] omap_i2c 48070000.i2c: Too much work in one IRQ
[   17.968566] omap_i2c 48070000.i2c: Too much work in one IRQ
[   17.969055] omap_i2c 48070000.i2c: Too much work in one IRQ
[   17.969512] omap_i2c 48070000.i2c: Too much work in one IRQ
[   17.969970] omap_i2c 48070000.i2c: Too much work in one IRQ
[   17.970428] omap_i2c 48070000.i2c: Too much work in one IRQ
[   17.970886] omap_i2c 48070000.i2c: Too much work in one IRQ
[   17.971313] omap_i2c 48070000.i2c: Too much work in one IRQ

...infinite loop during bootup. So, Sebastian, it looks problem is in
linux-n900, too. Will switch to defconfig, that worked...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
