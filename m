Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbbAMVUB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 16:20:01 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:57305 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbbAMVT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 16:19:59 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Adaptec OEM Raid Solutions <aacraid@adaptec.com>
Subject: [PATCH] SCSI: ips: remove pointless #warning
Date: Tue, 13 Jan 2015 22:19:48 +0100
Message-ID: <1469112.NM94QHK9oc@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:88/GWuWzbxND2pLLBnvG5cszrXjPHepmWPETBMA9YEZbpRy1ZRu
 u4Skp7WoT8gZQMsJOZhmGmxfKMOZ/gIavjCt4M4ROfbfztSup86Ve/EraNa4BIux4ICpvDR
 dDy+tZ9wYOgQVGs3TLaC7mC5QIzwitVwCKiRFUnTSEaQVUjPyan6Qw51yVH3AYUE5fH2H61
 F5BfLGMevGTaw/WS1E1Fw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ips driver contains

 #warning "This driver has only been tested on the x86/ia64/x86_64 platforms"

which gets printed by the compiler every time this driver gets
build for something other than those three architectures. The same
is true for most other drivers, but none of them prints a warning like
this.

Let's remove the warning now to reduce the amount of clutter.

FWIW, I've reviewed the driver and found a few oddities, but nothing
that needs to be fixed or that would be architecture specific.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index e5c28435d768..265ec482becc 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -206,10 +206,6 @@ module_param(ips, charp, 0);
 #define IPS_VERSION_HIGH        IPS_VER_MAJOR_STRING "." IPS_VER_MINOR_STRING
 #define IPS_VERSION_LOW         "." IPS_VER_BUILD_STRING " "
 
-#if !defined(__i386__) && !defined(__ia64__) && !defined(__x86_64__)
-#warning "This driver has only been tested on the x86/ia64/x86_64 platforms"
-#endif
-
 #define IPS_DMA_DIR(scb) ((!scb->scsi_cmd || ips_is_passthru(scb->scsi_cmd) || \
                          DMA_NONE == scb->scsi_cmd->sc_data_direction) ? \
                          PCI_DMA_BIDIRECTIONAL : \

