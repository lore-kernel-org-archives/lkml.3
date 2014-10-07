Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330AbaJGPkh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 11:40:37 -0400
Received: from mail-by2on0110.outbound.protection.outlook.com ([207.46.100.110]:14624
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753169AbaJGPke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 11:40:34 -0400
X-Greylist: delayed 854 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Oct 2014 11:40:34 EDT
From: Cristian Stoica <cristian.stoica@freescale.com>
To: <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <hjk@hansjkoch.de>
CC: Cristian Stoica <cristian.stoica@freescale.com>
Subject: [PATCH 2/2] uio: support memory sizes larger than 32 bits
Date: Tue, 7 Oct 2014 18:25:44 +0300
Message-ID: <1412695544-17251-2-git-send-email-cristian.stoica@freescale.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1412695544-17251-1-git-send-email-cristian.stoica@freescale.com>
References: <1412695544-17251-1-git-send-email-cristian.stoica@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(448002)(189002)(199003)(19580395003)(50226001)(120916001)(84676001)(48376002)(19580405001)(92726001)(99396003)(6806004)(80022003)(92566001)(33646002)(68736004)(20776003)(4396001)(107046002)(44976005)(97736003)(50986999)(76176999)(2201001)(106466001)(81156004)(50466002)(229853001)(69596002)(76482002)(46102003)(93916002)(95666004)(104016003)(31966008)(104166001)(85326001)(77156001)(26826002)(87936001)(64706001)(21056001)(47776003)(87286001)(88136002)(85306004)(36756003)(85852003)(62966002)(89996001)(102836001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0616;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0616;
X-Forefront-PRVS: 035748864E
Authentication-Results: spf=permerror (sender IP is 192.88.158.2)
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
 drivers/uio/uio.c                    | 2 +-
 include/linux/uio_driver.h           | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

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
index a673e5b..eaa7347 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -73,7 +73,7 @@ static ssize_t map_addr_show(struct uio_mem *mem, char *buf)
 
 static ssize_t map_size_show(struct uio_mem *mem, char *buf)
 {
-	return sprintf(buf, "0x%lx\n", mem->size);
+	return sprintf(buf, "0x%llx\n", (unsigned long long)mem->size);
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

