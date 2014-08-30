Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676AbaH3N73 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 09:59:29 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:49536 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbaH3N71 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 09:59:27 -0400
From: Mikael Pettersson <mikpelinux@gmail.com>
X-Google-Original-From: "Mikael Pettersson" <mikpe@cascade>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <21505.55482.547592.906934@gargle.gargle.HOWL>
Date: Sat, 30 Aug 2014 15:59:22 +0200
To: michel.daenzer@amd.com
Cc: alexander.deucher@amd.com, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: [BISECTED] 3.17-rc1 radeon screen corruption due to "Always flush the HDP cache before submitting a CS to the GPU"
X-Mailer: VM 8.1.2 under 24.3.1 (x86_64-redhat-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 3.17-rc1 my radeon card (RV370 / X1050 card) causes screen corruption
after a while in X + firefox.  This still occurs with yesterday's HEAD
of Linus' repo.  3.16 and ealier kernels are fine.

I ran a bisect, which identified:

commit 72a9987edcedb89db988079a03c9b9c65b6ec9ac
Author: Michel Dänzer <michel.daenzer@amd.com>
Date:   Thu Jul 31 18:43:49 2014 +0900

    drm/radeon: Always flush the HDP cache before submitting a CS to the GPU

as the cause of my screen corruption.  Reverting this from 3.17-rc2
(which requires manual intervention due to subsequent changes in
radeon_ring_commit()) eliminates the screen corruption.

User-space is vanilla Fedora 19 / x86_64 with updates.  radeon_drv.so says:

[    62.574] (II) LoadModule: "radeon"
[    62.574] (II) Loading /usr/lib64/xorg/modules/drivers/radeon_drv.so
[    62.574] (II) Module radeon: vendor="X.Org Foundation"
[    62.574]    compiled for 1.14.0, module version = 7.1.99
[    62.574]    Module class: X.Org Video Driver
[    62.574]    ABI class: X.Org Video Driver, version 14.1
...
[    62.585] (--) RADEON(0): Chipset: "ATI Radeon X550 (RV370) 5B63 (PCIE)" (ChipID = 0x5b63)

See also my original report to LKML:
<http://marc.info/?l=linux-kernel&m=140829066726743&w=2>

/Mikael
