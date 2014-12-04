Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338AbaLDQSN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 11:18:13 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:45310 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbaLDQSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 11:18:11 -0500
MIME-Version: 1.0
In-Reply-To: <54801ea9.0ca5e00a.3c72.08ce@mx.google.com>
References: <20141201191431.GA17385@linux.vnet.ibm.com>
	<547ccf74.a5198c0a.25de.26d9@mx.google.com>
	<20141201230813.GE25340@linux.vnet.ibm.com>
	<547dec29.c71f8c0a.33d1.11d9@mx.google.com>
	<20141202170407.GK25340@linux.vnet.ibm.com>
	<547df364.236a8c0a.7b2d.ffffac67@mx.google.com>
	<20141202184202.GM25340@linux.vnet.ibm.com>
	<547e0947.c332e00a.23bf.ffffa8bd@mx.google.com>
	<20141202191143.GN25340@linux.vnet.ibm.com>
	<547e11fa.8778e00a.3439.ffffa88c@mx.google.com>
	<20141202205636.GQ25340@linux.vnet.ibm.com>
	<547e36d1.c54ae00a.2571.fffffd13@mx.google.com>
	<CA+55aFxdZjJprk8t9NxcZmewAAQ5Gf1XQWV=5i+Vfc5uTSfWFg@mail.gmail.com>
	<547e81ce.a1628c0a.4985.ffffb12a@mx.google.com>
	<CA+55aFxumSXif01LigHBgZeXFTWT-7knX=a8LJZeaZZDPoHCBg@mail.gmail.com>
	<CAEUsAPYthwHxopuiBcGg4_nnBDDsS2jrTw4pDFiov38awsFodA@mail.gmail.com>
	<CA+55aFyBgyRS0zeE+LuHAvc=54v0de2KX=hRnr3imXwFFbftXw@mail.gmail.com>
	<54801ea9.0ca5e00a.3c72.08ce@mx.google.com>
Date: Thu, 4 Dec 2014 08:18:10 -0800
X-Google-Sender-Auth: ev9hdSpTEG30aWABwjESrRfImgk
Message-ID: <CA+55aFzJ2uOxHC8y25oTzkURPcXo9r=5cvcCzSxgOSKnET5voQ@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Jones <davej@redhat.com>
Cc: Chris Rorvick <chris@rorvick.com>, Tejun Heo <tj@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=001a11c1ee246c332d0509664ed6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11c1ee246c332d0509664ed6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 4, 2014 at 12:43 AM, D=C3=A2niel Fraga <fragabr@gmail.com> wrot=
e:
>
>         Linus, today it's your lucky day, because I think I found the
> real bad commit (if it isn't, then it's some very close to it). I
> managed to narrow the bisect and here's the result:

Ok, that actually looks very reasonable, I had actually looked at it
because of the whole "changes IPI" thing.

One more thing to try: does a revert fix it on current git?

It doesn't revert entirely cleanly, but close enough - attached a
quick rough patch that may or may not work, but looks like a good
revert.

Dave - this might be worth testing for you too, exactly because of
that whole "it changes how we do IPI's". It was your bug report with
TLB IPI's that made me look at that commit originally.

                  Linus

---
> fd2ac4f4a65a7f34b0bc6433fcca1192d7ba8b8e is the first bad commit
> commit fd2ac4f4a65a7f34b0bc6433fcca1192d7ba8b8e
> Author: Frederic Weisbecker <fweisbec@gmail.com>
> Date:   Tue Mar 18 21:12:53 2014 +0100
>
>     nohz: Use nohz own full kick on 2nd task enqueue

--001a11c1ee246c332d0509664ed6
Content-Type: text/plain; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i3abryuw0

IGtlcm5lbC9zY2hlZC9jb3JlLmMgIHwgNSArKysrLQoga2VybmVsL3NjaGVkL3NjaGVkLmggfCAy
ICstCiAyIGZpbGVzIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRp
ZmYgLS1naXQgYS9rZXJuZWwvc2NoZWQvY29yZS5jIGIva2VybmVsL3NjaGVkL2NvcmUuYwppbmRl
eCA4OWU3MjgzMDE1YTYuLjFiNDBhZWQxMzkzMSAxMDA2NDQKLS0tIGEva2VybmVsL3NjaGVkL2Nv
cmUuYworKysgYi9rZXJuZWwvc2NoZWQvY29yZS5jCkBAIC0xNTc3LDcgKzE1NzcsOSBAQCB2b2lk
IHNjaGVkdWxlcl9pcGkodm9pZCkKIAkgKi8KIAlwcmVlbXB0X2ZvbGRfbmVlZF9yZXNjaGVkKCk7
CiAKLQlpZiAobGxpc3RfZW1wdHkoJnRoaXNfcnEoKS0+d2FrZV9saXN0KSAmJiAhZ290X25vaHpf
aWRsZV9raWNrKCkpCisJaWYgKGxsaXN0X2VtcHR5KCZ0aGlzX3JxKCktPndha2VfbGlzdCkKKwkJ
CSYmICF0aWNrX25vaHpfZnVsbF9jcHUoc21wX3Byb2Nlc3Nvcl9pZCgpKQorCQkJJiYgIWdvdF9u
b2h6X2lkbGVfa2ljaygpKQogCQlyZXR1cm47CiAKIAkvKgpAQCAtMTU5NCw2ICsxNTk2LDcgQEAg
dm9pZCBzY2hlZHVsZXJfaXBpKHZvaWQpCiAJICogc29tZXdoYXQgcGVzc2ltaXplIHRoZSBzaW1w
bGUgcmVzY2hlZCBjYXNlLgogCSAqLwogCWlycV9lbnRlcigpOworCXRpY2tfbm9oel9mdWxsX2No
ZWNrKCk7CiAJc2NoZWRfdHR3dV9wZW5kaW5nKCk7CiAKIAkvKgpkaWZmIC0tZ2l0IGEva2VybmVs
L3NjaGVkL3NjaGVkLmggYi9rZXJuZWwvc2NoZWQvc2NoZWQuaAppbmRleCAyZGY4ZWYwNjdjYzUu
LmU5YTczMTQzZDMxOCAxMDA2NDQKLS0tIGEva2VybmVsL3NjaGVkL3NjaGVkLmgKKysrIGIva2Vy
bmVsL3NjaGVkL3NjaGVkLmgKQEAgLTEyNDUsNyArMTI0NSw3IEBAIHN0YXRpYyBpbmxpbmUgdm9p
ZCBhZGRfbnJfcnVubmluZyhzdHJ1Y3QgcnEgKnJxLCB1bnNpZ25lZCBjb3VudCkKIAkJCSAqIG5l
dyB2YWx1ZSBvZiBycS0+bnJfcnVubmluZyBpcyB2aXNpYmxlIG9uIHJlY2VwdGlvbgogCQkJICog
ZnJvbSB0aGUgdGFyZ2V0LgogCQkJICovCi0JCQl0aWNrX25vaHpfZnVsbF9raWNrX2NwdShycS0+
Y3B1KTsKKwkJCXNtcF9zZW5kX3Jlc2NoZWR1bGUocnEtPmNwdSk7CiAJCX0KICNlbmRpZgogCX0K
--001a11c1ee246c332d0509664ed6--
