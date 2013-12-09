Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933877Ab3LIPue (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 10:50:34 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:48663 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932468Ab3LIPud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 10:50:33 -0500
MIME-Version: 1.0
Date: Mon, 9 Dec 2013 07:50:32 -0800
Message-ID: <CAMe9rOo9sUQiusm8u=eFDnxYz37Cczd+97M9in=P2mNWXpH5pQ@mail.gmail.com>
Subject: [PATCH] binfmt_elf: fix PIE load with randomization disabled
From: "H.J. Lu" <hjl.tools@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        Josh Boyer <jwboyer@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: multipart/mixed; boundary=089e01183706b6ee3704ed1bf4cd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e01183706b6ee3704ed1bf4cd
Content-Type: text/plain; charset=ISO-8859-1

Normally, a PIE executable has zero virtual address on the first PT_LOAD
segment and kernel will load such executable at random address when
randomization is enabled.  If randomization is disabled, kernel will load
it at a fixed address.  But if a PIE executable has non-zero virtual
address on the first PT_LOAD segment, kernel will load such executable
at the non-zero virtual address when randomization is enabled. But when
randomization is disabled, kernel ignores the non-zero virtual address
at the non-zero virtual address when randomization is enabled. But when
randomization is disabled, kernel ignores the non-zero virtual address
on the first PT_LOAD segment and loads it at the fixed address.  This
patch makes kernel consistent by loading PIE executable with non-zero
virtual address at the non-zero virtual address, regardless if
randomization is enabled or disabled.


-- 
H.J

--089e01183706b6ee3704ed1bf4cd
Content-Type: text/plain; charset=US-ASCII; 
	name="0001-binfmt_elf-fix-PIE-load-with-randomization-disabled.patch"
Content-Disposition: attachment; 
	filename="0001-binfmt_elf-fix-PIE-load-with-randomization-disabled.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hozwcq9o0

RnJvbSBlZWUxZjFmNGY2MGViMWYxMTM5YWMzMTFlNzg3ZmFjNTBhY2NkZTMwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiAiSC5KLiBMdSIgPGhqbC50b29sc0BnbWFpbC5jb20+CkRhdGU6
IEZyaSwgNiBEZWMgMjAxMyAxMjo0NDo0MSAtMDgwMApTdWJqZWN0OiBbUEFUQ0hdIGJpbmZtdF9l
bGY6IGZpeCBQSUUgbG9hZCB3aXRoIHJhbmRvbWl6YXRpb24gZGlzYWJsZWQKCk5vcm1hbGx5LCBh
IFBJRSBleGVjdXRhYmxlIGhhcyB6ZXJvIHZpcnR1YWwgYWRkcmVzcyBvbiB0aGUgZmlyc3QgUFRf
TE9BRApzZWdtZW50IGFuZCBrZXJuZWwgd2lsbCBsb2FkIHN1Y2ggZXhlY3V0YWJsZSBhdCByYW5k
b20gYWRkcmVzcyB3aGVuCnJhbmRvbWl6YXRpb24gaXMgZW5hYmxlZC4gIElmIHJhbmRvbWl6YXRp
b24gaXMgZGlzYWJsZWQsIGtlcm5lbCB3aWxsIGxvYWQKaXQgYXQgYSBmaXhlZCBhZGRyZXNzLiAg
QnV0IGlmIGEgUElFIGV4ZWN1dGFibGUgaGFzIG5vbi16ZXJvIHZpcnR1YWwKYWRkcmVzcyBvbiB0
aGUgZmlyc3QgUFRfTE9BRCBzZWdtZW50LCBrZXJuZWwgd2lsbCBsb2FkIHN1Y2ggZXhlY3V0YWJs
ZQphdCB0aGUgbm9uLXplcm8gdmlydHVhbCBhZGRyZXNzIHdoZW4gcmFuZG9taXphdGlvbiBpcyBl
bmFibGVkLiBCdXQgd2hlbgpyYW5kb21pemF0aW9uIGlzIGRpc2FibGVkLCBrZXJuZWwgaWdub3Jl
cyB0aGUgbm9uLXplcm8gdmlydHVhbCBhZGRyZXNzCm9uIHRoZSBmaXJzdCBQVF9MT0FEIHNlZ21l
bnQgYW5kIGxvYWRzIGl0IGF0IHRoZSBmaXhlZCBhZGRyZXNzLiAgVGhpcwpwYXRjaCBtYWtlcyBr
ZXJuZWwgY29uc2lzdGVudCBieSBsb2FkaW5nIFBJRSBleGVjdXRhYmxlIHdpdGggbm9uLXplcm8K
dmlydHVhbCBhZGRyZXNzIGF0IHRoZSBub24temVybyB2aXJ0dWFsIGFkZHJlc3MsIHJlZ2FyZGxl
c3MgaWYKcmFuZG9taXphdGlvbiBpcyBlbmFibGVkIG9yIGRpc2FibGVkLgoKU2lnbmVkLW9mZi1i
eTogSC5KLiBMdSA8aGpsLnRvb2xzQGdtYWlsLmNvbT4KLS0tCiBmcy9iaW5mbXRfZWxmLmMgfCA3
ICsrKysrKy0KIDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkK
CmRpZmYgLS1naXQgYS9mcy9iaW5mbXRfZWxmLmMgYi9mcy9iaW5mbXRfZWxmLmMKaW5kZXggNGM5
NGE3OS4uYTNmZDRkZSAxMDA2NDQKLS0tIGEvZnMvYmluZm10X2VsZi5jCisrKyBiL2ZzL2JpbmZt
dF9lbGYuYwpAQCAtODA5LDggKzgwOSwxMyBAQCBzdGF0aWMgaW50IGxvYWRfZWxmX2JpbmFyeShz
dHJ1Y3QgbGludXhfYmlucHJtICpicHJtKQogCQkJICogSWYgdGhhdCBpcyB0aGUgY2FzZSwgcmV0
YWluIHRoZSBvcmlnaW5hbCBub24temVybwogCQkJICogbG9hZF9iaWFzIHZhbHVlIGluIG9yZGVy
IHRvIGVzdGFibGlzaCBwcm9wZXIKIAkJCSAqIG5vbi1yYW5kb21pemVkIG1hcHBpbmdzLgorCQkJ
ICogSWYgdGhlIGZpcnN0IFBUX0xPQUQgc2VnbWVudCBoYXMgbm9uLXplcm8gcF92YWRkciwKKwkJ
CSAqIHVzZSB0aGUgemVybyBsb2FkX2JpYXMgc28gdGhhdCBhIFBJRSBiaW5hcnkgd2lsbCBiZQor
CQkJICogbG9hZGVkIGF0IHRoZSBzcGVjaWZpYyBhZGRyZXNzIGV2ZW4gaWYgbWVtb3J5CisJCQkg
KiByYW5kb21pemF0aW9uIGlzIG9mZi4KIAkJCSAqLwotCQkJaWYgKGN1cnJlbnQtPmZsYWdzICYg
UEZfUkFORE9NSVpFKQorCQkJaWYgKChjdXJyZW50LT5mbGFncyAmIFBGX1JBTkRPTUlaRSkgfHwK
KwkJCSAgICAoIWxvYWRfYWRkcl9zZXQgJiYgdmFkZHIpKQogCQkJCWxvYWRfYmlhcyA9IDA7CiAJ
CQllbHNlCiAJCQkJbG9hZF9iaWFzID0gRUxGX1BBR0VTVEFSVChFTEZfRVRfRFlOX0JBU0UgLSB2
YWRkcik7Ci0tIAoxLjguMy4xCgo=
--089e01183706b6ee3704ed1bf4cd--
