Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401Ab3C0VSI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 17:18:08 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:57326 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753377Ab3C0VSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 17:18:07 -0400
Message-Id: <1364419085.8454.140661210031889.49ED573A@webmail.messagingengine.com>
X-Sasl-Enc: 2VRmOinZors4XNx6tgHHc20V4Lavvp4MsZMWmQOPBIky 1364419085
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "intel-gfx" <intel-gfx@lists.freedesktop.org>,
        Hans de Bruin <jmdebruin@xmsnet.nl>, Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: multipart/mixed; boundary="_----------=_136441908584542";
 charset="utf-8"
X-Mailer: MessagingEngine.com Webmail Interface - html
Subject: [PATCH v2] x86, vm86: fix VM86 syscalls: use SYSCALL_DEFINEx(...)
Date: Wed, 27 Mar 2013 22:18:05 +0100
In-Reply-To: <20130327194614.GA21522@ZenIV.linux.org.uk>
References: <514F6DF9.1070602@xmsnet.nl>
 <1364332526.8559.140661209554365.0203B0A4@webmail.messagingengine.com>
 <5152F321.7020604@xmsnet.nl>
 <1364412662.12858.140661209988437.506AD50B@webmail.messagingengine.com>
 <20130327194614.GA21522@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--_----------=_136441908584542
Content-Transfer-Encoding: 7bit
Content-Type: text/plain

On Wed, Mar 27, 2013, at 20:46, Al Viro wrote:
> On Wed, Mar 27, 2013 at 08:31:02PM +0100, Alexander van Heukelum wrote:
> > Hi Al,
> > 
> > Hans de Bruin found a regression due to one of your changes. I asked him to test a fix and he reported back that it worked. (Thanks!) Can you see if you agree with the fix? Patch is attached due to webmail...
> 
> Use SYSCALL_DEFINE{1,2} for vm86_old and vm86, please.

Like this?

Greetings,
    Alexander

--_----------=_136441908584542
Content-Disposition: attachment; filename="0001-x86-vm86-fix-VM86-syscalls-use-SYSCALL_DEFINEx.patch"
Content-Id: <1364418977.8264.f175f0db00b1a9679fc0f6d8b9db6eef09ce8413.113E4AF1@messagingengine.com>
Content-Transfer-Encoding: base64
Content-Type: text/x-patch; name="0001-x86-vm86-fix-VM86-syscalls-use-SYSCALL_DEFINEx.patch"

RnJvbSA0NTBkODZlNmFkMGE3ZDM4N2NmNzA2NzE0YzFmYzAzMGJiNGIxM2E1
IE1vbiBTZXAgMTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBBbGV4YW5kZXIgdmFu
IEhldWtlbHVtIDxoZXVrZWx1bUBmYXN0bWFpbC5mbT4KRGF0ZTogVHVlLCAy
NiBNYXIgMjAxMyAyMTo1Nzo0MyArMDEwMApTdWJqZWN0OiBbUEFUQ0hdIHg4
Niwgdm04NjogZml4IFZNODYgc3lzY2FsbHM6IHVzZSBTWVNDQUxMX0RFRklO
RXgoLi4uKQoKQ29tbWl0IDQ5Y2IyNWU5MjkwIHg4NjogJ2dldCByaWQgb2Yg
cHRfcmVncyBhcmd1bWVudCBpbiB2bTg2L3ZtODZvbGQnCmdvdCByaWQgb2Yg
dGhlIHB0X3JlZ3Mgc3R1YiBmb3Igc3lzX3ZtODZvbGQgYW5kIHN5c192bTg2
LiBUaGUgZnVuY3Rpb25zCndlcmUsIGhvd2V2ZXIsIG5vdCBjaGFuZ2VkIHRv
IHVzZSB0aGUgY2FsbGluZyBjb252ZW50aW9uIGZvciBzeXNjYWxscy4KClt2
Ml0gVXNlIFNZU0NBTExfREVGSU5FeCguLi4pLiBDb21waWxlcyB0byBpZGVu
dGljYWwgY29kZS4KClRoZSByZWdyZXNzaW9uIHdhcyByZXBvcnRlZCBhbmQg
cGlucG9pbnRlZCBieSBIYW5zIGRlIEJydWluOgo+IGNvbW1pdCA0OWNiMjVl
OTI5MCB4ODY6ICdnZXQgcmlkIG9mIHB0X3JlZ3MgYXJndW1lbnQgaW4gdm04
Ni92bTg2b2xkJwo+IHNvbWVob3cgYnJlYWtzIHRoZSBjb2xvcnMgd2hlbiBJ
IHBsYXkgJ2NpdmlsaXphdGlvbiBJJyB1bmRlciB4ZG9zZW11Lgo+IER1cmlu
ZyB0aGUgaW50cm8gb2YgdGhlIGdhbWUgc29tZXRoaW5nIHRoZSBjb2xvcnMg
Z2V0IG1lc3NlZCB1cC4gV2hlbgo+IHRoZSBnYW1lIGJlZ2lucyB0aGUgZ3Jh
c3Mgb2YgdGhlIGVhcnRoIGlzIHJlZC4gUmV2ZXJ0aW5nIHRoZSBjb21taXQK
PiBmaXhlcyB0aGUgcHJvYmxlbS4KCkFuZCBoZSB0ZXN0ZWQgdGhlIHBhdGNo
IHRvbzoKPiBZZXAsIHRoZSBncmFzcyBpcyBncmVlbiBhZ2Fpbi4KClJlcG9y
dGVkLWFuZC10ZXN0ZWQtYnk6IEhhbnMgZGUgQnJ1aW4gPGptZGVicnVpbkB4
bXNuZXQubmw+ClNpZ25lZC1vZmYtYnk6IEFsZXhhbmRlciB2YW4gSGV1a2Vs
dW0gPGhldWtlbHVtQGZhc3RtYWlsLmZtPgotLS0KIGFyY2gveDg2L2luY2x1
ZGUvYXNtL3N5c2NhbGxzLmggfCA0ICsrLS0KIGFyY2gveDg2L2tlcm5lbC92
bTg2XzMyLmMgICAgICAgfCA4ICsrKysrLS0tCiAyIGZpbGVzIGNoYW5nZWQs
IDcgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQg
YS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9zeXNjYWxscy5oIGIvYXJjaC94ODYv
aW5jbHVkZS9hc20vc3lzY2FsbHMuaAppbmRleCA2Y2YwYTljLi41YTBiZTBh
IDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9zeXNjYWxscy5o
CisrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3N5c2NhbGxzLmgKQEAgLTM3
LDggKzM3LDggQEAgYXNtbGlua2FnZSBpbnQgc3lzX2dldF90aHJlYWRfYXJl
YShzdHJ1Y3QgdXNlcl9kZXNjIF9fdXNlciAqKTsKIHVuc2lnbmVkIGxvbmcg
c3lzX3NpZ3JldHVybih2b2lkKTsKIAogLyoga2VybmVsL3ZtODZfMzIuYyAq
LwotaW50IHN5c192bTg2b2xkKHN0cnVjdCB2bTg2X3N0cnVjdCBfX3VzZXIg
Kik7Ci1pbnQgc3lzX3ZtODYodW5zaWduZWQgbG9uZywgdW5zaWduZWQgbG9u
Zyk7Cithc21saW5rYWdlIGxvbmcgc3lzX3ZtODZvbGQoc3RydWN0IHZtODZf
c3RydWN0IF9fdXNlciAqKTsKK2FzbWxpbmthZ2UgbG9uZyBzeXNfdm04Nih1
bnNpZ25lZCBsb25nLCB1bnNpZ25lZCBsb25nKTsKIAogI2Vsc2UgLyogQ09O
RklHX1g4Nl8zMiAqLwogCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwv
dm04Nl8zMi5jIGIvYXJjaC94ODYva2VybmVsL3ZtODZfMzIuYwppbmRleCAx
Y2Y1NzY2Li5hNjdjYjJiIDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9rZXJuZWwv
dm04Nl8zMi5jCisrKyBiL2FyY2gveDg2L2tlcm5lbC92bTg2XzMyLmMKQEAg
LTMzLDYgKzMzLDcgQEAKICNpbmNsdWRlIDxsaW51eC9jYXBhYmlsaXR5Lmg+
CiAjaW5jbHVkZSA8bGludXgvZXJybm8uaD4KICNpbmNsdWRlIDxsaW51eC9p
bnRlcnJ1cHQuaD4KKyNpbmNsdWRlIDxsaW51eC9zeXNjYWxscy5oPgogI2lu
Y2x1ZGUgPGxpbnV4L3NjaGVkLmg+CiAjaW5jbHVkZSA8bGludXgva2VybmVs
Lmg+CiAjaW5jbHVkZSA8bGludXgvc2lnbmFsLmg+CkBAIC00OCw3ICs0OSw2
IEBACiAjaW5jbHVkZSA8YXNtL2lvLmg+CiAjaW5jbHVkZSA8YXNtL3RsYmZs
dXNoLmg+CiAjaW5jbHVkZSA8YXNtL2lycS5oPgotI2luY2x1ZGUgPGFzbS9z
eXNjYWxscy5oPgogCiAvKgogICogS25vd24gcHJvYmxlbXM6CkBAIC0yMDIs
NyArMjAyLDcgQEAgb3V0Ogogc3RhdGljIGludCBkb192bTg2X2lycV9oYW5k
bGluZyhpbnQgc3ViZnVuY3Rpb24sIGludCBpcnFudW1iZXIpOwogc3RhdGlj
IHZvaWQgZG9fc3lzX3ZtODYoc3RydWN0IGtlcm5lbF92bTg2X3N0cnVjdCAq
aW5mbywgc3RydWN0IHRhc2tfc3RydWN0ICp0c2spOwogCi1pbnQgc3lzX3Zt
ODZvbGQoc3RydWN0IHZtODZfc3RydWN0IF9fdXNlciAqdjg2KQorU1lTQ0FM
TF9ERUZJTkUxKHZtODZvbGQsIHN0cnVjdCB2bTg2X3N0cnVjdCBfX3VzZXIg
Kiwgdjg2KQogewogCXN0cnVjdCBrZXJuZWxfdm04Nl9zdHJ1Y3QgaW5mbzsg
LyogZGVjbGFyZSB0aGlzIF9vbiB0b3BfLAogCQkJCQkgKiB0aGlzIGF2b2lk
cyB3YXN0aW5nIG9mIHN0YWNrIHNwYWNlLgpAQCAtMjI3LDExICsyMjcsMTIg
QEAgaW50IHN5c192bTg2b2xkKHN0cnVjdCB2bTg2X3N0cnVjdCBfX3VzZXIg
KnY4NikKIAlkb19zeXNfdm04NigmaW5mbywgdHNrKTsKIAlyZXQgPSAwOwkv
KiB3ZSBuZXZlciByZXR1cm4gaGVyZSAqLwogb3V0OgorCWFzbWxpbmthZ2Vf
cHJvdGVjdCgxLCByZXQsIHY4Nik7CiAJcmV0dXJuIHJldDsKIH0KIAogCi1p
bnQgc3lzX3ZtODYodW5zaWduZWQgbG9uZyBjbWQsIHVuc2lnbmVkIGxvbmcg
YXJnKQorU1lTQ0FMTF9ERUZJTkUyKHZtODYsIHVuc2lnbmVkIGxvbmcsIGNt
ZCwgdW5zaWduZWQgbG9uZywgYXJnKQogewogCXN0cnVjdCBrZXJuZWxfdm04
Nl9zdHJ1Y3QgaW5mbzsgLyogZGVjbGFyZSB0aGlzIF9vbiB0b3BfLAogCQkJ
CQkgKiB0aGlzIGF2b2lkcyB3YXN0aW5nIG9mIHN0YWNrIHNwYWNlLgpAQCAt
Mjc4LDYgKzI3OSw3IEBAIGludCBzeXNfdm04Nih1bnNpZ25lZCBsb25nIGNt
ZCwgdW5zaWduZWQgbG9uZyBhcmcpCiAJZG9fc3lzX3ZtODYoJmluZm8sIHRz
ayk7CiAJcmV0ID0gMDsJLyogd2UgbmV2ZXIgcmV0dXJuIGhlcmUgKi8KIG91
dDoKKwlhc21saW5rYWdlX3Byb3RlY3QoMiwgcmV0LCBjbWQsIGFyZyk7CiAJ
cmV0dXJuIHJldDsKIH0KIAotLSAKMS44LjEuMgoK

--_----------=_136441908584542--

