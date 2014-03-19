Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751277AbaCSRqc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 13:46:32 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40637 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbaCSRq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 13:46:29 -0400
Message-ID: <5329D7F1.4030400@infradead.org>
Date: Wed, 19 Mar 2014 10:46:25 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        James Bottomley <jbottomley@parallels.com>, Tejun Heo <tj@kernel.org>
CC: linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>,
        Jim Davis <jim.epost@gmail.com>
Subject: [PATCH -next] libata.h: add stub for ata_sas_port_resume
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix build error when CONFIG_PM is not enabled by adding a stub
function in <linux/libata.h>.

drivers/scsi/libsas/sas_ata.c: In function 'sas_resume_sata':
drivers/scsi/libsas/sas_ata.c:756:3: error: implicit declaration of function 'ata_sas_port_resume' [-Werror=implicit-function-declaration]

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Jim Davis <jim.epost@gmail.com>
---
 include/linux/libata.h |    3 +++
 1 file changed, 3 insertions(+)

--- linux-next-20140319.orig/include/linux/libata.h
+++ linux-next-20140319/include/linux/libata.h
@@ -1148,6 +1148,9 @@ static inline void ata_sas_port_suspend(
 static inline void ata_sas_port_async_resume(struct ata_port *ap)
 {
 }
+static inline void ata_sas_port_resume(struct ata_port *ap)
+{
+}
 #endif
 extern int ata_ratelimit(void);
 extern void ata_msleep(struct ata_port *ap, unsigned int msecs);
