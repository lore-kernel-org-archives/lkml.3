Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab3HaRu4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 13:50:56 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:52242 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501Ab3HaRuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 13:50:54 -0400
MIME-Version: 1.0
In-Reply-To: <CAMJEocr1SgxQw0bEzB3Ti9bvRY74TE5y9e+PLUsAL1mJbK=-ew@mail.gmail.com>
References: <CA+icZUXuw7QBn4CPLLuiVUjHin0m6GRdbczGw=bZY+Z60sXNow@mail.gmail.com>
	<CA+icZUVbUD1tUa_ORtn_ZZebpp3gXXHGAcNe0NdYPXPMPoABuA@mail.gmail.com>
	<1372192414.1888.8.camel@buesod1.americas.hpqcorp.net>
	<CA+icZUXgOd=URJBH5MGAZKdvdkMpFt+5mRxtzuDzq_vFHpoc2A@mail.gmail.com>
	<1372202983.1888.22.camel@buesod1.americas.hpqcorp.net>
	<521DE5D7.4040305@synopsys.com>
	<CA+icZUUrZG8pYqKcHY3DcYAuuw=vbdUvs6ZXDq5meBMjj6suFg@mail.gmail.com>
	<C2D7FE5348E1B147BCA15975FBA23075140FA3@IN01WEMBXA.internal.synopsys.com>
	<CA+icZUUn-r8iq6TVMAKmgJpQm4FhOE4b4QN_Yy=1L=0Up=rkBA@mail.gmail.com>
	<52205597.3090609@synopsys.com>
	<CA+icZUW=YXMC_2Qt=cYYz6w_fVW8TS4=Pvbx7BGtzjGt+31rLQ@mail.gmail.com>
	<C2D7FE5348E1B147BCA15975FBA230751411CB@IN01WEMBXA.internal.synopsys.com>
	<CALE5RAvaa4bb-9xAnBe07Yp2n+Nn4uGEgqpLrKMuOE8hhZv00Q@mail.gmail.com>
	<CAMJEocr1SgxQw0bEzB3Ti9bvRY74TE5y9e+PLUsAL1mJbK=-ew@mail.gmail.com>
Date: Sat, 31 Aug 2013 10:50:53 -0700
X-Google-Sender-Auth: Lx2019XFm5-ELuiMuQAUt22bL-4
Message-ID: <CA+55aFy8tbBpac57fU4CN3jMDz46kCKT7+7GCpb18CscXuOnGA@mail.gmail.com>
Subject: Re: ipc-msg broken again on 3.11-rc7?
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davidlohr Bueso <dave.bueso@gmail.com>
Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, Andi Kleen <andi@firstfloor.org>,
        Rik van Riel <riel@redhat.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Jonathan Gonzalez <jgonzalez@linets.cl>
Content-Type: multipart/mixed; boundary=047d7b6dcb7c04161604e541fb9e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b6dcb7c04161604e541fb9e
Content-Type: text/plain; charset=UTF-8

Vineet, actual patch for what Davidlohr suggests attached. Can you try it?

             Linus

On Fri, Aug 30, 2013 at 9:31 AM, Davidlohr Bueso <dave.bueso@gmail.com> wrote:
>
> After a quick glance, I suspect that the problem might be because we
> are calling security_msg_queue_msgsnd() without taking the lock. This
> is similar to the issue Sedat reported in the original thread with
> find_msg() concerning msgrcv.

--047d7b6dcb7c04161604e541fb9e
Content-Type: application/octet-stream; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hl14m9cy0

IGlwYy9tc2cuYyB8IDggKysrKy0tLS0KIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyks
IDQgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvaXBjL21zZy5jIGIvaXBjL21zZy5jCmluZGV4
IDlmMjlkOWU4OWJhYy4uNTYwMGM4YjBkMTg0IDEwMDY0NAotLS0gYS9pcGMvbXNnLmMKKysrIGIv
aXBjL21zZy5jCkBAIC02ODcsMTAgKzY4Nyw2IEBAIGxvbmcgZG9fbXNnc25kKGludCBtc3FpZCwg
bG9uZyBtdHlwZSwgdm9pZCBfX3VzZXIgKm10ZXh0LAogCQlpZiAoaXBjcGVybXMobnMsICZtc3Et
PnFfcGVybSwgU19JV1VHTykpCiAJCQlnb3RvIG91dF91bmxvY2sxOwogCi0JCWVyciA9IHNlY3Vy
aXR5X21zZ19xdWV1ZV9tc2dzbmQobXNxLCBtc2csIG1zZ2ZsZyk7Ci0JCWlmIChlcnIpCi0JCQln
b3RvIG91dF91bmxvY2sxOwotCiAJCWlmIChtc2dzeiArIG1zcS0+cV9jYnl0ZXMgPD0gbXNxLT5x
X3FieXRlcyAmJgogCQkJCTEgKyBtc3EtPnFfcW51bSA8PSBtc3EtPnFfcWJ5dGVzKSB7CiAJCQli
cmVhazsKQEAgLTcwMyw2ICs2OTksMTAgQEAgbG9uZyBkb19tc2dzbmQoaW50IG1zcWlkLCBsb25n
IG10eXBlLCB2b2lkIF9fdXNlciAqbXRleHQsCiAJCX0KIAogCQlpcGNfbG9ja19vYmplY3QoJm1z
cS0+cV9wZXJtKTsKKwkJZXJyID0gc2VjdXJpdHlfbXNnX3F1ZXVlX21zZ3NuZChtc3EsIG1zZywg
bXNnZmxnKTsKKwkJaWYgKGVycikKKwkJCWdvdG8gb3V0X3VubG9jazA7CisKIAkJc3NfYWRkKG1z
cSwgJnMpOwogCiAJCWlmICghaXBjX3JjdV9nZXRyZWYobXNxKSkgewo=
--047d7b6dcb7c04161604e541fb9e--
