Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbaBLI37 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:29:59 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50180 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752051AbaBLIOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:14:00 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Tejun Heo" <tj@kernel.org>,
        "Robin H. Johnson" <robbat2@gentoo.org>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.670590843@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 44/79] libata: disable a disk via libata.force params
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 Documentation/kernel-parameters.txt | 2 ++
 drivers/ata/libata-core.c           | 1 +
 2 files changed, 3 insertions(+)

--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1305,6 +1305,8 @@ bytes respectively. Such letter suffixes
 
 			* dump_id: dump IDENTIFY data.
 
+			* disable: Disable this device.
+
 			If there are multiple matching configurations changing
 			the same attribute, the last one is used.
 
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6331,6 +6331,7 @@ static int __init ata_parse_force_one(ch
 		{ "nohrst",	.lflags		= ATA_LFLAG_NO_HRST },
 		{ "nosrst",	.lflags		= ATA_LFLAG_NO_SRST },
 		{ "norst",	.lflags		= ATA_LFLAG_NO_HRST | ATA_LFLAG_NO_SRST },
+		{ "disable",	.horkage_on	= ATA_HORKAGE_DISABLE },
 	};
 	char *start = *cur, *p = *cur;
 	char *id, *val, *endp;

