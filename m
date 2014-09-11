Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757020AbaIKQxB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 12:53:01 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:50015 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756164AbaIKQw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 12:52:58 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Felipe Balbi <balbi@ti.com>, Dan Carpenter <dan.carpenter@oracle.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv2] usb: f_fs: replace BUG in dead-code with less serious WARN_ON
In-Reply-To: <20140910161337.GL667@saruman.home>
Organization: http://mina86.com/
References: <1410364225-6087-1-git-send-email-mina86@mina86.com> <1410364225-6087-2-git-send-email-mina86@mina86.com> <20140910161337.GL667@saruman.home>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140911:linux-usb@vger.kernel.org::gPRYqflP5T3wiUcq:0000000000000000000000000000000000000cjG
X-Hashcash: 1:20:140911:dan.carpenter@oracle.com::iPvxMaP7bPFyuc00:00000000000000000000000000000000000001G/z
X-Hashcash: 1:20:140911:linux-kernel@vger.kernel.org::4l/0WKfsD0OzpvsL:0000000000000000000000000000000006WKD
X-Hashcash: 1:20:140911:balbi@ti.com::yv0fUrTSR1sbZ3IS:000005SHQ
X-Hashcash: 1:20:140911:balbi@ti.com::HqwhDRSuq8YANf0+:00000Iye0
Date: Thu, 11 Sep 2014 18:52:49 +0200
Message-ID: <xa1tegvi14m6.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even though the BUG() in __ffs_event_add is a dead-code, it is still
better to warn rather then crash the system if that code ever gets
executed.

Reported-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/usb/gadget/function/f_fs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

On Wed, Sep 10 2014, Felipe Balbi <balbi@ti.com> wrote:
> WARN(1, "unknown event type %d\n", type);
> Then you can drop pr_vdebug();

True, but the printk call will stay in the binary whereas pr_vdebug is not
included in non-debug builds.  Furthermore, WARN() does not use pr_fmt.

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index ec50e0d..ea21565 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -2321,7 +2321,8 @@ static void __ffs_event_add(struct ffs_data *ffs,
 		break;
 
 	default:
-		BUG();
+		WARN(1, "%d: unknown event, this should not happen\n", type);
+		return;
 	}
 
 	{
-- 
2.1.0.rc2.206.gedb03e5
