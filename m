Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702AbaAMQC3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:02:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53045 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbaAMQCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:02:10 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Robin H. Johnson" <robbat2@gentoo.org>, Tejun Heo <tj@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 053/208] libata: disable a disk via libata.force params
Date: Mon, 13 Jan 2014 15:58:14 +0000
Message-Id: <1389628849-1614-54-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Robin H. Johnson" <robbat2@gentoo.org>

commit b8bd6dc36186fe99afa7b73e9e2d9a98ad5c4865 upstream.

A user on StackExchange had a failing SSD that's soldered directly
onto the motherboard of his system. The BIOS does not give any option
to disable it at all, so he can't just hide it from the OS via the
BIOS.

The old IDE layer had hdX=noprobe override for situations like this,
but that was never ported to the libata layer.

This patch implements a disable flag for libata.force.

Example use:

 libata.force=2.0:disable

[v2 of the patch, removed the nodisable flag per Tejun Heo]

Signed-off-by: Robin H. Johnson <robbat2@gentoo.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Link: http://unix.stackexchange.com/questions/102648/how-to-tell-linux-kernel-3-0-to-completely-ignore-a-failing-disk
Link: http://askubuntu.com/questions/352836/how-can-i-tell-linux-kernel-to-completely-ignore-a-disk-as-if-it-was-not-even-co
Link: http://superuser.com/questions/599333/how-to-disable-kernel-probing-for-drive
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 Documentation/kernel-parameters.txt | 2 ++
 drivers/ata/libata-core.c           | 1 +
 2 files changed, 3 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 7f9d4f5..205cc23 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1460,6 +1460,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 
 			* atapi_dmadir: Enable ATAPI DMADIR bridge support
 
+			* disable: Disable this device.
+
 			If there are multiple matching configurations changing
 			the same attribute, the last one is used.
 
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index bcdbcff..bfd727a 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6509,6 +6509,7 @@ static int __init ata_parse_force_one(char **cur,
 		{ "norst",	.lflags		= ATA_LFLAG_NO_HRST | ATA_LFLAG_NO_SRST },
 		{ "rstonce",	.lflags		= ATA_LFLAG_RST_ONCE },
 		{ "atapi_dmadir", .horkage_on	= ATA_HORKAGE_ATAPI_DMADIR },
+		{ "disable",	.horkage_on	= ATA_HORKAGE_DISABLE },
 	};
 	char *start = *cur, *p = *cur;
 	char *id, *val, *endp;
-- 
1.8.3.2

