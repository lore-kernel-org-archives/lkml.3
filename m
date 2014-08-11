Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbaHKWcM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 18:32:12 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:65065 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743AbaHKWcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 18:32:10 -0400
From: Sadasivan Shaiju <sshaiju@mvista.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 14.0
Thread-Index: Ac+1s52Yj9OQSKiBRgGebj+R0X9P6w==
Date: Mon, 11 Aug 2014 15:31:58 -0700
Message-ID: <caebea84c92306ca318db9662c9c86f8@mail.gmail.com>
Subject: [PATCH] kgdb: Ignore DIE_PAGE_FAULT event in notify handler [2.6.32] kernel
To: jason.wessel@windriver.com
Cc: linux-kernel@vger.kernel.org, shaiju_sada@yahoo.com
Content-Type: multipart/mixed; boundary=001a11c1ec1629fc4c0500622092
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11c1ec1629fc4c0500622092
Content-Type: text/plain; charset=UTF-8

Hi ,

I  work for Montavista (Cavium Inc) as  a  Technical  Lead .  I want to
push some  of the kernel  patches to  rt community (2.6.32 kernel 2.6.33
rt patch)  , so  that  It  will  go  to  the  main line These patches  are
reviewed  and approved  by  our system Architect.  I request  you to
include  in the main line .  These  issues  were  reported  by our
customer CISCO .

Problem Description:
If  kprobes  is  enabled  along  with  kgdb, kgdb gives a SIGHUP on the
host side.

Root Cause:
Inside the do_page_fault() (arch/mips/mm/fault.c) there is a call to
notify_die() when kprobes is enabled.

When kgdb is enabled the register_die_notifier() handler catches this
exception
(which is 3 - TLB miss on store) and says it does not know it and returns
it as
a SIGHUP.

How Solved:
Made kgdb ignore this particular die notification (cmd == DIE_PAGE_FAULT)
in its
handler.

I request you to  merge this  patch to the main line community .  If any
questions  please contact me  at sshaiju@mvista.com
(shaiju_sada@yahoo.com)

Regards,
shaiju

--001a11c1ec1629fc4c0500622092
Content-Type: application/octet-stream; 
	name="4995-kgdb-Ignore-DIE_PAGE_FAULT-event-in-notify-handler.patch"
Content-Disposition: attachment; 
	filename="4995-kgdb-Ignore-DIE_PAGE_FAULT-event-in-notify-handler.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: bf796e2c278abca9_0.1

RnJvbSAwNTZjYWE5OTkxNTEyNzA0Y2IzOWY2NTgyOGUxZmZlYTQ3ODMwYzZjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBzYWRhc2l2YW4gc2hhaWp1IDxzaGFpanVAbG9jYWxob3N0Lmxv
Y2FsZG9tYWluPgpEYXRlOiBXZWQsIDI3IEp1bCAyMDExIDE0OjU0OjM5IC0wNzAwClN1YmplY3Q6
IFtQQVRDSF0ga2dkYjogSWdub3JlIERJRV9QQUdFX0ZBVUxUIGV2ZW50IGluIG5vdGlmeSBoYW5k
bGVyCgpTb3VyY2U6IE1vbnRhVmlzdGEgU29mdHdhcmUsIExMQwpNUjogNDUyODAKVHlwZTogRGVm
ZWN0IEZpeApEaXNwb3NpdGlvbjogTmVlZHMgc3VibWl0dGluZyB0byBrZXJuZWwub3JnCkNoYW5n
ZUlEOiA1YmVjMDlmN2VjMGE0Nzc1MTY5ZjVjYmExNjk3NmJjM2E2YjQ1NTk4CkRlc2NyaXB0aW9u
OgoKSWdub3JlIG5vdGlmeV9kaWUoKSBmcm9tIGRvX3BhZ2VmYXVsdCgpLCBpbiBrZ2RiJ3MgcmVn
aXN0ZXJfZGllX25vdGlmaWVyKCkKaGFuZGxlcgoKU2lnbmVkLW9mZi1ieTogU2FkYXNpdmFuIDxz
c2hhaWp1QG12aXN0YS5jb20+ClNpZ25lZC1vZmYtYnk6IERhbGUgRmFybnN3b3J0aCA8ZGZhcm5z
d29ydGhAbXZpc3RhLmNvbT4KLS0tCiBhcmNoL21pcHMva2VybmVsL2tnZGIuYyB8ICAgIDUgKysr
KysKIDEgZmlsZXMgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspLCAwIGRlbGV0aW9ucygtKQoKZGlm
ZiAtLWdpdCBhL2FyY2gvbWlwcy9rZXJuZWwva2dkYi5jIGIvYXJjaC9taXBzL2tlcm5lbC9rZ2Ri
LmMKaW5kZXggNTBjOWJiOC4uM2U0YWUzMSAxMDA2NDQKLS0tIGEvYXJjaC9taXBzL2tlcm5lbC9r
Z2RiLmMKKysrIGIvYXJjaC9taXBzL2tlcm5lbC9rZ2RiLmMKQEAgLTE5MSw2ICsxOTEsMTEgQEAg
c3RhdGljIGludCBrZ2RiX21pcHNfbm90aWZ5KHN0cnVjdCBub3RpZmllcl9ibG9jayAqc2VsZiwg
dW5zaWduZWQgbG9uZyBjbWQsCiAJc3RydWN0IHB0X3JlZ3MgKnJlZ3MgPSBhcmdzLT5yZWdzOwog
CWludCB0cmFwID0gKHJlZ3MtPmNwMF9jYXVzZSAmIDB4N2MpID4+IDI7CiAKKyAgICAgICAgLyog
aWdub3JlIHRoZSBub3RpZnlfZGllKCkgZnJvbSBkb19wYWdlX2ZhdWx0KCksIHdoaWNoIGlzIG1l
YW50IGZvciBrcHJvYmVzICovCisKKwlpZihjbWQgPT0gRElFX1BBR0VfRkFVTFQpCisJCXJldHVy
biBOT1RJRllfRE9ORTsgICAgICAgCisKIAkvKiBVc2VycGFjZSBldmVudHMsIGlnbm9yZS4gKi8K
IAlpZiAodXNlcl9tb2RlKHJlZ3MpKQogCQlyZXR1cm4gTk9USUZZX0RPTkU7Ci0tIAoxLjcuMC4x
Cgo=
--001a11c1ec1629fc4c0500622092--
