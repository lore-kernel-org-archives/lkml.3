Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab3J3N5r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 09:57:47 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:33659 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248Ab3J3N5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 09:57:46 -0400
MIME-Version: 1.0
In-Reply-To: <CABgQ-TisBA4+re7veEyK+F_jfG-mmuXT-R+hdHd1duqsx0qYLQ@mail.gmail.com>
References: <CABgQ-Ti0aaxqVGF0R-huQur=EGCTyXM0w-gyz9TenC=msucJqA@mail.gmail.com>
	<1383053609-2895-1-git-send-email-changbin.du@gmail.com>
	<1383063623.2713.12.camel@joe-AO722>
	<CABgQ-TisBA4+re7veEyK+F_jfG-mmuXT-R+hdHd1duqsx0qYLQ@mail.gmail.com>
Date: Wed, 30 Oct 2013 21:57:44 +0800
Message-ID: <CABgQ-TjqiALfieAz8+6nt6TVxy93dJRv1UzkGMRMVO1CgfwXNg@mail.gmail.com>
Subject: Re: [PATCH v3] dynamic_debug: add wildcard support to filter files/functions/modules
From: Changbin Du <changbin.du@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Jason Baron <jbaron@akamai.com>,
        "linux-kernel@vger.kernel.org list" <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=089e013d1442b686a604e9f5b7e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e013d1442b686a604e9f5b7e5
Content-Type: text/plain; charset=UTF-8

2013/10/30 Changbin Du <changbin.du@gmail.com>:
> 2013/10/30 Joe Perches <joe@perches.com>:
>> On Tue, 2013-10-29 at 21:33 +0800, Du, Changbin wrote:
>>> This patch add wildcard '*'(matches zero or more characters) and '?'
>>> (matches one character) support when qurying debug flags.
>>
>> Hi again.  Some trivial notes and a possible logic error:
>>
>> Maybe nicer with an if/else, I think you're still
>> missing a reset of "star = false;" and I also think
>> it's better to use a break here too.
>>
>>                 if (*s == *p) {
>>                         s++;
>>                         p++;
>>                         star = false;
>>                 } else {
>>                         if (!star)
>>                                 return false;
>>                         string++;
>>                         s = string;
>>                         p = pattern;
>>                 }
>>                 break;
>
> I have run loss of test before sending patch. all case passed. But I
> will double check if need reset star flag. really thanks!

Hi, Joe. I checked this. The "star = false;" can not have here.
Attachment is a test program that I use it to test the algorithm. it will
compare this non-recursion and old recursion if they are equal.

Now I will send the v3 patch, please help to review. Thanks!

--089e013d1442b686a604e9f5b7e5
Content-Type: text/x-csrc; charset=US-ASCII; name="wildcard_alg.c"
Content-Disposition: attachment; filename="wildcard_alg.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hnemlg0l0

I2luY2x1ZGUgPHN0ZGlvLmg+DQojaW5jbHVkZSA8c3RkbGliLmg+DQoNCiNkZWZpbmUgYm9vbCBp
bnQNCiNkZWZpbmUgZmFsc2UgMA0KI2RlZmluZSB0cnVlICAxDQoNCnN0YXRpYyBpbnQgbWF0Y2hf
cGF0dGVybjEoY2hhciAqcGF0LCBjaGFyICpzdHIpDQp7DQoJc3dpdGNoICgqcGF0KSB7DQoJY2Fz
ZSAnXDAnOg0KCQlyZXR1cm4gISpzdHI7DQoJY2FzZSAnKic6DQoJCXJldHVybiAgbWF0Y2hfcGF0
dGVybjEocGF0KzEsIHN0cikgfHwNCgkJICAgICAgICAoKnN0ciAmJiBtYXRjaF9wYXR0ZXJuMShw
YXQsIHN0cisxKSk7DQoJY2FzZSAnPyc6DQoJCXJldHVybiAqc3RyICYmIG1hdGNoX3BhdHRlcm4x
KHBhdCsxLCBzdHIrMSk7DQoJZGVmYXVsdDoNCgkJcmV0dXJuICpwYXQgPT0gKnN0ciAmJiBtYXRj
aF9wYXR0ZXJuMShwYXQrMSwgc3RyKzEpOw0KCX0NCn0NCg0Kc3RhdGljIGJvb2wgbWF0Y2hfcGF0
dGVybjIoY29uc3QgY2hhciAqcGF0dGVybiwgY29uc3QgY2hhciAqc3RyaW5nKQ0Kew0KCWNvbnN0
IGNoYXIgKnM7DQoJY29uc3QgY2hhciAqcDsNCglib29sIHN0YXIgPSBmYWxzZTsNCg0KbG9vcDoN
Cglmb3IgKHMgPSBzdHJpbmcsIHAgPSBwYXR0ZXJuOyAqczsgKytzLCArK3ApIHsNCgkJc3dpdGNo
ICgqcCkgew0KCQljYXNlICc/JzoNCgkJCWJyZWFrOw0KCQljYXNlICcqJzoNCgkJCXN0YXIgPSB0
cnVlOw0KCQkJc3RyaW5nID0gczsNCgkJCXBhdHRlcm4gPSBwOw0KCQkJaWYgKCEqKytwYXR0ZXJu
KQ0KCQkJCXJldHVybiAxOw0KCQkJZ290byBsb29wOw0KCQlkZWZhdWx0Og0KCQkJaWYgKCpzICE9
ICpwKQ0KCQkJCWdvdG8gc3Rhcl9jaGVjazsNCgkJCWJyZWFrOw0KCQl9DQoJfQ0KCWlmICgqcCA9
PSAnKicpDQoJCSsrcDsNCglyZXR1cm4gKCEqcCk7DQoNCnN0YXJfY2hlY2s6DQoJaWYgKCFzdGFy
KQ0KCQlyZXR1cm4gMDsNCglzdHJpbmcrKzsNCglnb3RvIGxvb3A7DQp9DQoNCnN0YXRpYyBib29s
IG1hdGNoX3BhdHRlcm4zKGNvbnN0IGNoYXIgKnBhdHRlcm4sIGNvbnN0IGNoYXIgKnN0cmluZykN
CnsNCgljb25zdCBjaGFyICpzID0gc3RyaW5nOw0KCWNvbnN0IGNoYXIgKnAgPSBwYXR0ZXJuOw0K
CWJvb2wgc3RhciA9IGZhbHNlOw0KDQoJd2hpbGUgKCpzKSB7DQoJCXN3aXRjaCAoKnApIHsNCgkJ
Y2FzZSAnPyc6DQoJCQlzKys7DQoJCQlwKys7DQoJCQlicmVhazsNCgkJY2FzZSAnKic6DQoJCQlz
dGFyID0gdHJ1ZTsNCgkJCXN0cmluZyA9IHM7DQoJCQlpZiAoISorK3ApDQoJCQkJcmV0dXJuIHRy
dWU7DQoJCQlwYXR0ZXJuID0gcDsNCgkJCWJyZWFrOw0KCQlkZWZhdWx0Og0KCQkJaWYgKCpzID09
ICpwKSB7DQoJCQkJcysrOw0KCQkJCXArKzsNCgkJCX0gZWxzZSB7DQoJCQkJaWYgKCFzdGFyKQ0K
CQkJCQlyZXR1cm4gZmFsc2U7DQoJCQkJc3RyaW5nKys7DQoJCQkJcyA9IHN0cmluZzsNCgkJCQlw
ID0gcGF0dGVybjsNCgkJCX0NCgkJCWJyZWFrOw0KCQl9DQoJfQ0KDQoJaWYgKCpwID09ICcqJykN
CgkJKytwOw0KCXJldHVybiAhKnA7DQp9DQoNCg0KDQovKiByZXR1cm4gMCBpZiBhbGwgdGhlIHJl
c3VsdCBvZiB0aHJlZSBmdW5jdGlvbiBpcyBzYW1lLCBlbHNlIHJldHVybiAxLiAqLw0Kc3RhdGlj
IGludCB0ZXN0X21hdGNoKCkNCnsNCgljaGFyICpTdHJbXSA9IHsgIlpJUCIsDQoJICAgICAgICAg
ICAgICAgICIuWklQIiwNCgkgICAgICAgICAgICAgICAgIlpJUC4iLA0KCSAgICAgICAgICAgICAg
ICAiYWZkWmZkYVpJUCINCgkgICAgICAgICAgICAgICAgImFkZnNhZlpmZHNhZGZJZmRhZmRzUGZk
YXNkZiIsDQoJICAgICAgICAgICAgICAgICJhY2NiZGRjcnJmZGRodXVsZ2duZmZwaGhxZ2d5eXly
bm52aGdmbGxsbW1ubm5ua3BpLml1dXVpeXQiLA0KCSAgICAgICAgICAgICAgICAiQS5ia2RmYWRm
YXNmYS5mYXNrZmEuc2ZhZj9rbC5BLlpJUCIsDQoJICAgICAgICAgICAgICAgICJBc2RoZ2VybHRo
d2VnanNka2xnanNkZ2pzZGtnanNkZ2pzZGcuWklQIiwNCgkgICAgICAgICAgICAgICAgIkFBZ3Nk
anR3ZW9ydXRlcmp0ZXJ0d2VpdXR3ZWp0d2VqdHdldHdvZWp0d2VqdHJ3bGVBQS5aSVAiLA0KCSAg
ICAgICAgICAgICAgICAiQWdqc2RnamRzamdzZGtqZ3NkamdzamQ/Z2pzZD9nanNkP2dqP3NkZ2ou
QS5aSWRnanNka2pnbHNkamdQUE8iLA0KCSAgICAgICAgICAgICAgICAiZmFzZGZlMzIzcmVydGV0
ZXI1NXJ0cmV3dHJ3d2UiDQoJICAgICAgICAgICAgICB9Ow0KCWNoYXIgKlBhdHRbXSA9IHsgIj9a
SVAiLCAiKlpJUCIsICJaSVAuIiwgIipaSVAiLCAiKj9aSVAiLCAiPyo/WklQIiwgIio/Kj9aSVAi
LCAiKloqSSpQKiIsDQoJICAgICAgICAgICAgICAgICAiKj8qPypaSVAiLCAiYSo/Kj8qWklQIiwg
IipaST8iLCAiKlpJPyIsICIqWkkqIiwgIipaSSoiLA0KCSAgICAgICAgICAgICAgICAgImEqPyo/
IiwgIj8qPyoiLCJaSVAiLCAiWklQIiwgIkFBWklQIiwgIkFaSVAiLCAiQUFBQVpJUCIsICJBQVpJ
UFBPIg0KCSAgICAgICAgICAgICAgIH07DQoJaW50IGkgPSAwLCBqID0gMCwgcmV0ID0gMDsNCg0K
CWZvciAoaSA9IDAgOyBpIDwgc2l6ZW9mKFBhdHQpL3NpemVvZihQYXR0WzBdKTsgaSsrKSB7DQoJ
CWZvciAoaiA9IDA7IGogPCBzaXplb2YoU3RyKS9zaXplb2YoU3RyWzBdKTsgaisrKSB7DQoJCQlj
aGFyICpwYXQgPSBQYXR0W2ldOw0KCQkJY2hhciAqc3RyID0gU3RyW2pdOw0KCQkJYm9vbCBtYXRj
aDEgPSBtYXRjaF9wYXR0ZXJuMShwYXQsIHN0cik7DQoJCQlib29sIG1hdGNoMiA9IG1hdGNoX3Bh
dHRlcm4yKHBhdCwgc3RyKTsNCgkJCWJvb2wgbWF0Y2gzID0gbWF0Y2hfcGF0dGVybjMocGF0LCBz
dHIpOw0KDQoJCQlwcmludGYoIlwiJXNcIiA9Pz0gXCIlc1wiXG4iLCBwYXQsIHN0cik7DQoJCQlp
ZiAobWF0Y2gxID09IG1hdGNoMiAmJiBtYXRjaDIgPT0gbWF0Y2gzKQ0KCQkJCXByaW50ZigiQWxs
IHRocmVlIHJlc3VsdCBpcyBzYW1lOiAlZFxuIiwgbWF0Y2gxKTsNCgkJCWVsc2Ugew0KCQkJCXBy
aW50ZigiKioqKlxuIg0KCQkJCSAgICAgICAiKioqKlNvbWVvbmUgaXMgd3Jvbmc6IG1hdGNoMT0l
ZCBtYXRjaDI9JWQgbWF0Y2gzPSVkXG4iDQoJCQkJICAgICAgICIqKioqXG4iLA0KCQkJCSAgICAg
ICBtYXRjaDEsIG1hdGNoMiwgbWF0Y2gzKTsNCgkJCQlyZXQgPSAxOw0KCQkJfQ0KCQkJcHJpbnRm
KCJcbiIpOw0KCQl9DQoJCXByaW50ZigiXG4iKTsNCgl9DQoJcmV0dXJuIHJldDsNCn0NCg0KaW50
IG1haW4oKQ0Kew0KCXJldHVybiB0ZXN0X21hdGNoKCk7DQp9DQo=
--089e013d1442b686a604e9f5b7e5--
