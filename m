Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400Ab3GFX0m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 19:26:42 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:60885 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888Ab3GFX0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 19:26:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: intel-gfx@lists.freedesktop.org, Chris Wilson <chris@chris-wilson.co.uk>
Cc: dri-devel@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        Linux PM list <linux-pm@vger.kernel.org>,
        =?ISO-8859-1?Q?St=E9phane?= Marchesin <marcheu@chromium.org>
Subject: Re: [Regression in 3.10] Garbage displayed after resume on Acer Aspire S5
Date: Sun, 07 Jul 2013 01:36:15 +0200
Message-ID: <14306109.Kf2NcaamIl@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1511667.B4N0cEgdH9@vostro.rjw.lan>
References: <1511667.B4N0cEgdH9@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, July 06, 2013 03:59:49 PM Rafael J. Wysocki wrote:
> Hi,
> 
> I've just started to play with a new Acer Aspire S5 test box and noticed that
> garbage is displayed after resume from suspend to RAM with the 3.10 kernel
> (under KDE 4.10.3 on openSUSE 12.3).  The display corruption goes away after
> killing X and restarting it.
> 
> The CPU is a Core i5-3317U (Ivy Bridge), i915 graphics.
> 
> That doesn't happen with 3.9 (same config otherwise).  It also doesn't happen
> with my older Sandy Bridge-based box (with 3.10), so I suspect Ivy Bridge
> specifics.
> 
> Is this known?  Do you want me to bisect?

Most likely, this has been introduced by this commit:

commit 19b2dbde5732170a03bd82cc8bd442cf88d856f7
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Wed Jun 12 10:15:12 2013 +0100

    drm/i915: Restore fences after resume and GPU resets

At least I'm not able to reproduce it with that commit reverted.  With that
commit in I was able to reproduce it quite readily on machines with Ivy Bridge
and Sandy Bridge processors.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
