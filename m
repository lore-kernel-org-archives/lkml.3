Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbaBEEuW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 23:50:22 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:51632 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbaBEEuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 23:50:21 -0500
MIME-Version: 1.0
In-Reply-To: <20140204225340.GB12991@kria>
References: <20140203153413.GA12991@kria>
	<CAPM=9twWniCmKNb1vxjS_PbsTqimX6EWVusA_+GZ7H9fdhQj3A@mail.gmail.com>
	<20140204225340.GB12991@kria>
Date: Wed, 5 Feb 2014 14:50:18 +1000
Message-ID: <CAPM=9txmSVnCVDZ6ni8GfqGSQqJkyuVb3PLf4dtYB0b4FdpraQ@mail.gmail.com>
Subject: Re: [3.14-rc1] cirrus driver problem (qemu)
From: Dave Airlie <airlied@gmail.com>
To: Sabrina Dubroca <sd@queasysnail.net>
Cc: Dave Airlie <airlied@redhat.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=001a11c3c8a665ea1804f1a17e1d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11c3c8a665ea1804f1a17e1d
Content-Type: text/plain; charset=ISO-8859-1

On Wed, Feb 5, 2014 at 8:53 AM, Sabrina Dubroca <sd@queasysnail.net> wrote:
> 2014-02-04, 13:20:54 +1000, Dave Airlie wrote:
>> On Tue, Feb 4, 2014 at 1:34 AM, Sabrina Dubroca <sd@queasysnail.net> wrote:
>> > When I boot 3.14-rc1 in qemu, I get the trace below. The console stops
>> > updating and I don't get a login prompt. I can login, but I can't see
>> > what I'm doing. I can login normally via SSH.
>> >
>> > If I revert the last commit in drivers/gpu/drm/cirrus:
>> >
>> > f4b4718b61d1d5a7442a4fd6863ea80c3a10e508 drm: ast,cirrus,mgag200: use drm_can_sleep
>> >
>> > the problem is solved.
>> >
>>
>> Hi does the attach patch fix it?
>>
>> Dave.
>
>
> Same problem. Didn't you reverse the logic on in_interrupt, compared
> to the old "if (!in_interrupt())" ? It looks like drm_can_sleep() is
> false when in_interrupt() is true.
>
> I modified your patch as below. Display doesn't freeze, but I still
> get the warning.

Oh wow I totally screwed up there, you are right, logic inversion.

Can you try the attached?

without the in_interrupt addition.

Dave.

--001a11c3c8a665ea1804f1a17e1d
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-drm-mgag200-ast-cirrus-fix-regression-with-drm_can_s.patch"
Content-Disposition: attachment; 
	filename="0001-drm-mgag200-ast-cirrus-fix-regression-with-drm_can_s.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hra4annd0

RnJvbSBjMzlhOGJkZDI1ODZjNjE2ZTliMzc0NmRiMTI4MTgwZDRlMGNhOGVjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEYXZlIEFpcmxpZSA8YWlybGllZEByZWRoYXQuY29tPgpEYXRl
OiBXZWQsIDUgRmViIDIwMTQgMTQ6NDc6NDUgKzEwMDAKU3ViamVjdDogW1BBVENIXSBkcm0vbWdh
ZzIwMCxhc3QsY2lycnVzOiBmaXggcmVncmVzc2lvbiB3aXRoIGRybV9jYW5fc2xlZXAKIGNvbnZl
cnNpb24KCkkgdG90YWxseSBzaWduIGludmVydGVkIG15IHdheSBvdXQgb2YgdGhpcyBvbmUuCgpS
ZXBvcnRlZC1ieTogIlNhYnJpbmEgRHVicm9jYSIgPHNkQHF1ZWFzeXNuYWlsLm5ldD4KU2lnbmVk
LW9mZi1ieTogRGF2ZSBBaXJsaWUgPGFpcmxpZWRAcmVkaGF0LmNvbT4KLS0tCiBkcml2ZXJzL2dw
dS9kcm0vYXN0L2FzdF9mYi5jICAgICAgICAgIHwgMiArLQogZHJpdmVycy9ncHUvZHJtL2NpcnJ1
cy9jaXJydXNfZmJkZXYuYyB8IDIgKy0KIGRyaXZlcnMvZ3B1L2RybS9tZ2FnMjAwL21nYWcyMDBf
ZmIuYyAgfCAyICstCiAzIGZpbGVzIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlv
bnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vYXN0L2FzdF9mYi5jIGIvZHJpdmVy
cy9ncHUvZHJtL2FzdC9hc3RfZmIuYwppbmRleCAzZjY1ZGQ2Li5hMjg2NDBmIDEwMDY0NAotLS0g
YS9kcml2ZXJzL2dwdS9kcm0vYXN0L2FzdF9mYi5jCisrKyBiL2RyaXZlcnMvZ3B1L2RybS9hc3Qv
YXN0X2ZiLmMKQEAgLTY1LDcgKzY1LDcgQEAgc3RhdGljIHZvaWQgYXN0X2RpcnR5X3VwZGF0ZShz
dHJ1Y3QgYXN0X2ZiZGV2ICphZmJkZXYsCiAJICogdGhlbiB0aGUgQk8gaXMgYmVpbmcgbW92ZWQg
YW5kIHdlIHNob3VsZAogCSAqIHN0b3JlIHVwIHRoZSBkYW1hZ2UgdW50aWwgbGF0ZXIuCiAJICov
Ci0JaWYgKCFkcm1fY2FuX3NsZWVwKCkpCisJaWYgKGRybV9jYW5fc2xlZXAoKSkKIAkJcmV0ID0g
YXN0X2JvX3Jlc2VydmUoYm8sIHRydWUpOwogCWlmIChyZXQpIHsKIAkJaWYgKHJldCAhPSAtRUJV
U1kpCmRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vY2lycnVzL2NpcnJ1c19mYmRldi5jIGIv
ZHJpdmVycy9ncHUvZHJtL2NpcnJ1cy9jaXJydXNfZmJkZXYuYwppbmRleCAyZmQ0YTkyLi4zMmJi
YmEwIDEwMDY0NAotLS0gYS9kcml2ZXJzL2dwdS9kcm0vY2lycnVzL2NpcnJ1c19mYmRldi5jCisr
KyBiL2RyaXZlcnMvZ3B1L2RybS9jaXJydXMvY2lycnVzX2ZiZGV2LmMKQEAgLTM5LDcgKzM5LDcg
QEAgc3RhdGljIHZvaWQgY2lycnVzX2RpcnR5X3VwZGF0ZShzdHJ1Y3QgY2lycnVzX2ZiZGV2ICph
ZmJkZXYsCiAJICogdGhlbiB0aGUgQk8gaXMgYmVpbmcgbW92ZWQgYW5kIHdlIHNob3VsZAogCSAq
IHN0b3JlIHVwIHRoZSBkYW1hZ2UgdW50aWwgbGF0ZXIuCiAJICovCi0JaWYgKCFkcm1fY2FuX3Ns
ZWVwKCkpCisJaWYgKGRybV9jYW5fc2xlZXAoKSkKIAkJcmV0ID0gY2lycnVzX2JvX3Jlc2VydmUo
Ym8sIHRydWUpOwogCWlmIChyZXQpIHsKIAkJaWYgKHJldCAhPSAtRUJVU1kpCmRpZmYgLS1naXQg
YS9kcml2ZXJzL2dwdS9kcm0vbWdhZzIwMC9tZ2FnMjAwX2ZiLmMgYi9kcml2ZXJzL2dwdS9kcm0v
bWdhZzIwMC9tZ2FnMjAwX2ZiLmMKaW5kZXggZjlhZGMyNy4uMTNiN2RkOCAxMDA2NDQKLS0tIGEv
ZHJpdmVycy9ncHUvZHJtL21nYWcyMDAvbWdhZzIwMF9mYi5jCisrKyBiL2RyaXZlcnMvZ3B1L2Ry
bS9tZ2FnMjAwL21nYWcyMDBfZmIuYwpAQCAtNDEsNyArNDEsNyBAQCBzdGF0aWMgdm9pZCBtZ2Ff
ZGlydHlfdXBkYXRlKHN0cnVjdCBtZ2FfZmJkZXYgKm1mYmRldiwKIAkgKiB0aGVuIHRoZSBCTyBp
cyBiZWluZyBtb3ZlZCBhbmQgd2Ugc2hvdWxkCiAJICogc3RvcmUgdXAgdGhlIGRhbWFnZSB1bnRp
bCBsYXRlci4KIAkgKi8KLQlpZiAoIWRybV9jYW5fc2xlZXAoKSkKKwlpZiAoZHJtX2Nhbl9zbGVl
cCgpKQogCQlyZXQgPSBtZ2FnMjAwX2JvX3Jlc2VydmUoYm8sIHRydWUpOwogCWlmIChyZXQpIHsK
IAkJaWYgKHJldCAhPSAtRUJVU1kpCi0tIAoxLjguNC4yCgo=
--001a11c3c8a665ea1804f1a17e1d--
