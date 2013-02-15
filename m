Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900Ab3BORGm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 12:06:42 -0500
Received: from mga14.intel.com ([143.182.124.37]:65081 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967Ab3BORGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 12:06:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,674,1355126400"; 
   d="scan'208,223";a="257545152"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Wu, Fengguang" <fengguang.wu@intel.com>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: [PATCH] xen/acpi: updates the argument of .remove operation of xen
 cpu/mem hotplug
Thread-Topic: [PATCH] xen/acpi: updates the argument of .remove operation of
 xen cpu/mem hotplug
Thread-Index: Ac4LnswpXP+OkzAJSRiFL0LSDoC8QQ==
Date: Fri, 15 Feb 2013 17:06:30 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923353FBF3A@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC82923353FBF3ASHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC82923353FBF3ASHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From 3e27e90049354a0f52fd006970fc8ecd80b08152 Mon Sep 17 00:00:00 2001
From: Liu Jinsong <jinsong.liu@intel.com>
Date: Sat, 16 Feb 2013 00:42:45 +0800
Subject: [PATCH] xen/acpi: updates the argument of .remove operation of xen=
 cpu/mem hotplug

Rafael removed useless type argument of acpi driver .remove operation.
This patch updates the argument of .remove operation of xen cpu/memory
driver accordingly.

Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
---
 drivers/xen/xen-acpi-cpuhotplug.c |    2 +-
 drivers/xen/xen-acpi-memhotplug.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/xen-acpi-cpuhotplug.c b/drivers/xen/xen-acpi-cpuho=
tplug.c
index acc5b12..7578279 100644
--- a/drivers/xen/xen-acpi-cpuhotplug.c
+++ b/drivers/xen/xen-acpi-cpuhotplug.c
@@ -113,7 +113,7 @@ static int __cpuinit xen_acpi_processor_add(struct acpi=
_device *device)
 	return ret;
 }
=20
-static int xen_acpi_processor_remove(struct acpi_device *device, int type)
+static int xen_acpi_processor_remove(struct acpi_device *device)
 {
 	struct acpi_processor *pr;
=20
diff --git a/drivers/xen/xen-acpi-memhotplug.c b/drivers/xen/xen-acpi-memho=
tplug.c
index 164287b..853b12d 100644
--- a/drivers/xen/xen-acpi-memhotplug.c
+++ b/drivers/xen/xen-acpi-memhotplug.c
@@ -329,7 +329,7 @@ static int xen_acpi_memory_device_add(struct acpi_devic=
e *device)
 	return result;
 }
=20
-static int xen_acpi_memory_device_remove(struct acpi_device *device, int t=
ype)
+static int xen_acpi_memory_device_remove(struct acpi_device *device)
 {
 	struct acpi_memory_device *mem_device =3D NULL;
=20
--=20
1.7.1

--_002_DE8DF0795D48FD4CA783C40EC82923353FBF3ASHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0001-xen-acpi-updates-the-argument-of-.remove-operation-o.patch"
Content-Description: 0001-xen-acpi-updates-the-argument-of-.remove-operation-o.patch
Content-Disposition: attachment;
	filename="0001-xen-acpi-updates-the-argument-of-.remove-operation-o.patch";
	size=1598; creation-date="Fri, 15 Feb 2013 16:54:20 GMT";
	modification-date="Sat, 16 Feb 2013 00:44:00 GMT"
Content-Transfer-Encoding: base64

RnJvbSAzZTI3ZTkwMDQ5MzU0YTBmNTJmZDAwNjk3MGZjOGVjZDgwYjA4MTUyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUgSmluc29uZyA8amluc29uZy5saXVAaW50ZWwuY29tPgpE
YXRlOiBTYXQsIDE2IEZlYiAyMDEzIDAwOjQyOjQ1ICswODAwClN1YmplY3Q6IFtQQVRDSF0geGVu
L2FjcGk6IHVwZGF0ZXMgdGhlIGFyZ3VtZW50IG9mIC5yZW1vdmUgb3BlcmF0aW9uIG9mIHhlbiBj
cHUvbWVtIGhvdHBsdWcKClJhZmFlbCByZW1vdmVkIHVzZWxlc3MgdHlwZSBhcmd1bWVudCBvZiBh
Y3BpIGRyaXZlciAucmVtb3ZlIG9wZXJhdGlvbi4KVGhpcyBwYXRjaCB1cGRhdGVzIHRoZSBhcmd1
bWVudCBvZiAucmVtb3ZlIG9wZXJhdGlvbiBvZiB4ZW4gY3B1L21lbW9yeQpkcml2ZXIgYWNjb3Jk
aW5nbHkuCgpTaWduZWQtb2ZmLWJ5OiBMaXUgSmluc29uZyA8amluc29uZy5saXVAaW50ZWwuY29t
PgotLS0KIGRyaXZlcnMveGVuL3hlbi1hY3BpLWNwdWhvdHBsdWcuYyB8ICAgIDIgKy0KIGRyaXZl
cnMveGVuL3hlbi1hY3BpLW1lbWhvdHBsdWcuYyB8ICAgIDIgKy0KIDIgZmlsZXMgY2hhbmdlZCwg
MiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMveGVu
L3hlbi1hY3BpLWNwdWhvdHBsdWcuYyBiL2RyaXZlcnMveGVuL3hlbi1hY3BpLWNwdWhvdHBsdWcu
YwppbmRleCBhY2M1YjEyLi43NTc4Mjc5IDEwMDY0NAotLS0gYS9kcml2ZXJzL3hlbi94ZW4tYWNw
aS1jcHVob3RwbHVnLmMKKysrIGIvZHJpdmVycy94ZW4veGVuLWFjcGktY3B1aG90cGx1Zy5jCkBA
IC0xMTMsNyArMTEzLDcgQEAgc3RhdGljIGludCBfX2NwdWluaXQgeGVuX2FjcGlfcHJvY2Vzc29y
X2FkZChzdHJ1Y3QgYWNwaV9kZXZpY2UgKmRldmljZSkKIAlyZXR1cm4gcmV0OwogfQogCi1zdGF0
aWMgaW50IHhlbl9hY3BpX3Byb2Nlc3Nvcl9yZW1vdmUoc3RydWN0IGFjcGlfZGV2aWNlICpkZXZp
Y2UsIGludCB0eXBlKQorc3RhdGljIGludCB4ZW5fYWNwaV9wcm9jZXNzb3JfcmVtb3ZlKHN0cnVj
dCBhY3BpX2RldmljZSAqZGV2aWNlKQogewogCXN0cnVjdCBhY3BpX3Byb2Nlc3NvciAqcHI7CiAK
ZGlmZiAtLWdpdCBhL2RyaXZlcnMveGVuL3hlbi1hY3BpLW1lbWhvdHBsdWcuYyBiL2RyaXZlcnMv
eGVuL3hlbi1hY3BpLW1lbWhvdHBsdWcuYwppbmRleCAxNjQyODdiLi44NTNiMTJkIDEwMDY0NAot
LS0gYS9kcml2ZXJzL3hlbi94ZW4tYWNwaS1tZW1ob3RwbHVnLmMKKysrIGIvZHJpdmVycy94ZW4v
eGVuLWFjcGktbWVtaG90cGx1Zy5jCkBAIC0zMjksNyArMzI5LDcgQEAgc3RhdGljIGludCB4ZW5f
YWNwaV9tZW1vcnlfZGV2aWNlX2FkZChzdHJ1Y3QgYWNwaV9kZXZpY2UgKmRldmljZSkKIAlyZXR1
cm4gcmVzdWx0OwogfQogCi1zdGF0aWMgaW50IHhlbl9hY3BpX21lbW9yeV9kZXZpY2VfcmVtb3Zl
KHN0cnVjdCBhY3BpX2RldmljZSAqZGV2aWNlLCBpbnQgdHlwZSkKK3N0YXRpYyBpbnQgeGVuX2Fj
cGlfbWVtb3J5X2RldmljZV9yZW1vdmUoc3RydWN0IGFjcGlfZGV2aWNlICpkZXZpY2UpCiB7CiAJ
c3RydWN0IGFjcGlfbWVtb3J5X2RldmljZSAqbWVtX2RldmljZSA9IE5VTEw7CiAKLS0gCjEuNy4x
Cgo=

--_002_DE8DF0795D48FD4CA783C40EC82923353FBF3ASHSMSX101ccrcorpi_--
