Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761448Ab3ICXZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 19:25:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44376 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667Ab3ICXZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 19:25:57 -0400
Message-ID: <52266FE7.9030506@infradead.org>
Date: Tue, 03 Sep 2013 16:25:27 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: [PATCH v2] of_irq.h: fix build warnings when CONFIG_OF is not enabled
References: <5224B499.4010600@infradead.org> <CAL_Jsq+82vm_vt5EpcG1zvWmL_H4KY=91tB1WH5yUhHsiM11DA@mail.gmail.com>
In-Reply-To: <CAL_Jsq+82vm_vt5EpcG1zvWmL_H4KY=91tB1WH5yUhHsiM11DA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix build warnings when CONFIG_OF is not enabled:
(seen on i386 and x86_64)

include/linux/of_irq.h:82:7: warning: 'struct device_node' declared inside parameter list [enabled by default]
include/linux/of_irq.h:82:7: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]
include/linux/of_irq.h:87:47: warning: 'struct device_node' declared inside parameter list [enabled by default]

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc:	Grant Likely <grant.likely@linaro.org>
Cc:	Rob Herring <rob.herring@calxeda.com>
Cc:	devicetree@vger.kernel.org
---
 include/linux/of_irq.h |    2 ++
 1 file changed, 2 insertions(+)

--- linux-next-20130830.orig/include/linux/of_irq.h
+++ linux-next-20130830/include/linux/of_irq.h
@@ -1,6 +1,8 @@
 #ifndef __OF_IRQ_H
 #define __OF_IRQ_H
 
+struct device_node;
+
 #if defined(CONFIG_OF)
 struct of_irq;
 #include <linux/types.h>
