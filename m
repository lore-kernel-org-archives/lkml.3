Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742AbaE0RFE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 13:05:04 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:60959 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbaE0RFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 13:05:00 -0400
MIME-Version: 1.0
In-Reply-To: <20140527144116.GK17233@tucsk.piliscsaba.szeredi.hu>
References: <20140527144116.GK17233@tucsk.piliscsaba.szeredi.hu>
Date: Tue, 27 May 2014 10:04:58 -0700
X-Google-Sender-Auth: _-WEQD0_RRnna2yxdI1p1VjYSrY
Message-ID: <CA+55aFzY--F_2BiZ4-mkFh+0Oy1SX7nBw7cAsSni_iDOtwU-mw@mail.gmail.com>
Subject: Re: [PATCH] vfs: fix vmplice_to_user()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=089e013a13b0252b4004fa64b25a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e013a13b0252b4004fa64b25a
Content-Type: text/plain; charset=UTF-8

On Tue, May 27, 2014 at 7:41 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> This patch fixes two bugs:

Mind if I change it to avoid the "goto"? I don't think goto is evil,
but in this case it doesn't seem to buy anything, except to perhaps
make the patch a bit smaller at the expense of making the result a bit
harder to read.

Replacing the

   if (ret <= 0)
      goto out;

with

   if (ret > 0) {
       ...
   }

also allows moving the various variable declarations closer to their use.

So something like the attached..

             Linus

--089e013a13b0252b4004fa64b25a
Content-Type: text/plain; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hvpgfjqw0

IGZzL3NwbGljZS5jIHwgMzAgKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tCiAxIGZpbGUg
Y2hhbmdlZCwgMTUgaW5zZXJ0aW9ucygrKSwgMTUgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEv
ZnMvc3BsaWNlLmMgYi9mcy9zcGxpY2UuYwppbmRleCA5YmMwN2QyYjUzY2YuLjZiMTExNTAwNTE1
MCAxMDA2NDQKLS0tIGEvZnMvc3BsaWNlLmMKKysrIGIvZnMvc3BsaWNlLmMKQEAgLTE1MzIsMTIg
KzE1MzIsOSBAQCBzdGF0aWMgbG9uZyB2bXNwbGljZV90b191c2VyKHN0cnVjdCBmaWxlICpmaWxl
LCBjb25zdCBzdHJ1Y3QgaW92ZWMgX191c2VyICp1aW92LAogCQkJICAgICB1bnNpZ25lZCBsb25n
IG5yX3NlZ3MsIHVuc2lnbmVkIGludCBmbGFncykKIHsKIAlzdHJ1Y3QgcGlwZV9pbm9kZV9pbmZv
ICpwaXBlOwotCXN0cnVjdCBzcGxpY2VfZGVzYyBzZDsKLQlsb25nIHJldDsKIAlzdHJ1Y3QgaW92
ZWMgaW92c3RhY2tbVUlPX0ZBU1RJT1ZdOwogCXN0cnVjdCBpb3ZlYyAqaW92ID0gaW92c3RhY2s7
Ci0Jc3RydWN0IGlvdl9pdGVyIGl0ZXI7Ci0Jc3NpemVfdCBjb3VudCA9IDA7CisJbG9uZyByZXQ7
CiAKIAlwaXBlID0gZ2V0X3BpcGVfaW5mbyhmaWxlKTsKIAlpZiAoIXBpcGUpCkBAIC0xNTQ1LDIw
ICsxNTQyLDIzIEBAIHN0YXRpYyBsb25nIHZtc3BsaWNlX3RvX3VzZXIoc3RydWN0IGZpbGUgKmZp
bGUsIGNvbnN0IHN0cnVjdCBpb3ZlYyBfX3VzZXIgKnVpb3YsCiAKIAlyZXQgPSByd19jb3B5X2No
ZWNrX3V2ZWN0b3IoUkVBRCwgdWlvdiwgbnJfc2VncywKIAkJCQkgICAgQVJSQVlfU0laRShpb3Zz
dGFjayksIGlvdnN0YWNrLCAmaW92KTsKLQlpZiAocmV0IDw9IDApCi0JCXJldHVybiByZXQ7CisJ
aWYgKHJldCA+IDApIHsKKwkJc3RydWN0IHNwbGljZV9kZXNjIHNkOworCQlzdHJ1Y3QgaW92X2l0
ZXIgaXRlcjsKKwkJc3NpemVfdCBjb3VudCA9IHJldDsKIAotCWlvdl9pdGVyX2luaXQoJml0ZXIs
IGlvdiwgbnJfc2VncywgY291bnQsIDApOworCQlpb3ZfaXRlcl9pbml0KCZpdGVyLCBpb3YsIG5y
X3NlZ3MsIGNvdW50LCAwKTsKIAotCXNkLmxlbiA9IDA7Ci0Jc2QudG90YWxfbGVuID0gY291bnQ7
Ci0Jc2QuZmxhZ3MgPSBmbGFnczsKLQlzZC51LmRhdGEgPSAmaXRlcjsKLQlzZC5wb3MgPSAwOwor
CQlzZC5sZW4gPSAwOworCQlzZC50b3RhbF9sZW4gPSBjb3VudDsKKwkJc2QuZmxhZ3MgPSBmbGFn
czsKKwkJc2QudS5kYXRhID0gJml0ZXI7CisJCXNkLnBvcyA9IDA7CiAKLQlwaXBlX2xvY2socGlw
ZSk7Ci0JcmV0ID0gX19zcGxpY2VfZnJvbV9waXBlKHBpcGUsICZzZCwgcGlwZV90b191c2VyKTsK
LQlwaXBlX3VubG9jayhwaXBlKTsKKwkJcGlwZV9sb2NrKHBpcGUpOworCQlyZXQgPSBfX3NwbGlj
ZV9mcm9tX3BpcGUocGlwZSwgJnNkLCBwaXBlX3RvX3VzZXIpOworCQlwaXBlX3VubG9jayhwaXBl
KTsKKwl9CiAKIAlpZiAoaW92ICE9IGlvdnN0YWNrKQogCQlrZnJlZShpb3YpOwo=
--089e013a13b0252b4004fa64b25a--
