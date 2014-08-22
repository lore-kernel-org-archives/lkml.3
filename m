Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932884AbaHVRmO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 13:42:14 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:60710 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932447AbaHVRmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 13:42:13 -0400
MIME-Version: 1.0
Date: Fri, 22 Aug 2014 10:42:12 -0700
Message-ID: <CA+zRj8VfVKG9fchHFOBjupVhmgAfim9sY2NhoP2JOGDS6S_78w@mail.gmail.com>
Subject: i915 (possibly): Suspend regression Macbook Pro 15 (late 2013)
From: Eric Rannaud <eric.rannaud@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Between 3.13.5 and 3.15.4, suspend became partially broken on Macbook Pro 15
(late 2013): a few minutes after wakeup from the *second* suspend following a
fresh boot, the screen will randomly turn itself off at shorter and shorter
time intervals, and turn itself back on after a few seconds and/or user
interaction.  Eventually, after 4 or 5 such cycles, the screen refuses to turn
back on altogether, and the system must be rebooted (closing the lid again has
no effect).

When the screen turns back on, there is usually some transient corruption (full
screen is displayed shifted to the right by 1/10th of its full width,
cutting off the
right side, which wraps back to the left). This corruption disappears after
additional user interaction that forces a re-render.

The issue is still present in Linus' tree (v3.17-rc1-22-g480cadc2b7e0).

Before I get started trying to bisect this slow-to-reproduce problem, has
anyone any idea of possible causes?

Thanks,
Eric
