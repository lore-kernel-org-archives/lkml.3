Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577Ab3EQRyK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 13:54:10 -0400
Received: from mail-ia0-f178.google.com ([209.85.210.178]:47252 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756504Ab3EQRyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 13:54:08 -0400
MIME-Version: 1.0
In-Reply-To: <5195FBBD.6060808@amd.com>
References: <51935981.3010808@amd.com>
	<CAE9FiQXN9fG7RYM_mh17kEkSZT=Qm5fgG=8_YmBR+H6kLyokUg@mail.gmail.com>
	<5193A7C3.4010503@amd.com>
	<CAE9FiQV8x5NPBJVyiv0wE3jyqTvSMNWxgkDQRXf5LxifgCXbtw@mail.gmail.com>
	<5194A9CF.3080509@amd.com>
	<5194D5E6.2070605@amd.com>
	<CAE9FiQU4AQmQ6gzUK5gcnVebGPCNjAWFxh5=wXdEbZ_gHM4KaQ@mail.gmail.com>
	<5194F9DF.4030409@amd.com>
	<CAE9FiQWNDn8uHUAe+CSvYdJXeJi57G+9RBxs688+VaFRS-GXBA@mail.gmail.com>
	<5195FBBD.6060808@amd.com>
Date: Fri, 17 May 2013 10:54:07 -0700
X-Google-Sender-Auth: WRnR4M02IwMuRXGQEn5dQ3WXzSs
Message-ID: <CAE9FiQVofGoSk7q5-0irjkBxemqK729cND4hov-1QCBJDhxpgQ@mail.gmail.com>
Subject: Re: 3.9 breaks EFI boot on E350
From: Yinghai Lu <yinghai@kernel.org>
To: =?ISO-8859-1?Q?Christian_K=F6nig?= <christian.koenig@amd.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, Wolfram Gloger <wg@malloc.de>
Content-Type: multipart/mixed; boundary=e89a8f234a516af80604dcedabf6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e89a8f234a516af80604dcedabf6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, May 17, 2013 at 2:43 AM, Christian K=F6nig
<christian.koenig@amd.com> wrote:
> Am 16.05.2013 17:42, schrieb Yinghai Lu:
>
>> On Thu, May 16, 2013 at 8:23 AM, Christian K=F6nig
>> <christian.koenig@amd.com> wrote:
>>>
>>> Am 16.05.2013 17:17, schrieb Yinghai Lu:
>>>
>>>> On Thu, May 16, 2013 at 5:49 AM, Christian K=F6nig
>>>> <christian.koenig@amd.com> wrote:
>>>>>
>>>>> Am 16.05.2013 11:41, schrieb Christian K=F6nig:
>>>>>
>>>>> Ups, the board DOES have a serial port, and I've got a log now that
>>>>> shows
>>>>> the mentioned patch above isn't the root cause.
>>>>>
>>>>> After commit 8d57470d8f859635deffe3919d7d4867b488b85a it indeed crash=
es
>>>>> very
>>>>> early in the boot sequence, but commit
>>>>> 98e7a989979b185f49e86ddaed2ad6890299d9f0 fixes that and now it crashe=
s
>>>>> while
>>>>> trying to unpack the initrd with a completely different backtrace.
>>>>>
>>>> ok, did you post the boot log for that failing boot ?
>>>
>>>
>>> Yes, the bootlog is attached, but I also send it as "3.9 breaks EFI boo=
t
>>> on
>>> E350 v2" to LKML with a request for help.
>>
>> can you boot with appending with "memtest"?
>
>
> Sure, bootlog with memtest is attached.

Please check attached patch, it should fix the problem.

Thanks

Yinghai

--e89a8f234a516af80604dcedabf6
Content-Type: application/octet-stream; name="merge_mapped_range.patch"
Content-Disposition: attachment; filename="merge_mapped_range.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hgto0p7l1

U3ViamVjdDogW1BBVENIXSB4ODYsIHJhbmdlOiBmaXggbWlzc2luZyBtZXJnZSBkdXJpbmcgYWRk
IHJhbmdlCgpDaHJpc3RpYW4gZm91bmQgdjMuOSBkb2VzIG5vdCB3b3JrIHdpdGggRTM1MCB3aXRo
IEVGSSBpcyBlbmFibGVkLgoKWyAgICAxLjY1ODgzMl0gVHJ5aW5nIHRvIHVucGFjayByb290ZnMg
aW1hZ2UgYXMgaW5pdHJhbWZzLi4uClsgICAgMS42Nzk5MzVdIEJVRzogdW5hYmxlIHRvIGhhbmRs
ZSBrZXJuZWwgcGFnaW5nIHJlcXVlc3QgYXQgZmZmZjg4MDA2ZTNmZDAwMApbICAgIDEuNjg2OTQw
XSBJUDogWzxmZmZmZmZmZjgxMzY2MWRmPl0gbWVtc2V0KzB4MWYvMHhiMApbICAgIDEuNjkyMDEw
XSBQR0QgMWY3NzA2NyBQVUQgMWY3YTA2NyBQTUQgNjE0MjAwNjcgUFRFIDAKCmJ1dCBlYXJseSBt
ZW10ZXN0IHJlcG9ydCBhbGwgbWVtb3J5IGNvdWxkIGJlIGFjY2Vzc2VkIHdpdGhvdXQgcHJvYmxl
bS4KCmVhcmx5IHBhZ2UgdGFibGUgaXMgc2V0IGluIGZvbGxvd2luZyBzZXF1ZW5jZToKWyAgICAw
LjAwMDAwMF0gaW5pdF9tZW1vcnlfbWFwcGluZzogW21lbSAweDAwMDAwMDAwLTB4MDAwZmZmZmZd
ClsgICAgMC4wMDAwMDBdIGluaXRfbWVtb3J5X21hcHBpbmc6IFttZW0gMHg2ZTYwMDAwMC0weDZl
N2ZmZmZmXQpbICAgIDAuMDAwMDAwXSBpbml0X21lbW9yeV9tYXBwaW5nOiBbbWVtIDB4NmMwMDAw
MDAtMHg2ZTVmZmZmZl0KWyAgICAwLjAwMDAwMF0gaW5pdF9tZW1vcnlfbWFwcGluZzogW21lbSAw
eDAwMTAwMDAwLTB4NmJmZmZmZmZdClsgICAgMC4wMDAwMDBdIGluaXRfbWVtb3J5X21hcHBpbmc6
IFttZW0gMHg2ZTgwMDAwMC0weDZlYTA3ZmZmXQpidXQgbGF0ZXIgZWZpX2VudGVyX3ZpcnR1YWxf
bW9kZSB0cnkgc2V0IG1hcHBpbmcgYWdhaW4gd3JvbmdseS4KWyAgICAwLjAxMDY0NF0gcGlkX21h
eDogZGVmYXVsdDogMzI3NjggbWluaW11bTogMzAxClsgICAgMC4wMTUzMDJdIGluaXRfbWVtb3J5
X21hcHBpbmc6IFttZW0gMHg2NDBjNTAwMC0weDZlM2ZjZmZmXQp0aGF0IG1lYW5zIGl0IGZhaWxz
IHdpdGggcGZuX3JhbmdlX2lzX21hcHBlZC4KCkl0IHR1cm5zIG91dCB0aGF0IHdlIGhhdmUgYSBi
dWcgaW4gYWRkX3JhbmdlX3dpdGhfbWVyZ2UgYW5kIGl0IGRvZXMgbm90Cm1lcmdlIHJhbmdlIHBy
b3Blcmx5IHdoZW4gbmV3IGFkZCBvbmUgZmlsbCB0aGUgaG9sZSBiZXR3ZWVuIHR3byBleHNpdGlu
ZwpyYW5nZXMuIEluIHRoZSBjYXNlIHdoZW4gW21lbSAweDAwMTAwMDAwLTB4NmJmZmZmZmZdIGlz
IHRoZSBob2xlIGJldHdlZW4KW21lbSAweDAwMDAwMDAwLTB4MDAwZmZmZmZdIGFuZCBbbWVtIDB4
NmMwMDAwMDAtMHg2ZTdmZmZmZl0uCgpGaXggdGhlIGFkZF9yYW5nZV93aXRoX21lcmdlIGJ5IGNh
bGxpbmcgaXRzZWxmIHJlY3Vyc2l2ZWx5LgoKV2UgbmVlZCB0aGlzIGZvciB2My45IHN0YWJsZS4K
ClJlcG9ydGVkLWJ5OiAiQ2hyaXN0aWFuIEvDtm5pZyIgPGNocmlzdGlhbi5rb2VuaWdAYW1kLmNv
bT4KU2lnbmVkLW9mZi1ieTogWWluZ2hhaSBMdSA8eWluZ2hhaUBrZXJuZWwub3JnPgpDYzogc3Rh
YmxlQHZnZXIua2VybmVsLm9yZwoKLS0tCiBrZXJuZWwvcmFuZ2UuYyB8ICAgIDggKysrKystLS0K
IDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCgpJbmRleDog
bGludXgtMi42L2tlcm5lbC9yYW5nZS5jCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2tl
cm5lbC9yYW5nZS5jCisrKyBsaW51eC0yLjYva2VybmVsL3JhbmdlLmMKQEAgLTQ4LDkgKzQ4LDEx
IEBAIGludCBhZGRfcmFuZ2Vfd2l0aF9tZXJnZShzdHJ1Y3QgcmFuZ2UgKnIKIAkJZmluYWxfc3Rh
cnQgPSBtaW4ocmFuZ2VbaV0uc3RhcnQsIHN0YXJ0KTsKIAkJZmluYWxfZW5kID0gbWF4KHJhbmdl
W2ldLmVuZCwgZW5kKTsKIAotCQlyYW5nZVtpXS5zdGFydCA9IGZpbmFsX3N0YXJ0OwotCQlyYW5n
ZVtpXS5lbmQgPSAgZmluYWxfZW5kOwotCQlyZXR1cm4gbnJfcmFuZ2U7CisJCS8qIGNsZWFyIGl0
IGFuZCBhZGQgaXQgYmFjayBmb3IgZnVydGhlciBtZXJnZSAqLworCQlyYW5nZVtpXS5zdGFydCA9
IDA7CisJCXJhbmdlW2ldLmVuZCA9ICAwOworCQlyZXR1cm4gYWRkX3JhbmdlX3dpdGhfbWVyZ2Uo
cmFuZ2UsIGF6LCBucl9yYW5nZSwKKwkJCWZpbmFsX3N0YXJ0LCBmaW5hbF9lbmQpOwogCX0KIAog
CS8qIE5lZWQgdG8gYWRkIGl0OiAqLwo=
--e89a8f234a516af80604dcedabf6--
