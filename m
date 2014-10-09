Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbaJIMCX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 08:02:23 -0400
Received: from mail-bn1bon0144.outbound.protection.outlook.com ([157.56.111.144]:1793
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751306AbaJIMCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 08:02:22 -0400
From: Cristian Stoica <cristian.stoica@freescale.com>
To: <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <hjk@hansjkoch.de>
CC: <richard.weinberger@gmail.com>,
        Cristian Stoica <cristian.stoica@freescale.com>
Subject: [v2 PATCH 2/2] uio: support memory sizes larger than 32 bits
Date: Thu, 9 Oct 2014 15:00:27 +0300
Message-ID: <1412856027-6523-1-git-send-email-cristian.stoica@freescale.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <CAFLxGvxygJY_dQte+wHqWauDYx=datvgX5Z_ckP4znUiPno5Yw@mail.gmail.com>
References: <CAFLxGvxygJY_dQte+wHqWauDYx=datvgX5Z_ckP4znUiPno5Yw@mail.gmail.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(33646002)(104016003)(20776003)(47776003)(64706001)(85852003)(89996001)(88136002)(105606002)(106466001)(229853001)(107046002)(97736003)(95666004)(85306004)(50226001)(4396001)(50466002)(48376002)(76482002)(102836001)(26826002)(62966002)(92726001)(92566001)(2201001)(93916002)(46102003)(80022003)(76176999)(87936001)(50986999)(104166001)(31966008)(84676001)(99396003)(87286001)(21056001)(44976005)(19580395003)(19580405001)(6806004)(68736004)(120916001)(77156001)(36756003);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0620;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0620;
X-Forefront-PRVS: 0359162B6D
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=B18196@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a completion to 27a90700a4275c5178b883b65927affdafa5185c
The size field is also increased to allow values larger than 32 bits
on platforms that have more than 32 bit physical addresses.

Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
---
 Documentation/DocBook/uio-howto.tmpl | 2 +-
 drivers/uio/uio.c                    | 4 ++--
 include/linux/uio_driver.h           | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/DocBook/uio-howto.tmpl b/Documentation/DocBook/uio-howto.tmpl
index bbe9c1f..1fdc246 100644
--- a/Documentation/DocBook/uio-howto.tmpl
+++ b/Documentation/DocBook/uio-howto.tmpl
@@ -540,7 +540,7 @@ appears in sysfs.
 </para></listitem>
 
 <listitem><para>
-<varname>unsigned long size</varname>: Fill in the size of the
+<varname>resource_size_t size</varname>: Fill in the size of the
 memory block that <varname>addr</varname> points to. If <varname>size</varname>
 is zero, the mapping is considered unused. Note that you
 <emphasis>must</emphasis> initialize <varname>size</varname> with zero for
diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index a673e5b..696ebab 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -68,12 +68,12 @@ static ssize_t map_name_show(struct uio_mem *mem, char *buf)
 
 static ssize_t map_addr_show(struct uio_mem *mem, char *buf)
 {
-	return sprintf(buf, "0x%llx\n", (unsigned long long)mem->addr);
+	return sprintf(buf, "%pa\n", &mem->addr);
 }
 
 static ssize_t map_size_show(struct uio_mem *mem, char *buf)
 {
-	return sprintf(buf, "0x%lx\n", mem->size);
+	return sprintf(buf, "%pa\n", &mem->size);
 }
 
 static ssize_t map_offset_show(struct uio_mem *mem, char *buf)
diff --git a/include/linux/uio_driver.h b/include/linux/uio_driver.h
index 1ad4724..df6e42e 100644
--- a/include/linux/uio_driver.h
+++ b/include/linux/uio_driver.h
@@ -35,7 +35,7 @@ struct uio_map;
 struct uio_mem {
 	const char		*name;
 	phys_addr_t		addr;
-	unsigned long		size;
+	resource_size_t		size;
 	int			memtype;
 	void __iomem		*internal_addr;
 	struct uio_map		*map;
-- 
1.8.3.1

