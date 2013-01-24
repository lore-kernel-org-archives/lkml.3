Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab3AXEH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 23:07:27 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:47434 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab3AXEHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 23:07:20 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQWJqWQJhoJb2dBn=iAsKjxuf3MJro-jz+6k+WNZor8-xQ@mail.gmail.com>
References: <1358868049-19884-1-git-send-email-trenn@suse.de>
	<1358868049-19884-3-git-send-email-trenn@suse.de>
	<50FEB620.3020805@zytor.com>
	<201301221723.03863.trenn@suse.de>
	<50FEBF35.6010502@zytor.com>
	<CAE9FiQWJqWQJhoJb2dBn=iAsKjxuf3MJro-jz+6k+WNZor8-xQ@mail.gmail.com>
Date: Wed, 23 Jan 2013 20:07:19 -0800
X-Google-Sender-Auth: 3uKqCszROqErrX44RklQo-yesl4
Message-ID: <CAE9FiQWXcwagEb0jdFfdHvNcByNxtaLbvvoRC-jAppQmiGS22w@mail.gmail.com>
Subject: Re: [PATCH 2/2] x86 e820: Introduce memmap=resetusablemap for kdump usage
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Renninger <trenn@suse.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        vgoyal@redhat.com, horms@verge.net.au,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: multipart/mixed; boundary=f46d043bdf6473cbee04d400f24a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d043bdf6473cbee04d400f24a
Content-Type: text/plain; charset=ISO-8859-1

On Tue, Jan 22, 2013 at 12:06 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Tue, Jan 22, 2013 at 8:32 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>> Again: Please explain what is bad with this solution.
>>> I cannot see a better and more robust way for kdump other than
>>> reserving the original reserved memory areas as declared by the BIOS.
>>
>> It is bad because it creates more complexity than is needed.
>>
>> The whole point is that what we want is simply to switch type 1 to type
>> X, with the sole exceptions being the areas explicitly reserved for the
>> kdump kernel.
>
> Do you prefer to  "reserveram" way in attached patch?

Hi, Thomas,

Can you please check attached reserveram version on your setup?

If it is ok, i will put it in for-x86-boot patchset and send it to
Peter for v3.9.

Thanks

Yinghai

--f46d043bdf6473cbee04d400f24a
Content-Type: application/octet-stream; name="e820_reserveram_v2.patch"
Content-Disposition: attachment; filename="e820_reserveram_v2.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hcbdpfo71

U3ViamVjdDogW1BBVENIXSB4ODYsIG1tOiBJbnRyb2R1Y2UgbWVtbWFwPXJlc2VydmVyYW0KCmtk
dW1wIHZvaWRlZCB0aGUgd2hvbGUgb3JpZ2luYWwgZTgyMCBtYXAgYW5kIGhhbGYgd2F5IG1hZGUK
aXQgdXAgdmlhIG1lbW1hcD0gb3B0aW9ucyBwYXNzZWQgdmlhIGtkdW1wIGJvb3QgcGFyYW1zIGFn
YWluLgoKQnV0IHRoaXMgaXMgY29uY2VwdGlvbmFsbHkgd3JvbmcuIFRoZSB3aG9sZSBvcmlnaW5h
bCBtZW1vcnkgcmFuZ2VzCndoaWNoIGFyZSBkZWNsYXJlZCByZXNlcnZlZCwgQUNQSSBkYXRhL252
cyBvciBob3dldmVyIGFyZSBub3QgdXNhYmxlCm11c3Qgc3RheSB0aGUgc2FtZSBhbmQgZ2V0IGhv
bm9yZWQgYnkgdGhlIGtkdW1wIGtlcm5lbC4KClRoZXJlZm9yZSBtZW1tYXA9cmVzZXJ2ZXJhbSBn
ZXRzIGludHJvZHVjZWQuCmtkdW1wIHBhc3NlcyB0aGlzIG9uZSBhbmQgb25seSB0aGUgdXNhYmxl
IGU4MjAgcmFuZ2VzIGFyZSB1cGRhdGVkIHRvCnJlc2VydmVkIGF0IGZpcnN0IGJ5IGtlcm5lbCwg
dGhlbiB3aGVuIGtkdW1wIHBhc3NlcyB0aGUgdXNhYmxlIHJhbmdlcwp0byB1c2UgdmlhIG1lbW1h
cD14QHkgcGFyYW1ldGVyKHMpLCBrZXJuZWwgd2lsbCByZW1vdmUgcmVzZXJ2ZWQgcmFuZ2UKYW5k
IGFkZCB1c2FibGUgcmFuZ2UgYWNjb3JkaW5nbHkuCgpUaGlzIGZvciBleGFtcGxlIGZpeGVzIG1t
Y29uZiAoZXh0ZW5kZWQgUENJIGNvbmZpZyBhY2Nlc3MpIGFuZApwb3NzaWJseSBvdGhlciBrZXJu
ZWwgcGFydHMgd2hpY2ggcmVseSBvbiByZW1hcHBlZCBtZW1vcnkgdG8gYmUKaW4gcmVzZXJ2ZWQg
b3IgQUNQSSAoZGF0YS9udnMpIGRlY2xhcmVkIGU4MjAgbWVtb3J5IGFyZWFzLgoKQ2hhbmdlbG9n
IGlzIGZyb20gVGhvbWFzIFJlbm5pbmdlciwgYW5kIHVwZGF0ZWQgdG8gcmVzZXJ2ZXJhbQoKLXYy
OiBBY2NvcmRpbmcgdG8gSFBBLCB1c2UgcmVzZXJ2ZXJhbSBpbnN0ZWFkIG9mIHJlc2V0dXNhYmxl
bWFwLgoKU2lnbmVkLW9mZi1ieTogWWluZ2hhaSBMdSA8eWluZ2hhaUBrZXJuZWwub3JnPgoKLS0t
CiBhcmNoL3g4Ni9rZXJuZWwvZTgyMC5jIHwgICAxOSArKysrKysrKysrKysrKysrKy0tCiAxIGZp
bGUgY2hhbmdlZCwgMTcgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCkluZGV4OiBsaW51
eC0yLjYvYXJjaC94ODYva2VybmVsL2U4MjAuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYub3Jp
Zy9hcmNoL3g4Ni9rZXJuZWwvZTgyMC5jCisrKyBsaW51eC0yLjYvYXJjaC94ODYva2VybmVsL2U4
MjAuYwpAQCAtODM2LDYgKzgzNiw3IEBAIHN0YXRpYyBpbnQgX19pbml0IHBhcnNlX21lbW9wdChj
aGFyICpwKQogZWFybHlfcGFyYW0oIm1lbSIsIHBhcnNlX21lbW9wdCk7CiAKIHN0YXRpYyBib29s
IF9faW5pdGRhdGEgZXhhY3RtYXBfcGFyc2VkOworc3RhdGljIGJvb2wgX19pbml0ZGF0YSByZXNl
cnZlcmFtX3BhcnNlZDsKIAogc3RhdGljIGludCBfX2luaXQgcGFyc2VfbWVtbWFwX29uZShjaGFy
ICpwKQogewpAQCAtODQ1LDcgKzg0Niw3IEBAIHN0YXRpYyBpbnQgX19pbml0IHBhcnNlX21lbW1h
cF9vbmUoY2hhcgogCWlmICghcCkKIAkJcmV0dXJuIC1FSU5WQUw7CiAKLQlpZiAoIXN0cm5jbXAo
cCwgImV4YWN0bWFwIiwgOCkpIHsKKwlpZiAoIXN0cm5jbXAocCwgImV4YWN0bWFwIiwgOCkgfHwg
IXN0cm5jbXAocCwgInJlc2VydmVyYW0iLCAxMCkpIHsKIAkJaWYgKGV4YWN0bWFwX3BhcnNlZCkK
IAkJCXJldHVybiAwOwogCkBAIC04NTgsNyArODU5LDEyIEBAIHN0YXRpYyBpbnQgX19pbml0IHBh
cnNlX21lbW1hcF9vbmUoY2hhcgogCQkgKi8KIAkJc2F2ZWRfbWF4X3BmbiA9IGU4MjBfZW5kX29m
X3JhbV9wZm4oKTsKICNlbmRpZgotCQllODIwLm5yX21hcCA9IDA7CisJCWlmICghc3RybmNtcChw
LCAicmVzZXJ2ZXJhbSIsIDEwKSkgeworCQkJZTgyMF91cGRhdGVfcmFuZ2UoMCwgVUxMT05HX01B
WCwgRTgyMF9SQU0sCisJCQkJCSAgRTgyMF9SRVNFUlZFRCk7CisJCQlyZXNlcnZlcmFtX3BhcnNl
ZCA9IHRydWU7CisJCX0gZWxzZQorCQkJZTgyMC5ucl9tYXAgPSAwOwogCQl1c2VyZGVmID0gMTsK
IAkJcmV0dXJuIDA7CiAJfQpAQCAtODcxLDYgKzg3NywxMCBAQCBzdGF0aWMgaW50IF9faW5pdCBw
YXJzZV9tZW1tYXBfb25lKGNoYXIKIAl1c2VyZGVmID0gMTsKIAlpZiAoKnAgPT0gJ0AnKSB7CiAJ
CXN0YXJ0X2F0ID0gbWVtcGFyc2UocCsxLCAmcCk7CisJCWlmIChyZXNlcnZlcmFtX3BhcnNlZCkg
eworCQkJLyogUmVtb3ZlIG9sZCByZXNlcnZlZCBzbyBuZXcgcmFtIGNvdWxkIHRha2Ugb3Zlci4g
Ki8KKwkJCWU4MjBfcmVtb3ZlX3JhbmdlKHN0YXJ0X2F0LCBtZW1fc2l6ZSwgRTgyMF9SRVNFUlZF
RCwgMCk7CisJCX0KIAkJZTgyMF9hZGRfcmVnaW9uKHN0YXJ0X2F0LCBtZW1fc2l6ZSwgRTgyMF9S
QU0pOwogCX0gZWxzZSBpZiAoKnAgPT0gJyMnKSB7CiAJCXN0YXJ0X2F0ID0gbWVtcGFyc2UocCsx
LCAmcCk7CkBAIC04OTAsNiArOTAwLDExIEBAIHN0YXRpYyBpbnQgX19pbml0IHBhcnNlX21lbW1h
cF9vcHQoY2hhcgogCXAgPSBzdHJzdHIocCwgImV4YWN0bWFwIik7CiAJaWYgKHApCiAJCXBhcnNl
X21lbW1hcF9vbmUoImV4YWN0bWFwIik7CisJZWxzZSB7CisJCXAgPSBzdHJzdHIoYm9vdF9jb21t
YW5kX2xpbmUsICJyZXNlcnZlcmFtIik7CisJCWlmIChwKQorCQkJcGFyc2VfbWVtbWFwX29uZSgi
cmVzZXJ2ZXJhbSIpOworCX0KIAogCXdoaWxlIChzdHIpIHsKIAkJY2hhciAqayA9IHN0cmNocihz
dHIsICcsJyk7Cg==
--f46d043bdf6473cbee04d400f24a--
