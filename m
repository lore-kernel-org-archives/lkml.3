Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751262AbaLQTvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 14:51:47 -0500
Received: from mail-qg0-f51.google.com ([209.85.192.51]:57370 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbaLQTvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 14:51:46 -0500
MIME-Version: 1.0
In-Reply-To: <20141217185755.GA22839@redhat.com>
References: <20141211145408.GB16800@redhat.com>
	<CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>
	<20141212185454.GB4716@redhat.com>
	<CA+55aFw7vJkuJ9RtVS3yhPsqDos+ii1kdJBZEeoxhb9c2=rStQ@mail.gmail.com>
	<20141213165915.GA12756@redhat.com>
	<20141213223616.GA22559@redhat.com>
	<CA+55aFwCa1+cBGxt-v487K-QBvxGyB9bL4u34zgMep9uFW+Mgw@mail.gmail.com>
	<20141214234654.GA396@redhat.com>
	<CA+55aFyUtZobUADgtss7e4w-yriMtz7hKVKs=Ed72KQoQ9n2nA@mail.gmail.com>
	<20141217182241.GA4821@redhat.com>
	<20141217185755.GA22839@redhat.com>
Date: Wed, 17 Dec 2014 11:51:45 -0800
X-Google-Sender-Auth: pOJ2iTpBiPngu4nMqO0lY7FDczI
Message-ID: <CA+55aFyiFDeBmMB9NNjEwB4n8rtxjH3bWt+6gQ7skiZtDX3m=Q@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Anvin <hpa@linux.intel.com>
Content-Type: multipart/mixed; boundary=001a11c13d362e9c71050a6eceb8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11c13d362e9c71050a6eceb8
Content-Type: text/plain; charset=UTF-8

On Wed, Dec 17, 2014 at 10:57 AM, Dave Jones <davej@redhat.com> wrote:
> On Wed, Dec 17, 2014 at 01:22:41PM -0500, Dave Jones wrote:
>
>  > I'm going to try your two patches on top of .18, with the same kernel
>  > config, and see where that takes us.
>  > Hopefully to happier places.
>
> Not so much.  Died very quickly.

Damn, damn, damn. That's because of a stupid typo on the patches. We
have these very similar variables ("flags" and "fault") that have very
similar fault information, but they are completely different.

The "fault & FAULT_FLAG_USER" test is wrong, it should test "flags &
FAULT_FLAG_USER". Patch attached.

The half-way good news is that this certainly confirms that trinity is
triggering the "page fault with fatal signal pending" special case.

                             Linus

--001a11c13d362e9c71050a6eceb8
Content-Type: text/plain; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i3t47tbe0

IGFyY2gveDg2L21tL2ZhdWx0LmMgfCAyICstCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24o
KyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9tbS9mYXVsdC5jIGIvYXJj
aC94ODYvbW0vZmF1bHQuYwppbmRleCBiNzRhN2UxMzBiMDMuLjM4ZGNlYzQwM2I0NiAxMDA2NDQK
LS0tIGEvYXJjaC94ODYvbW0vZmF1bHQuYworKysgYi9hcmNoL3g4Ni9tbS9mYXVsdC5jCkBAIC0x
MjQ3LDcgKzEyNDcsNyBAQCBnb29kX2FyZWE6CiAJCX0KIAogCQkvKiBVc2VyIG1vZGU/IEp1c3Qg
cmV0dXJuIHRvIGhhbmRsZSB0aGUgZmF0YWwgZXhjZXB0aW9uICovCi0JCWlmIChmYXVsdCAmIEZB
VUxUX0ZMQUdfVVNFUikKKwkJaWYgKGZsYWdzICYgRkFVTFRfRkxBR19VU0VSKQogCQkJcmV0dXJu
OwogCiAJCS8qIE5vdCByZXR1cm5pbmcgdG8gdXNlciBtb2RlPyBIYW5kbGUgZXhjZXB0aW9ucyBv
ciBkaWU6ICovCg==
--001a11c13d362e9c71050a6eceb8--
