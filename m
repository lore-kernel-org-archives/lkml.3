Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757772AbaAFXpG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:45:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47873 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932567AbaAFWjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:39:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Robin H. Johnson" <robbat2@gentoo.org>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 3.12 099/144] libata: disable a disk via libata.force params
Date: Mon,  6 Jan 2014 14:37:40 -0800
Message-Id: <20140106223748.196153487@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/kernel-parameters.txt |    2 ++
 drivers/ata/libata-core.c           |    1 +
 2 files changed, 3 insertions(+)

--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1515,6 +1515,8 @@ bytes respectively. Such letter suffixes
 
 			* atapi_dmadir: Enable ATAPI DMADIR bridge support
 
+			* disable: Disable this device.
+
 			If there are multiple matching configurations changing
 			the same attribute, the last one is used.
 
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6523,6 +6523,7 @@ static int __init ata_parse_force_one(ch
 		{ "norst",	.lflags		= ATA_LFLAG_NO_HRST | ATA_LFLAG_NO_SRST },
 		{ "rstonce",	.lflags		= ATA_LFLAG_RST_ONCE },
 		{ "atapi_dmadir", .horkage_on	= ATA_HORKAGE_ATAPI_DMADIR },
+		{ "disable",	.horkage_on	= ATA_HORKAGE_DISABLE },
 	};
 	char *start = *cur, *p = *cur;
 	char *id, *val, *endp;


