Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab3JKG1s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 02:27:48 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:38240 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632Ab3JKG1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 02:27:31 -0400
From: Kim Phillips <kim.phillips@linaro.org>
To: Bhushan Bharat <R65777@freescale.com>, Wood Scott <B07421@freescale.com>,
        Yoder Stuart <B08248@freescale.com>, christoffer.dall@linaro.org,
        alex.williamson@redhat.com, linux-kernel@vger.kernel.org,
        a.motakis@virtualopensystems.com, agraf@suse.de,
        Sethi Varun <B16395@freescale.com>, peter.maydell@linaro.org,
        santosh.shukla@linaro.org, kvm@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: [PATCH] VFIO: platform: allow the driver to bind to any device explicitly via sysfs
Date: Fri, 11 Oct 2013 01:27:20 -0500
Message-Id: <1381472840-3470-4-git-send-email-kim.phillips@linaro.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381472840-3470-1-git-send-email-kim.phillips@linaro.org>
References: <1381418830.7979.405.camel@snotra.buserror.net>
 <1381472840-3470-1-git-send-email-kim.phillips@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set match_any_dev and sysfs_bind_only such that echoing a platform
device ID to the driver sysfs bind file will successfully match and bind
the device to the vfio-platform meta-driver in accordance to the
desired semantics for vfio drivers.

Signed-off-by: Kim Phillips <kim.phillips@linaro.org>
---
this patch depends on the vfio-platform WIP:

http://www.spinics.net/lists/kvm/msg96701.html

 drivers/vfio/vfio_platform.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/vfio/vfio_platform.c b/drivers/vfio/vfio_platform.c
index b92d7bb..c42d50d 100644
--- a/drivers/vfio/vfio_platform.c
+++ b/drivers/vfio/vfio_platform.c
@@ -297,7 +297,9 @@ static struct platform_driver vfio_platform_driver = {
 		.name	= "vfio-platform",
 		.owner	= THIS_MODULE,
 		.of_match_table = vfio_platform_match,
+		.sysfs_bind_only = true,
 	},
+	.match_any_dev = true,
 };
 
 module_platform_driver(vfio_platform_driver);
-- 
1.8.4

