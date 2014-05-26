Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465AbaEZWNu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 18:13:50 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:50391 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbaEZWNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 18:13:46 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>
Subject: [PATCH 00/27] Fix common bug in most nand drivers not showing a device in sysfs
Date: Tue, 27 May 2014 00:12:25 +0200
Message-Id: <1401142372-14148-1-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A comment in mtdcore.c function add_mtd_device() which is called by
mtd_device_parse_register() made me wonder:

"Caller should have set dev.parent to match the physical device."

In fact this is not done by most nand drivers.

What follows is a series which fixes this.

Tested: orion and omap2
Compile-Tested: atmel, gpio, fsmc, gpmi, plat, pxa3xx, s3c2410, sh_flctl,
		sharpsl, tmio, docg4, davinci, lpc32xx_mlc, lpc32xx_slc, mxc
Not tested at all (only be view, patches 19-27): bcm47, fsl_elbc, fsl_upm,
		fsl_ifc, jz4740, mpc5121m, ndfc, txx9ndfmx, socrates

The overall stat is

27 files changed, 36 insertions(+), 80 deletions(-)

and it fixes 21 of these bugs.

Regards,

Alexander Holler

