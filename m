Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768AbaJZVxK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 17:53:10 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:36510 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbaJZVxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 17:53:08 -0400
MIME-Version: 1.0
In-Reply-To: <20141022125354.GA3832@gaast.net>
References: <543F049F.5090605@gaast.net>
	<CAE9FiQWDHq5esSt4UvE5AkHR-=XMvrzaNFwLg+0xKisTNOtcsQ@mail.gmail.com>
	<543F9182.9000004@gaast.net>
	<CAE9FiQVNZHTxpNCnn+YPtqjWrQjFmtTh06sbBawqFonMFwSZ-w@mail.gmail.com>
	<544033CF.3080104@gaast.net>
	<CAE9FiQW0x5uy_osjvVDOOMDaz2=2KL+TusQ8QqcHL5dWTPrK2w@mail.gmail.com>
	<5442FE58.5020700@gaast.net>
	<CAE9FiQWugqXZdZDhDyKofKRXH6EgVq6DJ0JphM6DZSdS5nMhbw@mail.gmail.com>
	<5446D2D8.2090203@gaast.net>
	<CAE9FiQWjvZapL0u5QSwD3gYTXisKrCgRcUYWAcy8onUYbkLHTg@mail.gmail.com>
	<20141022125354.GA3832@gaast.net>
Date: Sun, 26 Oct 2014 14:53:07 -0700
X-Google-Sender-Auth: Os9FQsi9UBMFGPEbSe6uxpb_2fU
Message-ID: <CAE9FiQXF-6b4+y-BJmv7ekrCrXKYyhvZDBqVbLeXSPJa0_cToA@mail.gmail.com>
Subject: Re: Machine crashes right *after* ~successful resume
From: Yinghai Lu <yinghai@kernel.org>
To: Wilmer van der Gaast <wilmer@gaast.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=089e011822167f7fd405065a70ca
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e011822167f7fd405065a70ca
Content-Type: text/plain; charset=UTF-8

On Wed, Oct 22, 2014 at 5:53 AM, Wilmer van der Gaast <wilmer@gaast.net> wrote:
> That seems to be the case yes:
>
> [  106.661152] PM: ... nb fw_pm_notify+0x0/0x150 done
> [  106.665939] PM: calling nb bsp_pm_callback+0x0/0x50
> [  106.670814] PM: ... nb bsp_pm_callback+0x0/0x50 done
> [  106.675775] pm_restore_console() before move
>
> Then nothing, during the third resume.
>
> http://gaast.net/~wilmer/.lkml/bad3.17-patched-console-restore.txt has
> the full log.
>
> (Some of your other debug lines in your patch don't seem to be logging
> anything during my repro BTW.)

Please try attached two debug patches to check the pci registers
between the suspend/resume.

--089e011822167f7fd405065a70ca
Content-Type: text/x-patch; charset=US-ASCII; name="debug_extra_dump_pci.patch"
Content-Disposition: attachment; filename="debug_extra_dump_pci.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i1qxmixs0

U3ViamVjdDogW1BBVENIXSBwY2k6IHByaW50IG91dCBhYm91dCBwY2k9ZHVtcAoKZGVidWcgcHJp
bnQgb3V0IGJlZm9yZSBsYXRlciBkcml2ZXIgaGFuZwoKU2lnbmVkLW9mZi1ieTogWWluZ2hhaSBM
dSA8eWluZ2hhaUBrZXJuZWwub3JnPgoKLS0tCiBkcml2ZXJzL3BjaS9wY2kuYyB8ICAgNTIgKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLQogMSBmaWxl
IGNoYW5nZWQsIDUxIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCkluZGV4OiBsaW51eC0y
LjYvZHJpdmVycy9wY2kvcGNpLmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcvZHJpdmVy
cy9wY2kvcGNpLmMKKysrIGxpbnV4LTIuNi9kcml2ZXJzL3BjaS9wY2kuYwpAQCAtMzg1OCw2ICsz
ODU4LDU0IEBAIHZvaWQgX193ZWFrIHBjaV9maXh1cF9jYXJkYnVzKHN0cnVjdCBwY2kKIH0KIEVY
UE9SVF9TWU1CT0wocGNpX2ZpeHVwX2NhcmRidXMpOwogCitzdGF0aWMgdm9pZCBkdW1wX3BjaV9k
ZXZpY2VfcmFuZ2Uoc3RydWN0IHBjaV9kZXYgKmRldiwgdW5zaWduZWQgc3RhcnRfcmVnLAorCQkJ
CQkgdW5zaWduZWQgc2l6ZSkKK3sKKwlpbnQgaTsKKwlpbnQgajsKKwl1MzIgdmFsOworCWludCBl
bmQgPSBzdGFydF9yZWcgKyBzaXplOworCisJcHJpbnRrKEtFUk5fREVCVUcgIlBDSTogJXMiLCBw
Y2lfbmFtZShkZXYpKTsKKworCWZvciAoaSA9IHN0YXJ0X3JlZzsgaSA8IGVuZDsgaSArPSA0KSB7
CisJCWlmICghKGkgJiAweDBmKSkKKwkJCXByaW50aygiXG4lMDR4OiIsIGkpOworCisJCXBjaV9y
ZWFkX2NvbmZpZ19kd29yZChkZXYsIGksICZ2YWwpOworCQlmb3IgKGogPSAwOyBqIDwgNDsgaisr
KSB7CisJCQlwcmludGsoIiAlMDJ4IiwgdmFsICYgMHhmZik7CisJCQl2YWwgPj49IDg7CisJCX0K
Kwl9CisJcHJpbnRrKCJcbiIpOworfQorCitzdGF0aWMgaW50IGR1bXBfcGNpX2RldmljZXModm9p
ZCkKK3sKKwlzdHJ1Y3QgcGNpX2RldiAqZGV2ID0gTlVMTDsKKworCXdoaWxlICgoZGV2ID0gcGNp
X2dldF9kZXZpY2UoUENJX0FOWV9JRCwgUENJX0FOWV9JRCwgZGV2KSkgIT0gTlVMTCkKKwkJZHVt
cF9wY2lfZGV2aWNlX3JhbmdlKGRldiwgMCwgZGV2LT5jZmdfc2l6ZSk7CisKKwlyZXR1cm4gMDsK
K30KKworc3RhdGljIGludCBwY2lfZHVtcF9yZWdzOworc3RhdGljIHZvaWQgcGNpX2R1bXAodm9p
ZCkKK3sKKwlwY2lfZHVtcF9yZWdzID0gMTsKK30KKworc3RhdGljIGludCBwY2lfaW5pdCh2b2lk
KQoreworCWlmIChwY2lfZHVtcF9yZWdzKQorCQlkdW1wX3BjaV9kZXZpY2VzKCk7CisKKwlyZXR1
cm4gMDsKK30KK2RldmljZV9pbml0Y2FsbChwY2lfaW5pdCk7CisKIHN0YXRpYyBpbnQgX19pbml0
IHBjaV9zZXR1cChjaGFyICpzdHIpCiB7CiAJd2hpbGUgKHN0cikgewpAQCAtMzg2NSw3ICszOTEz
LDkgQEAgc3RhdGljIGludCBfX2luaXQgcGNpX3NldHVwKGNoYXIgKnN0cikKIAkJaWYgKGspCiAJ
CQkqaysrID0gMDsKIAkJaWYgKCpzdHIgJiYgKHN0ciA9IHBjaWJpb3Nfc2V0dXAoc3RyKSkgJiYg
KnN0cikgewotCQkJaWYgKCFzdHJjbXAoc3RyLCAibm9tc2kiKSkgeworCQkJaWYgKCFzdHJjbXAo
c3RyLCAiZHVtcCIpKSB7CisJCQkJcGNpX2R1bXAoKTsKKwkJCX0gZWxzZSBpZiAoIXN0cmNtcChz
dHIsICJub21zaSIpKSB7CiAJCQkJcGNpX25vX21zaSgpOwogCQkJfSBlbHNlIGlmICghc3RyY21w
KHN0ciwgIm5vYWVyIikpIHsKIAkJCQlwY2lfbm9fYWVyKCk7Cg==
--089e011822167f7fd405065a70ca
Content-Type: text/x-patch; charset=US-ASCII; name="debug_suspend_resume_z.patch"
Content-Disposition: attachment; filename="debug_suspend_resume_z.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i1qxnln11

LS0tCiBkcml2ZXJzL3BjaS9wY2kuYyAgICAgIHwgICAgMiArLQoga2VybmVsL3Bvd2VyL3N1c3Bl
bmQuYyB8ICAgIDIgKysKIDIgZmlsZXMgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAxIGRlbGV0
aW9uKC0pCgpJbmRleDogbGludXgtMi42L2RyaXZlcnMvcGNpL3BjaS5jCj09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0t
IGxpbnV4LTIuNi5vcmlnL2RyaXZlcnMvcGNpL3BjaS5jCisrKyBsaW51eC0yLjYvZHJpdmVycy9w
Y2kvcGNpLmMKQEAgLTQ0NjIsNyArNDQ2Miw3IEBAIHN0YXRpYyB2b2lkIGR1bXBfcGNpX2Rldmlj
ZV9yYW5nZShzdHJ1Y3QKIAlwcmludGsoIlxuIik7CiB9CiAKLXN0YXRpYyBpbnQgZHVtcF9wY2lf
ZGV2aWNlcyh2b2lkKQoraW50IGR1bXBfcGNpX2RldmljZXModm9pZCkKIHsKIAlzdHJ1Y3QgcGNp
X2RldiAqZGV2ID0gTlVMTDsKIApJbmRleDogbGludXgtMi42L2tlcm5lbC9wb3dlci9zdXNwZW5k
LmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcva2VybmVsL3Bvd2VyL3N1c3BlbmQuYwor
KysgbGludXgtMi42L2tlcm5lbC9wb3dlci9zdXNwZW5kLmMKQEAgLTQwMSw2ICs0MDEsNyBAQCBp
bnQgc3VzcGVuZF9kZXZpY2VzX2FuZF9lbnRlcihzdXNwZW5kX3N0CiAJZ290byBSZXN1bWVfZGV2
aWNlczsKIH0KIAoraW50IGR1bXBfcGNpX2RldmljZXModm9pZCk7CiAvKioKICAqIHN1c3BlbmRf
ZmluaXNoIC0gQ2xlYW4gdXAgYmVmb3JlIGZpbmlzaGluZyB0aGUgc3VzcGVuZCBzZXF1ZW5jZS4K
ICAqCkBAIC00MTEsNiArNDEyLDcgQEAgc3RhdGljIHZvaWQgc3VzcGVuZF9maW5pc2godm9pZCkK
IHsKIAlzdXNwZW5kX3RoYXdfcHJvY2Vzc2VzKCk7CiAJcG1fbm90aWZpZXJfY2FsbF9jaGFpbihQ
TV9QT1NUX1NVU1BFTkQpOworCWR1bXBfcGNpX2RldmljZXMoKTsKIAlwbV9yZXN0b3JlX2NvbnNv
bGUoKTsKIH0KIAo=
--089e011822167f7fd405065a70ca--
