Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933862Ab3B0Aay (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:30:54 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:47298 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933299Ab3B0Aav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 19:30:51 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFzckUoJGEywgentKT-vQieiuLu-mQtELiA6UotWqBWH7A@mail.gmail.com>
References: <20130226045424.GA3576@osiris>
	<CA+55aFx8pUSHPhC_-ob2i5BbvBkEC4BVYtAbNkf3+FE+=3AmgA@mail.gmail.com>
	<20130226125739.GA3924@osiris>
	<CA+55aFycXwZi-U2uJWWusLGeaV3=BMEBdgcxGN9Lo0QcHHUrDA@mail.gmail.com>
	<CA+55aFzCU3jKDssYj9sDJU-VkugCfy_Cv5+VhMv9renZ94jRdQ@mail.gmail.com>
	<CA+55aFzckUoJGEywgentKT-vQieiuLu-mQtELiA6UotWqBWH7A@mail.gmail.com>
Date: Tue, 26 Feb 2013 16:30:50 -0800
X-Google-Sender-Auth: r8sAM7eHc3X1F0h6OvEgBv0A0Dc
Message-ID: <CA+55aFz3JW6HnTC-4xqOBsgQNboLbjvZnQ0h7KfaZjQVinAt2g@mail.gmail.com>
Subject: Re: bug in generic strncpy_from_user
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Content-Type: multipart/mixed; boundary=bcaec54d4cfcdb5c9604d6a9e249
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bcaec54d4cfcdb5c9604d6a9e249
Content-Type: text/plain; charset=UTF-8

On Tue, Feb 26, 2013 at 3:43 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So I'll need to extend on that logic a bit more.

Ok, here's the fleshed-out patch. Also fixed to use "expand_stack()",
which is what the page fault handling actually uses. And it has the
GROWSUP case as well as a comment about this all.

So it all looks good. But it's still totally and entirely untested.

Because that's how I roll. Gangsta life!

              Linus

--bcaec54d4cfcdb5c9604d6a9e249
Content-Type: application/octet-stream; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hdnqyzfv0

IG1tL21tYXAuYyB8IDI3ICsrKysrKysrKysrKysrKysrKysrKysrKysrKwogMSBmaWxlIGNoYW5n
ZWQsIDI3IGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9tbS9tbWFwLmMgYi9tbS9tbWFwLmMK
aW5kZXggMzE4ZTEyMWFmZmRhLi4yZmQ5ZjAzZWVlNmYgMTAwNjQ0Ci0tLSBhL21tL21tYXAuYwor
KysgYi9tbS9tbWFwLmMKQEAgLTIxODUsOSArMjE4NSwyOCBAQCBpbnQgZXhwYW5kX2Rvd253YXJk
cyhzdHJ1Y3Qgdm1fYXJlYV9zdHJ1Y3QgKnZtYSwKIAlyZXR1cm4gZXJyb3I7CiB9CiAKKy8qCisg
KiBOb3RlIGhvdyBleHBhbmRfc3RhY2soKSByZWZ1c2VzIHRvIGV4cGFuZCB0aGUgc3RhY2sgYWxs
IHRoZSB3YXkgdG8KKyAqIGFidXQgdGhlIG5leHQgdmlydHVhbCBtYXBwaW5nLCAqdW5sZXNzKiB0
aGF0IG1hcHBpbmcgaXRzZWxmIGlzIGFsc28KKyAqIGEgc3RhY2sgbWFwcGluZy4gV2Ugd2FudCB0
byBsZWF2ZSByb29tIGZvciBhIGd1YXJkIHBhZ2UsIGFmdGVyIGFsbAorICogKHRoZSBndWFyZCBw
YWdlIGl0c2VsZiBpcyBub3QgYWRkZWQgaGVyZSwgdGhhdCBpcyBkb25lIGJ5IHRoZQorICogYWN0
dWFsIHBhZ2UgZmF1bHRpbmcgbG9naWMpCisgKgorICogVGhpcyBtYXRjaGVzIHRoZSBiZWhhdmlv
ciBvZiB0aGUgZ3VhcmQgcGFnZSBsb2dpYyAoc2VlIG1tL21lbW9yeS5jOgorICogY2hlY2tfc3Rh
Y2tfZ3VhcmRfcGFnZSgpKSwgd2hpY2ggb25seSBhbGxvd3MgdGhlIGd1YXJkIHBhZ2UgdG8gYmUK
KyAqIHJlbW92ZWQgdW5kZXIgdGhlc2UgY2lyY3Vtc3RhbmNlcy4KKyAqLwogI2lmZGVmIENPTkZJ
R19TVEFDS19HUk9XU1VQCiBpbnQgZXhwYW5kX3N0YWNrKHN0cnVjdCB2bV9hcmVhX3N0cnVjdCAq
dm1hLCB1bnNpZ25lZCBsb25nIGFkZHJlc3MpCiB7CisJc3RydWN0IHZtX2FyZWFfc3RydWN0ICpu
ZXh0OworCisJYWRkcmVzcyAmPSBQQUdFX01BU0s7CisJbmV4dCA9IHZtYS0+dm1fbmV4dDsKKwlp
ZiAobmV4dCAmJiBuZXh0LT52bV9zdGFydCA9PSBhZGRyZXNzICsgUEFHRV9TSVpFKSB7CisJCWlm
ICghKG5leHQtPnZtX2ZsYWdzICYgVk1fR1JPV1NVUCkpCisJCQlyZXR1cm4gLUVOT01FTTsKKwl9
CiAJcmV0dXJuIGV4cGFuZF91cHdhcmRzKHZtYSwgYWRkcmVzcyk7CiB9CiAKQEAgLTIyMDksNiAr
MjIyOCwxNCBAQCBmaW5kX2V4dGVuZF92bWEoc3RydWN0IG1tX3N0cnVjdCAqbW0sIHVuc2lnbmVk
IGxvbmcgYWRkcikKICNlbHNlCiBpbnQgZXhwYW5kX3N0YWNrKHN0cnVjdCB2bV9hcmVhX3N0cnVj
dCAqdm1hLCB1bnNpZ25lZCBsb25nIGFkZHJlc3MpCiB7CisJc3RydWN0IHZtX2FyZWFfc3RydWN0
ICpwcmV2OworCisJYWRkcmVzcyAmPSBQQUdFX01BU0s7CisJcHJldiA9IHZtYS0+dm1fcHJldjsK
KwlpZiAocHJldiAmJiBwcmV2LT52bV9lbmQgPT0gYWRkcmVzcykgeworCQlpZiAoIShwcmV2LT52
bV9mbGFncyAmIFZNX0dST1dTRE9XTikpCisJCQlyZXR1cm4gLUVOT01FTTsKKwl9CiAJcmV0dXJu
IGV4cGFuZF9kb3dud2FyZHModm1hLCBhZGRyZXNzKTsKIH0KIAo=
--bcaec54d4cfcdb5c9604d6a9e249--
