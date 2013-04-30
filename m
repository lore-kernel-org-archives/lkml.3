Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760393Ab3D3LdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 07:33:21 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:48052 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760270Ab3D3LdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 07:33:19 -0400
X-IronPort-AV: E=Sophos;i="4.87,581,1363104000"; 
   d="scan'208,223";a="7159407"
Message-ID: <517FAB8D.2060702@cn.fujitsu.com>
Date: Tue, 30 Apr 2013 19:31:25 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, tangchen <tangchen@cn.fujitsu.com>,
        Lin Feng <linfeng@cn.fujitsu.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, guz.fnst@cn.fujitsu.com
Subject: [PATCH v2 2/4] PCI: introduce pci_bus_get()/pci_bus_put() to hide
 pci_bus' reference management
References: <516FB647.5030203@cn.fujitsu.com> <CAErSpo65ARR_fZwsGCZDJqbPWktHYUkufgPt-2mWwur=nPR1Qg@mail.gmail.com>
In-Reply-To: <CAErSpo65ARR_fZwsGCZDJqbPWktHYUkufgPt-2mWwur=nPR1Qg@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/30 19:31:32,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/30 19:31:35,
	Serialize complete at 2013/04/30 19:31:35
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ff785e84afd2558dd52de8e73c4f75b7563a595b Mon Sep 17 00:00:00 2001
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
Date: Tue, 30 Apr 2013 17:22:02 +0900
Subject: [PATCH v2 2/4] PCI: introduce pci_bus_get()/pci_bus_put() to hide
 pci_bus' reference management

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 drivers/pci/bus.c   |   15 +++++++++++++++
 include/linux/pci.h |    3 +++
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 748f8f3..93f4dc0 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -18,6 +18,21 @@
 
 #include "pci.h"
 
+struct pci_bus *pci_bus_get(struct pci_bus *bus)
+{
+	if (bus)
+		get_device(&bus->dev);
+	return bus;
+}
+EXPORT_SYMBOL(pci_bus_get);
+
+void pci_bus_put(struct pci_bus *bus)
+{
+	if (bus)
+		put_device(&bus->dev);
+}
+EXPORT_SYMBOL(pci_bus_put);
+
 void pci_add_resource_offset(struct list_head *resources, struct resource *res,
 			     resource_size_t offset)
 {
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 6c09949..2581e53 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1020,6 +1020,9 @@ int pci_request_selected_regions_exclusive(struct pci_dev *, int, const char *);
 void pci_release_selected_regions(struct pci_dev *, int);
 
 /* drivers/pci/bus.c */
+extern struct pci_bus *pci_bus_get(struct pci_bus *bus);
+extern void pci_bus_put(struct pci_bus *bus);
+
 void pci_add_resource(struct list_head *resources, struct resource *res);
 void pci_add_resource_offset(struct list_head *resources, struct resource *res,
 			     resource_size_t offset);
-- 
1.7.7

