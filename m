Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965258Ab3DPSao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 14:30:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65048 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965209Ab3DPS1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 14:27:03 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 16/28] zoran: Don't print proc_dir_entry data in debug [RFC]
To: linux-kernel@vger.kernel.org
From: David Howells <dhowells@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, mjpeg-users@lists.sourceforge.net,
        viro@zeniv.linux.org.uk, linux-media@vger.kernel.org
Date: Tue, 16 Apr 2013 19:26:54 +0100
Message-ID: <20130416182654.27773.74830.stgit@warthog.procyon.org.uk>
In-Reply-To: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
References: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't print proc_dir_entry data in debug as we're soon to have no direct
access to the contents of the PDE.  Print what was put in there instead.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: mjpeg-users@lists.sourceforge.net
cc: linux-media@vger.kernel.org
---

 drivers/media/pci/zoran/zoran_procfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/zoran/zoran_procfs.c b/drivers/media/pci/zoran/zoran_procfs.c
index 07a104d..f7ceee0 100644
--- a/drivers/media/pci/zoran/zoran_procfs.c
+++ b/drivers/media/pci/zoran/zoran_procfs.c
@@ -201,7 +201,7 @@ zoran_proc_init (struct zoran *zr)
 		dprintk(2,
 			KERN_INFO
 			"%s: procfs entry /proc/%s allocated. data=%p\n",
-			ZR_DEVNAME(zr), name, zr->zoran_proc->data);
+			ZR_DEVNAME(zr), name, zr);
 	} else {
 		dprintk(1, KERN_ERR "%s: Unable to initialise /proc/%s\n",
 			ZR_DEVNAME(zr), name);

