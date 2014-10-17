Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbaJQNbf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 09:31:35 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:55719 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbaJQNbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 09:31:32 -0400
Message-ID: <54411A30.6070401@suse.cz>
Date: Fri, 17 Oct 2014 15:31:28 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH -next 05/10] tty: Document defunct ASYNC_* bits in uapi
 header
References: <1413492867-20679-1-git-send-email-peter@hurleysoftware.com> <1413492867-20679-6-git-send-email-peter@hurleysoftware.com> <5440D781.1080308@suse.cz> <54410F19.3040607@hurleysoftware.com>
In-Reply-To: <54410F19.3040607@hurleysoftware.com>
Content-Type: multipart/mixed;
 boundary="------------050005080604070900030909"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050005080604070900030909
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

On 10/17/2014, 02:44 PM, Peter Hurley wrote:
> Hi Jiri,
> 
> On 10/17/2014 04:46 AM, Jiri Slaby wrote:
>> On 10/16/2014, 10:54 PM, Peter Hurley wrote:
>>> Note the serial_struct flags for which the kernel ignores and performs
>>> no action. The flags cannot be removed since they form part of the
>>> userspace interface via the TIOCSSERIAL/TIOCGSERIAL ioctls.
>>
>> Hello,
>>
>> would it make sense to mark them deprecated somehow? At build time
> 
> A build warning when the macro is expanded would be best, but my
> c-preprocessor-fu is terrible, so I have no idea how to make that work.

We can define a deprecated type like:

typedef __u32 __attribute__((deprecated)) depr_tty_t

and then do define:

#define ASYNCB_FLAG_1 (depr_tty_t)1
#define ASYNCB_FLAG_2 (depr_tty_t)2

Etc.

However, I do not know if it is desirable AND whether all compilers out
there used in userspace support that attribute.

>> or
>> at least warn in the serial core that "current->comm is using a
>> deprecated flag"_ratelimited()?
> 
> If we just print the message at TIOCSSERIAL if any of the deprecated
> bits are set, that would be ok. Probably the only issue would be that
> setserial could cause this message at will, so log flooding would be
> a concern.

That's why _ratelimited(). So something like the patch attached. But it
needs to be put to a separate function, out of the line.

/me currently builds a kernel to see who, if anybody, uses the flags on
a up-to-date system...

thanks,
-- 
js
suse labs

--------------050005080604070900030909
Content-Type: application/mbox;
 name="0001-tty-warn-on-deprecated-flags.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="0001-tty-warn-on-deprecated-flags.patch"

RnJvbSAxNjA2NGRiNmViNjQ2NjNmOGExNWY0NDlhN2UzYmM2OWVkODg1MzIwIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBKaXJpIFNsYWJ5IDxqc2xhYnlAc3VzZS5jej4KRGF0
ZTogRnJpLCAxNyBPY3QgMjAxNCAxMTowNTowMiArMDIwMApTdWJqZWN0OiBbUEFUQ0ggMS8x
XSB0dHk6IHdhcm4gb24gZGVwcmVjYXRlZCBmbGFncwoKTm90LXNpZ25lZC1vZmYtYnk6IEpp
cmkgU2xhYnkgPGpzbGFieUBzdXNlLmN6PgotLS0KIGRyaXZlcnMvdHR5L3R0eV9pby5jICAg
ICAgICAgICB8IDE2ICsrKysrKysrKysrKysrKysKIGluY2x1ZGUvdWFwaS9saW51eC90dHlf
ZmxhZ3MuaCB8ICAyICsrCiAyIGZpbGVzIGNoYW5nZWQsIDE4IGluc2VydGlvbnMoKykKCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL3R0eS90dHlfaW8uYyBiL2RyaXZlcnMvdHR5L3R0eV9pby5j
CmluZGV4IDhmYmFkMzQxMGM3NS4uNDZiMmIzYjM1NTVjIDEwMDY0NAotLS0gYS9kcml2ZXJz
L3R0eS90dHlfaW8uYworKysgYi9kcml2ZXJzL3R0eS90dHlfaW8uYwpAQCAtMjgzMCw2ICsy
ODMwLDIyIEBAIGxvbmcgdHR5X2lvY3RsKHN0cnVjdCBmaWxlICpmaWxlLCB1bnNpZ25lZCBp
bnQgY21kLCB1bnNpZ25lZCBsb25nIGFyZykKIAkJCWJyZWFrOwogCQl9CiAJCWJyZWFrOwor
CWNhc2UgVElPQ1NTRVJJQUw6CisJCXsKKwkJCXN0YXRpYyBERUZJTkVfUkFURUxJTUlUX1NU
QVRFKGRlcHJfZmxhZ3MsCisJCQkJCURFRkFVTFRfUkFURUxJTUlUX0lOVEVSVkFMLAorCQkJ
CQlERUZBVUxUX1JBVEVMSU1JVF9CVVJTVCk7CisJCQlpbnQgZmxhZ3M7CisJCQljaGFyIGNv
bW1bVEFTS19DT01NX0xFTl07CisJCQlpZiAoIWdldF91c2VyKGZsYWdzLCAoaW50IF9fdXNl
ciAqKWFyZykgJiYKKwkJCQkJKGZsYWdzICYgQVNZTkNfREVQUkVDQVRFRCkgJiYKKwkJCQkJ
X19yYXRlbGltaXQoJmRlcHJfZmxhZ3MpKSB7CisJCQkJcHJfd2FybmluZygiJXMgaXMgdXNp
bmcgZGVwcmVjYXRlZCBmbGFnczogJS44eFxuIiwKKwkJCQkJCWdldF90YXNrX2NvbW0oY29t
bSwgY3VycmVudCksCisJCQkJCQlmbGFncyAmIEFTWU5DX0RFUFJFQ0FURUQpOworCQkJfQor
CQl9CisJCWJyZWFrOwogCX0KIAlpZiAodHR5LT5vcHMtPmlvY3RsKSB7CiAJCXJldHZhbCA9
ICh0dHktPm9wcy0+aW9jdGwpKHR0eSwgY21kLCBhcmcpOwpkaWZmIC0tZ2l0IGEvaW5jbHVk
ZS91YXBpL2xpbnV4L3R0eV9mbGFncy5oIGIvaW5jbHVkZS91YXBpL2xpbnV4L3R0eV9mbGFn
cy5oCmluZGV4IGVlZmNiNDgzYTJjMC4uODc5YjkxNzEzZTdjIDEwMDY0NAotLS0gYS9pbmNs
dWRlL3VhcGkvbGludXgvdHR5X2ZsYWdzLmgKKysrIGIvaW5jbHVkZS91YXBpL2xpbnV4L3R0
eV9mbGFncy5oCkBAIC01OSw2ICs1OSw4IEBACiAjZGVmaW5lIEFTWU5DX0FVVE9QUk9CRQkJ
KDFVIDw8IEFTWU5DQl9BVVRPUFJPQkUpCiAKICNkZWZpbmUgQVNZTkNfRkxBR1MJCSgoMVUg
PDwgKEFTWU5DQl9MQVNUX1VTRVIgKyAxKSkgLSAxKQorI2RlZmluZSBBU1lOQ19ERVBSRUNB
VEVECShBU1lOQ19TRVNTSU9OX0xPQ0tPVVQgfCBBU1lOQ19QR1JQX0xPQ0tPVVQgfCBcCisJ
CUFTWU5DX0NBTExPVVRfTk9IVVAgfCBBU1lOQ19BVVRPUFJPQkUpCiAjZGVmaW5lIEFTWU5D
X1VTUl9NQVNLCQkoQVNZTkNfU1BEX01BU0t8QVNZTkNfQ0FMTE9VVF9OT0hVUHwgXAogCQlB
U1lOQ19MT1dfTEFURU5DWSkKICNkZWZpbmUgQVNZTkNfU1BEX0NVU1QJCShBU1lOQ19TUERf
SEl8QVNZTkNfU1BEX1ZISSkKLS0gCjIuMS4xCgo=
--------------050005080604070900030909--
