Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960AbaABO6g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 09:58:36 -0500
Received: from know-smtprelay-omc-1.server.virginmedia.net ([80.0.253.65]:42854
	"EHLO know-smtprelay-omc-1.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753AbaABO6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 09:58:33 -0500
X-Originating-IP: [82.36.39.136]
X-Spam: 0
X-Authority: v=2.1 cv=WI/xXxcR c=1 sm=1 tr=0 a=h3ZJzbuz6X3s3VlFudNWSw==:117
 a=h3ZJzbuz6X3s3VlFudNWSw==:17 a=6vexxxhns_QA:10 a=Uyo7tk_25LAA:10
 a=3NElcqgl2aoA:10 a=k1j_C7plYBUA:10 a=a5Gf7U6LAAAA:8 a=sZ2MFieG22MA:10
 a=r77TgQKjGQsHNAKrUKIA:9 a=9iDbn-4jx3cA:10 a=cKsnjEOsciEA:10
 a=QJSbeFYOpp3GrE2Sr2YA:9 a=wPNLvfGTeEIA:10 a=FdZYFe_Ep9oA:10
 a=zk2W-0Rfe9wA:10 a=_M3ppzKhsvAw5GGbQOcA:9 a=TX0R2tOv1tUWXE-6:21
 a=zQYvB7sGEyFerAoO:21 a=yHIqe9kG5mgA:10
Message-ID: <52C57E97.1050602@blueyonder.co.uk>
Date: Thu, 02 Jan 2014 14:58:31 +0000
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ilia Mirkin <imirkin@alum.mit.edu>
CC: LKML Mailing List <linux-kernel@vger.kernel.org>,
        opensuse factory list <opensuse-factory@opensuse.org>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>
Subject: [PATCH] Fix hang problem with GeForce GT 560 Ti and nouveau in 3.13-rc
References: <52C29918.4060102@blueyonder.co.uk>	<CAKb7UvhBunpMC6mzjRg7Zb5gGPPYj99=2jd+Lgnr-qeXFs0w9A@mail.gmail.com>	<52C3644C.9090809@blueyonder.co.uk>	<CAKb7UviLpfZMtZM9X1R0Eaj=5ww2k=T+7x01dZH3ns2Ew1HuFw@mail.gmail.com>	<52C42079.6060604@blueyonder.co.uk>	<CAKb7Uvj97SgHp1b11_MMt1UR-NUpQ_2LuGhwjyk_a7_VLqN+KQ@mail.gmail.com>	<52C4D099.9040507@blueyonder.co.uk> <CAKb7UvgiYn9Wy=EsrHWsoGH7Zj2=-8n=qunyzHTLKnSW3RL=iQ@mail.gmail.com>
In-Reply-To: <CAKb7UvgiYn9Wy=EsrHWsoGH7Zj2=-8n=qunyzHTLKnSW3RL=iQ@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------000303030209040800000704"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000303030209040800000704
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Senior Staff Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks


--------------000303030209040800000704
Content-Type: text/x-patch;
 name="GF114_2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="GF114_2.diff"

This patch stops a console hang with VGA compatible controller: NVIDIA Corporation GF114 [GeForce GTX 560 Ti] (rev a1)
3.13-rc defines NVDEV_SUBDEV_MC as nvc3_mc_oclass, it needs to be defined as nvc0_mc_oclass
Signed off by: Sid Boyce (sboyce@blueyonder.co.uk)
Tested by: Sid Boyce (sboyce@blueyonder.co.uk)
---

drivers/gpu/drm/nouveau/core/engine/device/nvc0.c 1 -+
1 file changed, 1 insertion(+), 1 deletion(-)

INDEX: linux/drivers/gpu/drm/nouveau/core/engine/device/nvc0.c
=========================================================================
diff -up  a/drivers/gpu/drm/nouveau/core/engine/device/nvc0.c b/drivers/gpu/drm/nouveau/core/engine/device/nvc0.c
--- a/drivers/gpu/drm/nouveau/core/engine/device/nvc0.c	2013-11-23 13:03:23.797604441 +0000
+++ b/drivers/gpu/drm/nouveau/core/engine/device/nvc0.c	2014-01-02 02:13:32.445643092 +0000
@@ -161,7 +161,7 @@ nvc0_identify(struct nouveau_device *dev
 		device->oclass[NVDEV_SUBDEV_THERM  ] = &nva3_therm_oclass;
 		device->oclass[NVDEV_SUBDEV_MXM    ] = &nv50_mxm_oclass;
 		device->oclass[NVDEV_SUBDEV_DEVINIT] = &nvc0_devinit_oclass;
-		device->oclass[NVDEV_SUBDEV_MC     ] =  nvc3_mc_oclass;
+		device->oclass[NVDEV_SUBDEV_MC     ] =  nvc0_mc_oclass;
 		device->oclass[NVDEV_SUBDEV_BUS    ] =  nvc0_bus_oclass;
 		device->oclass[NVDEV_SUBDEV_TIMER  ] = &nv04_timer_oclass;
 		device->oclass[NVDEV_SUBDEV_FB     ] =  nvc0_fb_oclass;

--------------000303030209040800000704--
