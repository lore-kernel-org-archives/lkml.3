Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372Ab3AYI6t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 03:58:49 -0500
Received: from mga01.intel.com ([192.55.52.88]:50291 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305Ab3AYI6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 03:58:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,537,1355126400"; 
   d="scan'208,223";a="282060313"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: [PATCH V2 2/3] Move xen_acpi_get_pxm to Xen acpi.h
Thread-Topic: [PATCH V2 2/3] Move xen_acpi_get_pxm to Xen acpi.h
Thread-Index: Ac362hivuuMRySg4TwKIMMRp5fP8JQ==
Date: Fri, 25 Jan 2013 08:58:09 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923353DD6F5@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC82923353DD6F5SHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC82923353DD6F5SHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From ede9d238638c12dc80e08187500f4ef163e49a49 Mon Sep 17 00:00:00 2001
From: Liu Jinsong <jinsong.liu@intel.com>
Date: Fri, 25 Jan 2013 15:42:31 +0800
Subject: [PATCH 2/3] Move xen_acpi_get_pxm to Xen acpi.h

So that it could be reused by Xen CPU hotplug logic.

Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
---
 drivers/xen/xen-acpi-memhotplug.c |   18 ------------------
 include/xen/acpi.h                |   18 ++++++++++++++++++
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/xen/xen-acpi-memhotplug.c b/drivers/xen/xen-acpi-memho=
tplug.c
index 2c3759a..678680c 100644
--- a/drivers/xen/xen-acpi-memhotplug.c
+++ b/drivers/xen/xen-acpi-memhotplug.c
@@ -65,24 +65,6 @@ static int xen_hotadd_memory(int pxm, struct acpi_memory=
_info *info)
 	return rc;
 }
=20
-static int xen_acpi_get_pxm(acpi_handle h)
-{
-	unsigned long long pxm;
-	acpi_status status;
-	acpi_handle handle;
-	acpi_handle phandle =3D h;
-
-	do {
-		handle =3D phandle;
-		status =3D acpi_evaluate_integer(handle, "_PXM", NULL, &pxm);
-		if (ACPI_SUCCESS(status))
-			return pxm;
-		status =3D acpi_get_parent(handle, &phandle);
-	} while (ACPI_SUCCESS(status));
-
-	return -ENXIO;
-}
-
 static int xen_acpi_memory_enable_device(struct acpi_memory_device *mem_de=
vice)
 {
 	int pxm, result;
diff --git a/include/xen/acpi.h b/include/xen/acpi.h
index 2b3103b..dc69c91 100644
--- a/include/xen/acpi.h
+++ b/include/xen/acpi.h
@@ -69,4 +69,22 @@ static inline void xen_acpi_sleep_register(void)
 }
 #endif
=20
+static inline int xen_acpi_get_pxm(acpi_handle h)
+{
+	unsigned long long pxm;
+	acpi_status status;
+	acpi_handle handle;
+	acpi_handle phandle =3D h;
+
+	do {
+		handle =3D phandle;
+		status =3D acpi_evaluate_integer(handle, "_PXM", NULL, &pxm);
+		if (ACPI_SUCCESS(status))
+			return pxm;
+		status =3D acpi_get_parent(handle, &phandle);
+	} while (ACPI_SUCCESS(status));
+
+	return -ENXIO;
+}
+
 #endif	/* _XEN_ACPI_H */
--=20
1.7.1

--_002_DE8DF0795D48FD4CA783C40EC82923353DD6F5SHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0002-Move-xen_acpi_get_pxm-to-Xen-acpi.h.patch"
Content-Description: 0002-Move-xen_acpi_get_pxm-to-Xen-acpi.h.patch
Content-Disposition: attachment;
	filename="0002-Move-xen_acpi_get_pxm-to-Xen-acpi.h.patch"; size=1928;
	creation-date="Fri, 25 Jan 2013 08:52:32 GMT";
	modification-date="Fri, 25 Jan 2013 16:45:18 GMT"
Content-Transfer-Encoding: base64

RnJvbSBlZGU5ZDIzODYzOGMxMmRjODBlMDgxODc1MDBmNGVmMTYzZTQ5YTQ5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUgSmluc29uZyA8amluc29uZy5saXVAaW50ZWwuY29tPgpE
YXRlOiBGcmksIDI1IEphbiAyMDEzIDE1OjQyOjMxICswODAwClN1YmplY3Q6IFtQQVRDSCAyLzNd
IE1vdmUgeGVuX2FjcGlfZ2V0X3B4bSB0byBYZW4gYWNwaS5oCgpTbyB0aGF0IGl0IGNvdWxkIGJl
IHJldXNlZCBieSBYZW4gQ1BVIGhvdHBsdWcgbG9naWMuCgpTaWduZWQtb2ZmLWJ5OiBMaXUsIEpp
bnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4KLS0tCiBkcml2ZXJzL3hlbi94ZW4tYWNwaS1t
ZW1ob3RwbHVnLmMgfCAgIDE4IC0tLS0tLS0tLS0tLS0tLS0tLQogaW5jbHVkZS94ZW4vYWNwaS5o
ICAgICAgICAgICAgICAgIHwgICAxOCArKysrKysrKysrKysrKysrKysKIDIgZmlsZXMgY2hhbmdl
ZCwgMTggaW5zZXJ0aW9ucygrKSwgMTggZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy94ZW4veGVuLWFjcGktbWVtaG90cGx1Zy5jIGIvZHJpdmVycy94ZW4veGVuLWFjcGktbWVtaG90
cGx1Zy5jCmluZGV4IDJjMzc1OWEuLjY3ODY4MGMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMveGVuL3hl
bi1hY3BpLW1lbWhvdHBsdWcuYworKysgYi9kcml2ZXJzL3hlbi94ZW4tYWNwaS1tZW1ob3RwbHVn
LmMKQEAgLTY1LDI0ICs2NSw2IEBAIHN0YXRpYyBpbnQgeGVuX2hvdGFkZF9tZW1vcnkoaW50IHB4
bSwgc3RydWN0IGFjcGlfbWVtb3J5X2luZm8gKmluZm8pCiAJcmV0dXJuIHJjOwogfQogCi1zdGF0
aWMgaW50IHhlbl9hY3BpX2dldF9weG0oYWNwaV9oYW5kbGUgaCkKLXsKLQl1bnNpZ25lZCBsb25n
IGxvbmcgcHhtOwotCWFjcGlfc3RhdHVzIHN0YXR1czsKLQlhY3BpX2hhbmRsZSBoYW5kbGU7Ci0J
YWNwaV9oYW5kbGUgcGhhbmRsZSA9IGg7Ci0KLQlkbyB7Ci0JCWhhbmRsZSA9IHBoYW5kbGU7Ci0J
CXN0YXR1cyA9IGFjcGlfZXZhbHVhdGVfaW50ZWdlcihoYW5kbGUsICJfUFhNIiwgTlVMTCwgJnB4
bSk7Ci0JCWlmIChBQ1BJX1NVQ0NFU1Moc3RhdHVzKSkKLQkJCXJldHVybiBweG07Ci0JCXN0YXR1
cyA9IGFjcGlfZ2V0X3BhcmVudChoYW5kbGUsICZwaGFuZGxlKTsKLQl9IHdoaWxlIChBQ1BJX1NV
Q0NFU1Moc3RhdHVzKSk7Ci0KLQlyZXR1cm4gLUVOWElPOwotfQotCiBzdGF0aWMgaW50IHhlbl9h
Y3BpX21lbW9yeV9lbmFibGVfZGV2aWNlKHN0cnVjdCBhY3BpX21lbW9yeV9kZXZpY2UgKm1lbV9k
ZXZpY2UpCiB7CiAJaW50IHB4bSwgcmVzdWx0OwpkaWZmIC0tZ2l0IGEvaW5jbHVkZS94ZW4vYWNw
aS5oIGIvaW5jbHVkZS94ZW4vYWNwaS5oCmluZGV4IDJiMzEwM2IuLmRjNjljOTEgMTAwNjQ0Ci0t
LSBhL2luY2x1ZGUveGVuL2FjcGkuaAorKysgYi9pbmNsdWRlL3hlbi9hY3BpLmgKQEAgLTY5LDQg
KzY5LDIyIEBAIHN0YXRpYyBpbmxpbmUgdm9pZCB4ZW5fYWNwaV9zbGVlcF9yZWdpc3Rlcih2b2lk
KQogfQogI2VuZGlmCiAKK3N0YXRpYyBpbmxpbmUgaW50IHhlbl9hY3BpX2dldF9weG0oYWNwaV9o
YW5kbGUgaCkKK3sKKwl1bnNpZ25lZCBsb25nIGxvbmcgcHhtOworCWFjcGlfc3RhdHVzIHN0YXR1
czsKKwlhY3BpX2hhbmRsZSBoYW5kbGU7CisJYWNwaV9oYW5kbGUgcGhhbmRsZSA9IGg7CisKKwlk
byB7CisJCWhhbmRsZSA9IHBoYW5kbGU7CisJCXN0YXR1cyA9IGFjcGlfZXZhbHVhdGVfaW50ZWdl
cihoYW5kbGUsICJfUFhNIiwgTlVMTCwgJnB4bSk7CisJCWlmIChBQ1BJX1NVQ0NFU1Moc3RhdHVz
KSkKKwkJCXJldHVybiBweG07CisJCXN0YXR1cyA9IGFjcGlfZ2V0X3BhcmVudChoYW5kbGUsICZw
aGFuZGxlKTsKKwl9IHdoaWxlIChBQ1BJX1NVQ0NFU1Moc3RhdHVzKSk7CisKKwlyZXR1cm4gLUVO
WElPOworfQorCiAjZW5kaWYJLyogX1hFTl9BQ1BJX0ggKi8KLS0gCjEuNy4xCgo=

--_002_DE8DF0795D48FD4CA783C40EC82923353DD6F5SHSMSX101ccrcorpi_--
