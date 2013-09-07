Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751135Ab3IGHct (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 03:32:49 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:57754 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab3IGHcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 03:32:47 -0400
MIME-Version: 1.0
In-Reply-To: <CANq1E4Q85ewwKs7VoooZVapC7-Cvy6-Xp4rGL1-1Ee7w1EcT6w@mail.gmail.com>
References: <alpine.LNX.2.00.1309061202050.26934@pobox.suse.cz>
	<20130906202022.GA353@x4>
	<CANq1E4Rf4c4zj1mD1aPr93Q2_M65DCEJhuLqcBWa5uH9tcKuWA@mail.gmail.com>
	<CA+55aFzg-dv-N7UjXx2pxUJ+QQOOy0qtp_e94PDSM=tVd=LgUw@mail.gmail.com>
	<506b9d43-f734-40f9-b137-0749a496fd6d@email.android.com>
	<CA+55aFzLy+-VF022ORuyWk-qQO7gDSQ1LZES1+bEUxz0QxrH-g@mail.gmail.com>
	<20130907032240.GA1256@core.coreip.homeip.net>
	<CANq1E4Q85ewwKs7VoooZVapC7-Cvy6-Xp4rGL1-1Ee7w1EcT6w@mail.gmail.com>
Date: Sat, 7 Sep 2013 09:32:46 +0200
Message-ID: <CANq1E4R7w3cxbJixcnn4KsdquZxd4qkWWF=iDtKTLyyb_Ca1MA@mail.gmail.com>
Subject: Re: [GIT] HID for 3.12 merge window
From: David Herrmann <dh.herrmann@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Jiri Kosina <jkosina@suse.cz>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>
Content-Type: multipart/mixed; boundary=047d7bd6c212521ce304e5c6297c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7bd6c212521ce304e5c6297c
Content-Type: text/plain; charset=ISO-8859-1

And this time also attached...

On Sat, Sep 7, 2013 at 9:31 AM, David Herrmann <dh.herrmann@gmail.com> wrote:
> Hi
>
> On Sat, Sep 7, 2013 at 5:22 AM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
>> On Fri, Sep 06, 2013 at 06:00:29PM -0700, Linus Torvalds wrote:
>>> On Fri, Sep 6, 2013 at 5:58 PM, Dmitry Torokhov
>>> <dmitry.torokhov@gmail.com> wrote:
>>> >
>>> > The patch still had problems so I'd revert it and wii bits and try again later.
>>>
>>> Ok. Mind giving me a list of commits, so that I don't have to do a
>>> trial-and-error thing? I know the primary commit that causes problems,
>>> but there are commits that seem to depend on it..
>>
>>
>> Sorry for the delay. I believe you need to revert:
>>
>> 73f8645 HID: wiimote: add support for Guitar-Hero drums
>> 61e0065 Input: introduce BTN/ABS bits for drums and guitars
>>
>> Hmm... there also was "HID: wiimote: add support for Guitar-Hero
>> guitars" but I do not see it...
>
> The commits to revert are:
>
> commit 61e00655e9cb82e034eb72b95a51072e718d14a7
> Author: David Herrmann <dh.herrmann@gmail.com>
> Date:   Mon Aug 26 19:14:46 2013 +0200
>
>     Input: introduce BTN/ABS bits for drums and guitars
>
> commit 73f8645db1913ab2475ec3c1cee8d5f748963aa7
> Author: David Herrmann <dh.herrmann@gmail.com>
> Date:   Mon Aug 26 19:14:47 2013 +0200
>
>     HID: wiimote: add support for Guitar-Hero drums
>
> commit 8e22ecb603c88b7397ab2e80b7b0811b8a1318f5
> Author: Nicolas Adenis-Lamarre <nicolas.adenis.lamarre@gmail.com>
> Date:   Mon Aug 26 19:14:48 2013 +0200
>
>     HID: wiimote: add support for Guitar-Hero guitars
>
> Last one is not from me, so I guess that's why Dmitry missed it. And
> sorry for the delay, stupid UTC+1..
> The bug only occurs for multi-touch devices (their ABS_* bits are
>>0x1f), that's why I didn't see it happening during my tests..
>
> If you didn't revert it, yet, attached (and inlined) is a patch which
> reverts the ABS_MAX change and just moves the new identifiers in
> between the others. On top of 3.12-rc1, this should fix all issues. If
> you already reverted the patches, I guess we will just push it in
> linux-next again and wait for 3.13?
>
> Thanks
> David
[..snap..]

--047d7bd6c212521ce304e5c6297c
Content-Type: application/octet-stream; 
	name="0001-Revert-Fix-Input-introduce-BTN-ABS-bits-for-drums-an.patch"
Content-Disposition: attachment; 
	filename="0001-Revert-Fix-Input-introduce-BTN-ABS-bits-for-drums-an.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hlailgxl0

RnJvbSAxM2Q1NDk0ODliNGJkMmVhZGU3MTljZjJlYzhjMzc3MjRiZTZlNjQwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEYXZpZCBIZXJybWFubiA8ZGguaGVycm1hbm5AZ21haWwuY29t
PgpEYXRlOiBTYXQsIDcgU2VwIDIwMTMgMDk6MTc6MTEgKzAyMDAKU3ViamVjdDogW1BBVENIXSBS
ZXZlcnQvRml4ICJJbnB1dDogaW50cm9kdWNlIEJUTi9BQlMgYml0cyBmb3IgZHJ1bXMgYW5kCiBn
dWl0YXJzIgoKY29tbWl0IDYxZTAwNjU1ZTljYjgyZTAzNGViNzJiOTVhNTEwNzJlNzE4ZDE0YTcK
QXV0aG9yOiBEYXZpZCBIZXJybWFubiA8ZGguaGVycm1hbm5AZ21haWwuY29tPgpEYXRlOiAgIE1v
biBBdWcgMjYgMTk6MTQ6NDYgMjAxMyArMDIwMAoKICAgIElucHV0OiBpbnRyb2R1Y2UgQlROL0FC
UyBiaXRzIGZvciBkcnVtcyBhbmQgZ3VpdGFycwoKVGhpcyBpbnRyb2R1Y2VkIHNldmVyYWwgbmV3
IGlkZW50aWZpZXJzIGZvciBkcnVtcy9ndWl0YXIgZGV2aWNlcy4gSG93ZXZlciwKaXQgYWxzbyBp
bmNyZWFzZWQgQUJTX01BWC4gVW5mb3J0dW5hdGVseSwgMHgzZiBpcyBhbHJlYWR5IHRoZSBtYXhp
bXVtIHdlCmNhbiB1c2UgZm9yIEFCU19NQVggZHVlIHRvIHRoZSBsaW1pdGVkIEVWSU9DU0FCUyBp
b2N0bC4KClJldmVydCB0aGlzIGNvbW1pdCBhbmQgbW92ZSB0aGUgbmV3IGlkZW50aWZpZXJzIHNv
bWV3aGVyZSBpbiBiZXR3ZWVuLiBXZQpuZWVkIHRvIGZpZ3VyZSBvdXQgc29tZSBvdGhlciB3YXkg
dG8gYWRkIG5ldyBpZGVudGlmaWVycyBmb3IgdGhlIGZ1dHVyZS4KVG8gYXZvaWQgdGhpcyBoYXBw
ZW5pbmcgYWdhaW4sIEkgYWRkZWQgYSBzbWFsbCBjb21tZW50LgoKVGhpcyBhbHNvIGZpeGVzIGFu
IGlzc3VlIHdoZXJlIHhmODYtaW5wdXQtZXZkZXYgZmFpbGVkIG9uIEVWSU9DR0FCUygpIGR1ZQp0
byBBQlNfTUFYIG5vdCBiZWluZyBhIGZ1bGwgbWFzay4KCk1hcmt1cyBUcmlwcGVsc2RvcmYgPG1h
cmt1c0B0cmlwcGVsc2RvcmYuZGU+ClNpZ25lZC1vZmYtYnk6IERhdmlkIEhlcnJtYW5uIDxkaC5o
ZXJybWFubkBnbWFpbC5jb20+Ci0tLQogaW5jbHVkZS9saW51eC9tb2RfZGV2aWNldGFibGUuaCB8
ICAyICstCiBpbmNsdWRlL3VhcGkvbGludXgvaW5wdXQuaCAgICAgIHwgMzMgKysrKysrKysrKysr
KysrKysrLS0tLS0tLS0tLS0tLS0tCiAyIGZpbGVzIGNoYW5nZWQsIDE5IGluc2VydGlvbnMoKyks
IDE2IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvbW9kX2RldmljZXRh
YmxlLmggYi9pbmNsdWRlL2xpbnV4L21vZF9kZXZpY2V0YWJsZS5oCmluZGV4IDMyOWFhMzAuLjQ1
ZTkyMTQgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgvbW9kX2RldmljZXRhYmxlLmgKKysrIGIv
aW5jbHVkZS9saW51eC9tb2RfZGV2aWNldGFibGUuaApAQCAtMjc3LDcgKzI3Nyw3IEBAIHN0cnVj
dCBwY21jaWFfZGV2aWNlX2lkIHsKICNkZWZpbmUgSU5QVVRfREVWSUNFX0lEX0tFWV9NSU5fSU5U
RVJFU1RJTkcJMHg3MQogI2RlZmluZSBJTlBVVF9ERVZJQ0VfSURfS0VZX01BWAkJMHgyZmYKICNk
ZWZpbmUgSU5QVVRfREVWSUNFX0lEX1JFTF9NQVgJCTB4MGYKLSNkZWZpbmUgSU5QVVRfREVWSUNF
X0lEX0FCU19NQVgJCTB4NGYKKyNkZWZpbmUgSU5QVVRfREVWSUNFX0lEX0FCU19NQVgJCTB4M2YK
ICNkZWZpbmUgSU5QVVRfREVWSUNFX0lEX01TQ19NQVgJCTB4MDcKICNkZWZpbmUgSU5QVVRfREVW
SUNFX0lEX0xFRF9NQVgJCTB4MGYKICNkZWZpbmUgSU5QVVRfREVWSUNFX0lEX1NORF9NQVgJCTB4
MDcKZGlmZiAtLWdpdCBhL2luY2x1ZGUvdWFwaS9saW51eC9pbnB1dC5oIGIvaW5jbHVkZS91YXBp
L2xpbnV4L2lucHV0LmgKaW5kZXggNzY0NTdlZS4uMTJjMzNmOCAxMDA2NDQKLS0tIGEvaW5jbHVk
ZS91YXBpL2xpbnV4L2lucHV0LmgKKysrIGIvaW5jbHVkZS91YXBpL2xpbnV4L2lucHV0LmgKQEAg
LTgxOSw4ICs4MTksMjQgQEAgc3RydWN0IGlucHV0X2tleW1hcF9lbnRyeSB7CiAKICNkZWZpbmUg
QUJTX1ZPTFVNRQkJMHgyMAogCisvKiBEcnVtcyBhbmQgZ3VpdGFycyAobW9zdGx5IHRveXMpICov
CisjZGVmaW5lIEFCU19UT01fRkFSX0xFRlQJMHgyMQorI2RlZmluZSBBQlNfVE9NX0xFRlQJCTB4
MjIKKyNkZWZpbmUgQUJTX1RPTV9SSUdIVAkJMHgyMworI2RlZmluZSBBQlNfVE9NX0ZBUl9SSUdI
VAkweDI0CisjZGVmaW5lIEFCU19DWU1CQUxfRkFSX0xFRlQJMHgyNQorI2RlZmluZSBBQlNfQ1lN
QkFMX0xFRlQJCTB4MjYKKyNkZWZpbmUgQUJTX0NZTUJBTF9SSUdIVAkweDI3CisKICNkZWZpbmUg
QUJTX01JU0MJCTB4MjgKIAorLyogRHJ1bXMgYW5kIGd1aXRhcnMgY29udGludWVkICovCisjZGVm
aW5lIEFCU19DWU1CQUxfRkFSX1JJR0hUCTB4MjkKKyNkZWZpbmUgQUJTX0JBU1MJCTB4MmEKKyNk
ZWZpbmUgQUJTX0hJX0hBVAkJMHgyYgorI2RlZmluZSBBQlNfRlJFVF9CT0FSRAkJMHgyYwkvKiBH
dWl0YXIgZnJldCBib2FyZCwgdmVydGljYWwgcG9zICovCisjZGVmaW5lIEFCU19XSEFNTVlfQkFS
CQkweDJkCS8qIEd1aXRhciB3aGFtbXkgYmFyIChvciB2aWJyYXRvKSAqLworCiAjZGVmaW5lIEFC
U19NVF9TTE9UCQkweDJmCS8qIE1UIHNsb3QgYmVpbmcgbW9kaWZpZWQgKi8KICNkZWZpbmUgQUJT
X01UX1RPVUNIX01BSk9SCTB4MzAJLyogTWFqb3IgYXhpcyBvZiB0b3VjaGluZyBlbGxpcHNlICov
CiAjZGVmaW5lIEFCU19NVF9UT1VDSF9NSU5PUgkweDMxCS8qIE1pbm9yIGF4aXMgKG9taXQgaWYg
Y2lyY3VsYXIpICovCkBAIC04MzcsMjEgKzg1Myw4IEBAIHN0cnVjdCBpbnB1dF9rZXltYXBfZW50
cnkgewogI2RlZmluZSBBQlNfTVRfVE9PTF9YCQkweDNjCS8qIENlbnRlciBYIHRvb2wgcG9zaXRp
b24gKi8KICNkZWZpbmUgQUJTX01UX1RPT0xfWQkJMHgzZAkvKiBDZW50ZXIgWSB0b29sIHBvc2l0
aW9uICovCiAKLS8qIERydW1zIGFuZCBndWl0YXJzIChtb3N0bHkgdG95cykgKi8KLSNkZWZpbmUg
QUJTX1RPTV9GQVJfTEVGVAkweDQwCi0jZGVmaW5lIEFCU19UT01fTEVGVAkJMHg0MQotI2RlZmlu
ZSBBQlNfVE9NX1JJR0hUCQkweDQyCi0jZGVmaW5lIEFCU19UT01fRkFSX1JJR0hUCTB4NDMKLSNk
ZWZpbmUgQUJTX0NZTUJBTF9GQVJfTEVGVAkweDQ0Ci0jZGVmaW5lIEFCU19DWU1CQUxfTEVGVAkJ
MHg0NQotI2RlZmluZSBBQlNfQ1lNQkFMX1JJR0hUCTB4NDYKLSNkZWZpbmUgQUJTX0NZTUJBTF9G
QVJfUklHSFQJMHg0NwotI2RlZmluZSBBQlNfQkFTUwkJMHg0OAotI2RlZmluZSBBQlNfSElfSEFU
CQkweDQ5Ci0jZGVmaW5lIEFCU19GUkVUX0JPQVJECQkweDRhCS8qIEd1aXRhciBmcmV0IGJvYXJk
LCB2ZXJ0aWNhbCBwb3MgKi8KLSNkZWZpbmUgQUJTX1dIQU1NWV9CQVIJCTB4NGIJLyogR3VpdGFy
IHdoYW1teSBiYXIgKG9yIHZpYnJhdG8pICovCi0KLSNkZWZpbmUgQUJTX01BWAkJCTB4NGYKKy8q
IEVWSU9DU0FCUygpIGRvZXMgbm90IHN1cHBvcnQgQUJTX01BWCA+IDB4M2YgKi8KKyNkZWZpbmUg
QUJTX01BWAkJCTB4M2YKICNkZWZpbmUgQUJTX0NOVAkJCShBQlNfTUFYKzEpCiAKIC8qCi0tIAox
LjguNAoK
--047d7bd6c212521ce304e5c6297c--
