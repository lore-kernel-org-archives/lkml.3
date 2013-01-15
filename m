Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab3AOMbv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 07:31:51 -0500
Received: from mga03.intel.com ([143.182.124.21]:53130 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754772Ab3AOMbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 07:31:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,473,1355126400"; 
   d="scan'208,223";a="191309136"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: [PATCH V1 2/3] Move xen_acpi_get_pxm to Xen acpi.h
Thread-Topic: [PATCH V1 2/3] Move xen_acpi_get_pxm to Xen acpi.h
Thread-Index: Ac3zHEfaFx+WnqICQZeNdLNYmByf4A==
Date: Tue, 15 Jan 2013 12:31:45 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923353C3DCA@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC82923353C3DCASHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC82923353C3DCASHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From 398b5a92a407aeaf5d1497e4060490d135d4897a Mon Sep 17 00:00:00 2001
From: Liu Jinsong <jinsong.liu@intel.com>
Date: Mon, 14 Jan 2013 20:31:04 +0800
Subject: [PATCH 2/3] Move xen_acpi_get_pxm to Xen acpi.h

So that it could be reused by Xen CPU hotplug logic.

Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
---
 drivers/xen/xen-acpi-memhotplug.c |   18 ------------------
 include/xen/acpi.h                |   18 ++++++++++++++++++
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/xen/xen-acpi-memhotplug.c b/drivers/xen/xen-acpi-memho=
tplug.c
index 346d80b..f01d425 100644
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
index 1c99eb5..5ac46d3 100644
--- a/include/xen/acpi.h
+++ b/include/xen/acpi.h
@@ -46,6 +46,24 @@
=20
 extern struct acpi_driver xen_stub_memory_device_driver;
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
 #define ACPI_PROCESSOR_CLASS            "processor"
 #define ACPI_PROCESSOR_DEVICE_HID       "ACPI0007"
 #define ACPI_PROCESSOR_DEVICE_NAME      "Processor"
--=20
1.7.1

--_002_DE8DF0795D48FD4CA783C40EC82923353C3DCASHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0002-Move-xen_acpi_get_pxm-to-Xen-acpi.h.patch"
Content-Description: 0002-Move-xen_acpi_get_pxm-to-Xen-acpi.h.patch
Content-Disposition: attachment;
	filename="0002-Move-xen_acpi_get_pxm-to-Xen-acpi.h.patch"; size=2060;
	creation-date="Tue, 15 Jan 2013 12:28:09 GMT";
	modification-date="Tue, 15 Jan 2013 20:17:12 GMT"
Content-Transfer-Encoding: base64

RnJvbSAzOThiNWE5MmE0MDdhZWFmNWQxNDk3ZTQwNjA0OTBkMTM1ZDQ4OTdhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUgSmluc29uZyA8amluc29uZy5saXVAaW50ZWwuY29tPgpE
YXRlOiBNb24sIDE0IEphbiAyMDEzIDIwOjMxOjA0ICswODAwClN1YmplY3Q6IFtQQVRDSCAyLzNd
IE1vdmUgeGVuX2FjcGlfZ2V0X3B4bSB0byBYZW4gYWNwaS5oCgpTbyB0aGF0IGl0IGNvdWxkIGJl
IHJldXNlZCBieSBYZW4gQ1BVIGhvdHBsdWcgbG9naWMuCgpTaWduZWQtb2ZmLWJ5OiBMaXUsIEpp
bnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4KLS0tCiBkcml2ZXJzL3hlbi94ZW4tYWNwaS1t
ZW1ob3RwbHVnLmMgfCAgIDE4IC0tLS0tLS0tLS0tLS0tLS0tLQogaW5jbHVkZS94ZW4vYWNwaS5o
ICAgICAgICAgICAgICAgIHwgICAxOCArKysrKysrKysrKysrKysrKysKIDIgZmlsZXMgY2hhbmdl
ZCwgMTggaW5zZXJ0aW9ucygrKSwgMTggZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy94ZW4veGVuLWFjcGktbWVtaG90cGx1Zy5jIGIvZHJpdmVycy94ZW4veGVuLWFjcGktbWVtaG90
cGx1Zy5jCmluZGV4IDM0NmQ4MGIuLmYwMWQ0MjUgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMveGVuL3hl
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
aS5oIGIvaW5jbHVkZS94ZW4vYWNwaS5oCmluZGV4IDFjOTllYjUuLjVhYzQ2ZDMgMTAwNjQ0Ci0t
LSBhL2luY2x1ZGUveGVuL2FjcGkuaAorKysgYi9pbmNsdWRlL3hlbi9hY3BpLmgKQEAgLTQ2LDYg
KzQ2LDI0IEBACiAKIGV4dGVybiBzdHJ1Y3QgYWNwaV9kcml2ZXIgeGVuX3N0dWJfbWVtb3J5X2Rl
dmljZV9kcml2ZXI7CiAKK3N0YXRpYyBpbmxpbmUgaW50IHhlbl9hY3BpX2dldF9weG0oYWNwaV9o
YW5kbGUgaCkKK3sKKwl1bnNpZ25lZCBsb25nIGxvbmcgcHhtOworCWFjcGlfc3RhdHVzIHN0YXR1
czsKKwlhY3BpX2hhbmRsZSBoYW5kbGU7CisJYWNwaV9oYW5kbGUgcGhhbmRsZSA9IGg7CisKKwlk
byB7CisJCWhhbmRsZSA9IHBoYW5kbGU7CisJCXN0YXR1cyA9IGFjcGlfZXZhbHVhdGVfaW50ZWdl
cihoYW5kbGUsICJfUFhNIiwgTlVMTCwgJnB4bSk7CisJCWlmIChBQ1BJX1NVQ0NFU1Moc3RhdHVz
KSkKKwkJCXJldHVybiBweG07CisJCXN0YXR1cyA9IGFjcGlfZ2V0X3BhcmVudChoYW5kbGUsICZw
aGFuZGxlKTsKKwl9IHdoaWxlIChBQ1BJX1NVQ0NFU1Moc3RhdHVzKSk7CisKKwlyZXR1cm4gLUVO
WElPOworfQorCiAjZGVmaW5lIEFDUElfUFJPQ0VTU09SX0NMQVNTICAgICAgICAgICAgInByb2Nl
c3NvciIKICNkZWZpbmUgQUNQSV9QUk9DRVNTT1JfREVWSUNFX0hJRCAgICAgICAiQUNQSTAwMDci
CiAjZGVmaW5lIEFDUElfUFJPQ0VTU09SX0RFVklDRV9OQU1FICAgICAgIlByb2Nlc3NvciIKLS0g
CjEuNy4xCgo=

--_002_DE8DF0795D48FD4CA783C40EC82923353C3DCASHSMSX101ccrcorpi_--
