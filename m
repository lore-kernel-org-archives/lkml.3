Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab3CQUKV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 16:10:21 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:42856 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756500Ab3CQUKT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 16:10:19 -0400
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: 3.8.2->3.8.3 i915 regression: GMBUS [i915 gmbus dpb] timed out, falling back to bit banging on pin 5
Date: Sun, 17 Mar 2013 21:10:15 +0100
User-Agent: KMail/1.13.7 (Linux/3.8.3-dirty; KDE/4.10.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Imre Deak <imre.deak@intel.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        intel-gfx@lists.freedesktop.org
References: <201303142136.24917.a.miskiewicz@gmail.com> <201303161135.59793.a.miskiewicz@gmail.com> <CAKMK7uHXpjucZhcjMgZXi2QSXOCgA=NZaOv0m2DvfuyT3TAzRw@mail.gmail.com>
In-Reply-To: <CAKMK7uHXpjucZhcjMgZXi2QSXOCgA=NZaOv0m2DvfuyT3TAzRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201303172110.15501.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 17 of March 2013, Daniel Vetter wrote:
> On Sat, Mar 16, 2013 at 11:35 AM, Arkadiusz Miskiewicz
> 
> <a.miskiewicz@gmail.com> wrote:
> > On Thursday 14 of March 2013, Arkadiusz Miskiewicz wrote:
> >> Hello.
> > 
> >> After upgrading from 3.8.2 to 3.8.3 I'm getting regression :
> > More people hits this:
> > https://bugzilla.redhat.com/show_bug.cgi?id=922304
> > https://bugs.archlinux.org/task/34327
> > (seems always GM45 gpu in these reports)
> > 
> > archlinux people also noticed that xrandr reports VGA1 as connected
> > (while in reality nothing is connected to VGA1)
> 
> Can you please test whether 3.9-rc kernels are affected, too? 

3.9.0-rc2-00341-g0863702

works fine here

[    0.349462] [drm] Initialized drm 1.1.0 20060810
[    0.349566] [drm] radeon kernel modesetting enabled.
[    0.350049] [drm] Memory usable by graphics device = 2048M
[    0.350110] i915 0000:00:02.0: setting latency timer to 64
[    0.374161] i915 0000:00:02.0: irq 47 for MSI/MSI-X
[    0.374170] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    0.374229] [drm] Driver supports precise vblank timestamp query.
[    0.436916] fbcon: inteldrmfb (fb0) is primary device
[    0.983961] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    0.983996] i915 0000:00:02.0: registered panic notifier
[    0.986191] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 
0

xrandr reports VGA-1 as disconnected properly

> We need
> to know this since stable rules mandate that a regression is fixed on
> upstream first. Once that's figured out we can backport a fix (if
> 3.9-rc works) or start working on a fix for 3.8-rc kernels first and
> backport afterwards.
> 
> Thanks, Daniel


-- 
Arkadiusz Miśkiewicz, arekm / maven.pl
