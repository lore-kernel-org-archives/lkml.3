Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934325Ab3CHPkr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 10:40:47 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:41909 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934162Ab3CHPkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 10:40:45 -0500
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        rubini@gnudd.com, sameo@linux.intel.com, giancarlo.asnaghi@st.com,
        mturquette@linaro.org, arnd@arndb.de, linus.walleij@linaro.org,
        rob.herring@calxeda.com, broonie@opensource.wolfsonmicro.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] x86, pci sta2x11-fixup: add function to access sta2x11 instance id
Date: Fri,  8 Mar 2013 16:31:30 +0100
Message-Id: <1362756691-14736-3-git-send-email-ciminaghi@gnudd.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1362756691-14736-1-git-send-email-ciminaghi@gnudd.com>
References: <1362756691-14736-1-git-send-email-ciminaghi@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sta2x11 instance id will be included in clock names to make them
unique in case of multiple sta2x11's living on the same machine.

Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
---
 arch/x86/pci/sta2x11-fixup.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/pci/sta2x11-fixup.c b/arch/x86/pci/sta2x11-fixup.c
index 478c228..6450853 100644
--- a/arch/x86/pci/sta2x11-fixup.c
+++ b/arch/x86/pci/sta2x11-fixup.c
@@ -138,6 +138,12 @@ struct sta2x11_instance *sta2x11_get_instance(struct pci_dev *pdev)
 }
 EXPORT_SYMBOL(sta2x11_get_instance);
 
+int sta2x11_get_instance_id(struct sta2x11_instance *instance)
+{
+	return instance->bus0;
+}
+EXPORT_SYMBOL(sta2x11_get_instance_id);
+
 
 /**
  * p2a - Translate physical address to STA2x11 AMBA address,
-- 
1.7.10.4

