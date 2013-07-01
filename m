Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844Ab3GAUVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 16:21:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49000 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755382Ab3GAUKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 16:10:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        kbuild test robot <fengguang.wu@intel.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [ 11/26] s390/irq: Only define synchronize_irq() on SMP
Date: Mon,  1 Jul 2013 13:10:06 -0700
Message-Id: <20130701200731.156251711@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130701200729.872850414@linuxfoundation.org>
References: <20130701200729.872850414@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 690cec8e70c211d1f5f6e520b21a68d0306173b6 upstream.

In uniprocessor configurations, synchronize_irq() is defined in
<linux/hardirq.h> as a macro, and this function definition fails to
compile.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kernel/irq.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/s390/kernel/irq.c
+++ b/arch/s390/kernel/irq.c
@@ -314,6 +314,7 @@ void measurement_alert_subclass_unregist
 }
 EXPORT_SYMBOL(measurement_alert_subclass_unregister);
 
+#ifdef CONFIG_SMP
 void synchronize_irq(unsigned int irq)
 {
 	/*
@@ -322,6 +323,7 @@ void synchronize_irq(unsigned int irq)
 	 */
 }
 EXPORT_SYMBOL_GPL(synchronize_irq);
+#endif
 
 #ifndef CONFIG_PCI
 


