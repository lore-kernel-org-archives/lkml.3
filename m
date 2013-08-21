Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab3HUUWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 16:22:21 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:55353 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab3HUUWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 16:22:20 -0400
MIME-Version: 1.0
Date: Wed, 21 Aug 2013 13:22:19 -0700
Message-ID: <CAMe9rOpHe1cUKemoVMWygokTUrDCQtZCMsE+x5p7HmT+TQm9AQ@mail.gmail.com>
Subject: [PATCH 2/2] Use __compat_aligned_s64 in snd_ctl_elem_value
From: "H.J. Lu" <hjl.tools@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, tiwai@suse.de, perex@perex.cz,
        alsa-devel@alsa-project.org
Content-Type: multipart/mixed; boundary=089e015385942c6ffd04e47aee67
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e015385942c6ffd04e47aee67
Content-Type: text/plain; charset=ISO-8859-1

The integer64 field in struct snd_ctl_elem_value has different offsets,
depending the alignment of long long.  This patch replaces long long
with the newly introduced __compat_aligned_s64 so that x32 and ia32
can use the same compat system call for struct snd_ctl_elem_value.

-- 
H.J.

--089e015385942c6ffd04e47aee67
Content-Type: application/octet-stream; 
	name="0002-Use-__compat_aligned_s64-in-snd_ctl_elem_value.patch"
Content-Disposition: attachment; 
	filename="0002-Use-__compat_aligned_s64-in-snd_ctl_elem_value.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hkmzkto51

RnJvbSA2NWU4ZGJhZGJiNTA3ZjVhMmRiODE5NTY2NjkxNDY3YzY3NjgwOTZmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiAiSC5KLiBMdSIgPGhqbC50b29sc0BnbWFpbC5jb20+CkRhdGU6
IFdlZCwgMjEgQXVnIDIwMTMgMTM6MDk6MjAgLTA3MDAKU3ViamVjdDogW1BBVENIIDIvMl0gVXNl
IF9fY29tcGF0X2FsaWduZWRfczY0IGluIHNuZF9jdGxfZWxlbV92YWx1ZQoKVGhlIGludGVnZXI2
NCBmaWVsZCBpbiBzdHJ1Y3Qgc25kX2N0bF9lbGVtX3ZhbHVlIGhhcyBkaWZmZXJlbnQgb2Zmc2V0
cywKZGVwZW5kaW5nIHRoZSBhbGlnbm1lbnQgb2YgbG9uZyBsb25nLiAgVGhpcyBwYXRjaCByZXBs
YWNlcyBsb25nIGxvbmcKd2l0aCB0aGUgbmV3bHkgaW50cm9kdWNlZCBfX2NvbXBhdF9hbGlnbmVk
X3M2NCBzbyB0aGF0IHgzMiBhbmQgaWEzMgpjYW4gdXNlIHRoZSBzYW1lIGNvbXBhdCBzeXN0ZW0g
Y2FsbCBmb3Igc3RydWN0IHNuZF9jdGxfZWxlbV92YWx1ZS4KClNpZ25lZC1vZmYtYnk6IEguSi4g
THUgPGhqbC50b29sc0BnbWFpbC5jb20+Ci0tLQogaW5jbHVkZS91YXBpL3NvdW5kL2Fzb3VuZC5o
IHwgNCArKy0tCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygt
KQoKZGlmZiAtLWdpdCBhL2luY2x1ZGUvdWFwaS9zb3VuZC9hc291bmQuaCBiL2luY2x1ZGUvdWFw
aS9zb3VuZC9hc291bmQuaAppbmRleCBlMzk4M2Q1Li5lYTY0ODljIDEwMDY0NAotLS0gYS9pbmNs
dWRlL3VhcGkvc291bmQvYXNvdW5kLmgKKysrIGIvaW5jbHVkZS91YXBpL3NvdW5kL2Fzb3VuZC5o
CkBAIC04NzcsOCArODc3LDggQEAgc3RydWN0IHNuZF9jdGxfZWxlbV92YWx1ZSB7CiAJCQlsb25n
ICp2YWx1ZV9wdHI7CS8qIG9ic29sZXRlZCAqLwogCQl9IGludGVnZXI7CiAJCXVuaW9uIHsKLQkJ
CWxvbmcgbG9uZyB2YWx1ZVs2NF07Ci0JCQlsb25nIGxvbmcgKnZhbHVlX3B0cjsJLyogb2Jzb2xl
dGVkICovCisJCQlfX2NvbXBhdF9hbGlnbmVkX3M2NCB2YWx1ZVs2NF07CisJCQlfX2NvbXBhdF9h
bGlnbmVkX3M2NCAqdmFsdWVfcHRyOwkvKiBvYnNvbGV0ZWQgKi8KIAkJfSBpbnRlZ2VyNjQ7CiAJ
CXVuaW9uIHsKIAkJCXVuc2lnbmVkIGludCBpdGVtWzEyOF07Ci0tIAoxLjguMS40Cgo=
--089e015385942c6ffd04e47aee67--
