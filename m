Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab3CKPK4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 11:10:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:11637 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302Ab3CKPKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 11:10:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,824,1355126400"; 
   d="scan'208,223";a="300024216"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        xen-devel <xen-devel@lists.xen.org>
Subject: [PATCH] Xen/acpi: remove redundant acpi/acpi_drivers.h include
Thread-Topic: [PATCH] Xen/acpi: remove redundant acpi/acpi_drivers.h include
Thread-Index: Ac4eapbhmCuu9fC9QyugkXZ4r0AnOQ==
Date: Mon, 11 Mar 2013 15:10:40 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC8292335422404@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC8292335422404SHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC8292335422404SHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From 3e039eaf865a98971d7316e28c4ee5f3cba1d634 Mon Sep 17 00:00:00 2001
From: Liu Jinsong <jinsong.liu@intel.com>
Date: Tue, 12 Mar 2013 06:42:16 +0800
Subject: [PATCH] Xen/acpi: remove redundant acpi/acpi_drivers.h include

It's redundant since linux/acpi.h has include it when CONFIG_ACPI enabled,
and when CONFIG_ACPI disabled it will trigger compiling warning

In file included from drivers/xen/xen-stub.c:28:0:
include/acpi/acpi_drivers.h:103:31:
warning: 'struct acpi_device' declared inside parameter list [enabled by de=
fault]
include/acpi/acpi_drivers.h:103:31:
warning: its scope is only this definition or declaration, which is probabl=
y not what you want [enabled by default]
include/acpi/acpi_drivers.h:107:43:
warning: 'struct acpi_pci_root' declared inside parameter list [enabled by =
default]

Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
---
 drivers/xen/xen-stub.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/xen-stub.c b/drivers/xen/xen-stub.c
index d85e411..bbef194 100644
--- a/drivers/xen/xen-stub.c
+++ b/drivers/xen/xen-stub.c
@@ -25,7 +25,6 @@
 #include <linux/export.h>
 #include <linux/types.h>
 #include <linux/acpi.h>
-#include <acpi/acpi_drivers.h>
 #include <xen/acpi.h>
=20
 #ifdef CONFIG_ACPI
--=20
1.7.1

--_002_DE8DF0795D48FD4CA783C40EC8292335422404SHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0001-Xen-acpi-remove-redundant-acpi-acpi_drivers.h-includ.patch"
Content-Description: 0001-Xen-acpi-remove-redundant-acpi-acpi_drivers.h-includ.patch
Content-Disposition: attachment;
	filename="0001-Xen-acpi-remove-redundant-acpi-acpi_drivers.h-includ.patch";
	size=1329; creation-date="Mon, 11 Mar 2013 15:07:30 GMT";
	modification-date="Mon, 11 Mar 2013 22:52:04 GMT"
Content-Transfer-Encoding: base64

RnJvbSAzZTAzOWVhZjg2NWE5ODk3MWQ3MzE2ZTI4YzRlZTVmM2NiYTFkNjM0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUgSmluc29uZyA8amluc29uZy5saXVAaW50ZWwuY29tPgpE
YXRlOiBUdWUsIDEyIE1hciAyMDEzIDA2OjQyOjE2ICswODAwClN1YmplY3Q6IFtQQVRDSF0gWGVu
L2FjcGk6IHJlbW92ZSByZWR1bmRhbnQgYWNwaS9hY3BpX2RyaXZlcnMuaCBpbmNsdWRlCgpJdCdz
IHJlZHVuZGFudCBzaW5jZSBsaW51eC9hY3BpLmggaGFzIGluY2x1ZGUgaXQgd2hlbiBDT05GSUdf
QUNQSSBlbmFibGVkLAphbmQgd2hlbiBDT05GSUdfQUNQSSBkaXNhYmxlZCBpdCB3aWxsIHRyaWdn
ZXIgY29tcGlsaW5nIHdhcm5pbmcKCkluIGZpbGUgaW5jbHVkZWQgZnJvbSBkcml2ZXJzL3hlbi94
ZW4tc3R1Yi5jOjI4OjA6CmluY2x1ZGUvYWNwaS9hY3BpX2RyaXZlcnMuaDoxMDM6MzE6Cndhcm5p
bmc6ICdzdHJ1Y3QgYWNwaV9kZXZpY2UnIGRlY2xhcmVkIGluc2lkZSBwYXJhbWV0ZXIgbGlzdCBb
ZW5hYmxlZCBieSBkZWZhdWx0XQppbmNsdWRlL2FjcGkvYWNwaV9kcml2ZXJzLmg6MTAzOjMxOgp3
YXJuaW5nOiBpdHMgc2NvcGUgaXMgb25seSB0aGlzIGRlZmluaXRpb24gb3IgZGVjbGFyYXRpb24s
IHdoaWNoIGlzIHByb2JhYmx5IG5vdCB3aGF0IHlvdSB3YW50IFtlbmFibGVkIGJ5IGRlZmF1bHRd
CmluY2x1ZGUvYWNwaS9hY3BpX2RyaXZlcnMuaDoxMDc6NDM6Cndhcm5pbmc6ICdzdHJ1Y3QgYWNw
aV9wY2lfcm9vdCcgZGVjbGFyZWQgaW5zaWRlIHBhcmFtZXRlciBsaXN0IFtlbmFibGVkIGJ5IGRl
ZmF1bHRdCgpSZXBvcnRlZC1ieTogV3UgRmVuZ2d1YW5nIDxmZW5nZ3Vhbmcud3VAaW50ZWwuY29t
PgpTaWduZWQtb2ZmLWJ5OiBMaXUgSmluc29uZyA8amluc29uZy5saXVAaW50ZWwuY29tPgotLS0K
IGRyaXZlcnMveGVuL3hlbi1zdHViLmMgfCAgICAxIC0KIDEgZmlsZXMgY2hhbmdlZCwgMCBpbnNl
cnRpb25zKCspLCAxIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMveGVuL3hlbi1z
dHViLmMgYi9kcml2ZXJzL3hlbi94ZW4tc3R1Yi5jCmluZGV4IGQ4NWU0MTEuLmJiZWYxOTQgMTAw
NjQ0Ci0tLSBhL2RyaXZlcnMveGVuL3hlbi1zdHViLmMKKysrIGIvZHJpdmVycy94ZW4veGVuLXN0
dWIuYwpAQCAtMjUsNyArMjUsNiBAQAogI2luY2x1ZGUgPGxpbnV4L2V4cG9ydC5oPgogI2luY2x1
ZGUgPGxpbnV4L3R5cGVzLmg+CiAjaW5jbHVkZSA8bGludXgvYWNwaS5oPgotI2luY2x1ZGUgPGFj
cGkvYWNwaV9kcml2ZXJzLmg+CiAjaW5jbHVkZSA8eGVuL2FjcGkuaD4KIAogI2lmZGVmIENPTkZJ
R19BQ1BJCi0tIAoxLjcuMQoK

--_002_DE8DF0795D48FD4CA783C40EC8292335422404SHSMSX101ccrcorpi_--
