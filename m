Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751309AbaJRV27 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 17:28:59 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:45325 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbaJRV26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 17:28:58 -0400
MIME-Version: 1.0
In-Reply-To: <544033CF.3080104@gaast.net>
References: <54347520.3050109@gaast.net>
	<543AA2FE.20105@gaast.net>
	<20141012204032.GA11171@amd>
	<9751497.0fL0kvsyX7@vostro.rjw.lan>
	<20141015111641.GC7792@gaast.net>
	<CAErSpo5A+nHTu2Y6KrXowBBCBsNw_hO0SRsnc6YRdJChCUmO6w@mail.gmail.com>
	<CAE9FiQV9t0bCfUy5Fichdk=04ruEVxGv-LUK1xxZjCrasAOACg@mail.gmail.com>
	<543F049F.5090605@gaast.net>
	<CAE9FiQWDHq5esSt4UvE5AkHR-=XMvrzaNFwLg+0xKisTNOtcsQ@mail.gmail.com>
	<543F9182.9000004@gaast.net>
	<CAE9FiQVNZHTxpNCnn+YPtqjWrQjFmtTh06sbBawqFonMFwSZ-w@mail.gmail.com>
	<544033CF.3080104@gaast.net>
Date: Sat, 18 Oct 2014 14:28:57 -0700
X-Google-Sender-Auth: ssnkHNpARzfbZXbPsOcPUgPP3xM
Message-ID: <CAE9FiQW0x5uy_osjvVDOOMDaz2=2KL+TusQ8QqcHL5dWTPrK2w@mail.gmail.com>
Subject: Re: Machine crashes right *after* ~successful resume
From: Yinghai Lu <yinghai@kernel.org>
To: Wilmer van der Gaast <wilmer@gaast.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=001a114318dc54e9520505b92bef
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a114318dc54e9520505b92bef
Content-Type: text/plain; charset=UTF-8

On Thu, Oct 16, 2014 at 2:08 PM, Wilmer van der Gaast <wilmer@gaast.net> wrote:
> Did that on this run, no difference either. For full completeness, I
> reproduced this problem with no modules loaded (done from initramfs) at all,
> with a kernel with your workaround included, logs are here:
> http://gaast.net/~wilmer/.lkml/bad3.17-patched-debug-initramfs.txt

Yes, those output are good.

Please apply attached debug patch on top of v3.17 and boot with
"debug ignore_loglevel initcall_debug no_console_suspend".

Hope we can find out which nb notifier cause problem.

Thanks

Yinghai

--001a114318dc54e9520505b92bef
Content-Type: text/x-patch; charset=US-ASCII; name="debug_suspend_resume_x.patch"
Content-Disposition: attachment; filename="debug_suspend_resume_x.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i1fha18m0

LS0tCiBrZXJuZWwvbm90aWZpZXIuYyAgIHwgICAgOSArKysrKysrKysKIGtlcm5lbC9wb3dlci9t
YWluLmMgfCAgICA0ICsrKy0KIDIgZmlsZXMgY2hhbmdlZCwgMTIgaW5zZXJ0aW9ucygrKSwgMSBk
ZWxldGlvbigtKQoKSW5kZXg6IGxpbnV4LTIuNi9rZXJuZWwvcG93ZXIvbWFpbi5jCj09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2tlcm5lbC9wb3dlci9tYWluLmMKKysrIGxpbnV4LTIuNi9r
ZXJuZWwvcG93ZXIvbWFpbi5jCkBAIC0yNCwxNiArMjQsMTggQEAgREVGSU5FX01VVEVYKHBtX211
dGV4KTsKIAogLyogUm91dGluZXMgZm9yIFBNLXRyYW5zaXRpb24gbm90aWZpY2F0aW9ucyAqLwog
Ci1zdGF0aWMgQkxPQ0tJTkdfTk9USUZJRVJfSEVBRChwbV9jaGFpbl9oZWFkKTsKK0JMT0NLSU5H
X05PVElGSUVSX0hFQUQocG1fY2hhaW5faGVhZCk7CiAKIGludCByZWdpc3Rlcl9wbV9ub3RpZmll
cihzdHJ1Y3Qgbm90aWZpZXJfYmxvY2sgKm5iKQogeworCXByX2luZm8oIlBNOiByZWdpc3Rlcmlu
ZyBuYiAlcEZcbiIsIG5iLT5ub3RpZmllcl9jYWxsKTsKIAlyZXR1cm4gYmxvY2tpbmdfbm90aWZp
ZXJfY2hhaW5fcmVnaXN0ZXIoJnBtX2NoYWluX2hlYWQsIG5iKTsKIH0KIEVYUE9SVF9TWU1CT0xf
R1BMKHJlZ2lzdGVyX3BtX25vdGlmaWVyKTsKIAogaW50IHVucmVnaXN0ZXJfcG1fbm90aWZpZXIo
c3RydWN0IG5vdGlmaWVyX2Jsb2NrICpuYikKIHsKKwlwcl9pbmZvKCJQTTogdW5yZWdpc3Rlcmlu
ZyBuYiAlcEZcbiIsIG5iLT5ub3RpZmllcl9jYWxsKTsKIAlyZXR1cm4gYmxvY2tpbmdfbm90aWZp
ZXJfY2hhaW5fdW5yZWdpc3RlcigmcG1fY2hhaW5faGVhZCwgbmIpOwogfQogRVhQT1JUX1NZTUJP
TF9HUEwodW5yZWdpc3Rlcl9wbV9ub3RpZmllcik7CkluZGV4OiBsaW51eC0yLjYva2VybmVsL25v
dGlmaWVyLmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcva2VybmVsL25vdGlmaWVyLmMK
KysrIGxpbnV4LTIuNi9rZXJuZWwvbm90aWZpZXIuYwpAQCAtNTksNiArNTksOSBAQCBzdGF0aWMg
aW50IG5vdGlmaWVyX2NoYWluX3VucmVnaXN0ZXIoc3RyCiAJcmV0dXJuIC1FTk9FTlQ7CiB9CiAK
K2V4dGVybiBzdHJ1Y3QgYmxvY2tpbmdfbm90aWZpZXJfaGVhZCBwbV9jaGFpbl9oZWFkOworI2Rl
ZmluZSBQTV9QT1NUX1NVU1BFTkQJCTB4MDAwNCAvKiBTdXNwZW5kIGZpbmlzaGVkICovCisKIC8q
KgogICogbm90aWZpZXJfY2FsbF9jaGFpbiAtIEluZm9ybXMgdGhlIHJlZ2lzdGVyZWQgbm90aWZp
ZXJzIGFib3V0IGFuIGV2ZW50LgogICoJQG5sOgkJUG9pbnRlciB0byBoZWFkIG9mIHRoZSBibG9j
a2luZyBub3RpZmllciBjaGFpbgpAQCAtOTAsOCArOTMsMTQgQEAgc3RhdGljIGludCBub3RpZmll
cl9jYWxsX2NoYWluKHN0cnVjdCBubwogCQkJY29udGludWU7CiAJCX0KICNlbmRpZgorCQlpZiAo
bmwgPT0gJnBtX2NoYWluX2hlYWQuaGVhZCAmJiB2YWwgPT0gUE1fUE9TVF9TVVNQRU5EKQorCQkJ
cHJfaW5mbygiUE06IGNhbGxpbmcgbmIgJXBGXG4iLCBuYi0+bm90aWZpZXJfY2FsbCk7CisKIAkJ
cmV0ID0gbmItPm5vdGlmaWVyX2NhbGwobmIsIHZhbCwgdik7CiAKKwkJaWYgKG5sID09ICZwbV9j
aGFpbl9oZWFkLmhlYWQgJiYgdmFsID09IFBNX1BPU1RfU1VTUEVORCkKKwkJCXByX2luZm8oIlBN
OiAuLi4gbmIgJXBGIGRvbmVcbiIsIG5iLT5ub3RpZmllcl9jYWxsKTsKKwogCQlpZiAobnJfY2Fs
bHMpCiAJCQkoKm5yX2NhbGxzKSsrOwogCg==
--001a114318dc54e9520505b92bef--
