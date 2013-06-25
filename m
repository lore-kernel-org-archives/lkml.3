Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633Ab3FYBrs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 21:47:48 -0400
Received: from intranet.asianux.com ([58.214.24.6]:48695 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab3FYBri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 21:47:38 -0400
X-Spam-Score: -100.7
Message-ID: <51C8F685.6000209@asianux.com>
Date: Tue, 25 Jun 2013 09:46:45 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
CC: linux390@de.ibm.com, cornelia.huck@de.ibm.com, mtosatti@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>, linux-s390@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: [PATCH] arch: s390: kernel: reset 'c->hotpluggable' when failure
 occurs
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When smp_add_present_cpu() fails, it has reset all things excluding
'c->hotpluggable', so need reset it as original state completely.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/s390/kernel/smp.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 15a016c..c4c6f42 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -1016,6 +1016,7 @@ out_cpu:
 	unregister_cpu(c);
 #endif
 out:
+	c->hotpluggable = 0;
 	return rc;
 }
 
-- 
1.7.7.6
