Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744AbbASRzP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 12:55:15 -0500
Received: from mout.web.de ([212.227.15.14]:52419 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716AbbASRzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 12:55:12 -0500
Message-ID: <54BD44F0.3040705@users.sourceforge.net>
Date: Mon, 19 Jan 2015 18:54:56 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Antonino Daplas <adaplas@gmail.com>,
        Ferenc Bakonyi <fero@drama.obuda.kando.hu>,
        Hans de Goede <hdegoede@redhat.com>, Helge Deller <deller@gmx.de>,
        "James E. J. Bottomley" <jejb@parisc-linux.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Kristoffer Ericson <kristoffer.ericson@gmail.com>,
        Peter Jones <pjones@redhat.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        linux-nvidia@lists.surfsouth.com, linux-parisc@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 0/9] video: fbdev: Deletion of some unnecessary checks
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:iJAuW2wBQmpjNBaao0Fc2WuL9tyyLHfejrBwH7suR9swY7cxB62
 D8Oyp0Dgbi2svR8XIulduC2OWtdYXNwQyAz+a04EIL7qsvSWWIDGNEaQXHCJZSJ0kGxQMXU
 uOVWJHmbT6BVCIWeltU3Tsrlwxsife3p/O47mZRJu08zoT/XgOGH8zcmjA04gsgACTfGfMz
 GZ6fijkQBIvYY2M5mWgsg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 19 Jan 2015 17:57:25 +0100

Further update suggestions were taken into account after a patch was applied
from static source code analysis.

Markus Elfring (9):
  fbdev: Deletion of checks before the function call "iounmap"
  One function call less in tdfxfb_probe() after error detection
  One function call less in vesafb_probe() after error detection
  Add check for return value of ioremap() in cirrusfb_pci_register()
  Less function calls in trident_pci_probe() after error detection
  One function call less in pvr2fb_common_init() after error detection
  One function call less in tgafb_register() after error detection
  Less function calls in valkyriefb_init() after error detection
  Less function calls in w100fb_probe() after error detection

 drivers/video/fbdev/aty/atyfb_base.c   | 15 +++++--------
 drivers/video/fbdev/cirrusfb.c         | 10 ++++++---
 drivers/video/fbdev/controlfb.c        |  6 ++---
 drivers/video/fbdev/efifb.c            |  3 +--
 drivers/video/fbdev/hgafb.c            |  3 +--
 drivers/video/fbdev/hpfb.c             |  3 +--
 drivers/video/fbdev/i810/i810_main.c   |  6 ++---
 drivers/video/fbdev/macfb.c            | 15 +++++--------
 drivers/video/fbdev/offb.c             |  3 +--
 drivers/video/fbdev/pvr2fb.c           | 15 ++++++-------
 drivers/video/fbdev/s1d13xxxfb.c       |  3 +--
 drivers/video/fbdev/s3fb.c             |  6 ++---
 drivers/video/fbdev/sh_mobile_hdmi.c   |  6 ++---
 drivers/video/fbdev/sh_mobile_lcdcfb.c |  3 +--
 drivers/video/fbdev/simplefb.c         |  3 +--
 drivers/video/fbdev/stifb.c            |  3 +--
 drivers/video/fbdev/tdfxfb.c           | 22 +++++++++----------
 drivers/video/fbdev/tgafb.c            | 20 ++++++++---------
 drivers/video/fbdev/tridentfb.c        | 15 +++++++------
 drivers/video/fbdev/valkyriefb.c       | 37 ++++++++++++++++++-------------
 drivers/video/fbdev/vesafb.c           | 11 +++++-----
 drivers/video/fbdev/w100fb.c           | 40 +++++++++++++++++-----------------
 22 files changed, 116 insertions(+), 132 deletions(-)

-- 
2.2.2

