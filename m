Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbaFENtx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 09:49:53 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:54471 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbaFENtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 09:49:51 -0400
MIME-Version: 1.0
In-Reply-To: <20140605133331.GB6020@hercules>
References: <20140605041639.638675216@linuxfoundation.org>
	<20140605041642.768058331@linuxfoundation.org>
	<20140605133331.GB6020@hercules>
Date: Thu, 5 Jun 2014 15:49:48 +0200
Message-ID: <CA+rthh_xdM-i7QiJ7QLayz+n42msL9nORV5mQh4qtJX66uXWWA@mail.gmail.com>
Subject: Re: [PATCH 3.4 022/214] filter: prevent nla extensions to peek beyond
 the end of the message
From: Mathias Krause <minipli@googlemail.com>
To: Luis Henriques <luis.henriques@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben@decadent.org.uk>
Content-Type: multipart/mixed; boundary=047d7bfd05a2bb38a304fb17048a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7bfd05a2bb38a304fb17048a
Content-Type: text/plain; charset=UTF-8

On 5 June 2014 15:33, Luis Henriques <luis.henriques@canonical.com> wrote:
> On Wed, Jun 04, 2014 at 09:16:25PM -0700, Greg Kroah-Hartman wrote:
>> 3.4-stable review patch.  If anyone has any objections, please let me know.
>> [...]
>> --- a/net/core/filter.c
>> +++ b/net/core/filter.c
>> @@ -338,11 +338,15 @@ load_b:
>>
>>                       if (skb_is_nonlinear(skb))
>>                               return 0;
>> +                     if (skb->len < sizeof(struct nlattr))
>> +                             return 0;
>> +                     if (skb->len < sizeof(struct nlattr))
>> +                             return 0;
>
> There above code is duplicated this backport.  The same comment
> applies to the 3.2.y backport (I've added Ben to the CC list).
>

Good catch! The diff should look more like the the one in the
attachment. I guess patch(1) just failed here to find the right place
to apply the hunk to.

Thanks,
Mathias

--047d7bfd05a2bb38a304fb17048a
Content-Type: text/x-patch; charset=US-ASCII; 
	name="filter-prevent-nla-extensions-to-peek-beyond-the-end-of-the-message-v3.4.patch"
Content-Disposition: attachment; 
	filename="filter-prevent-nla-extensions-to-peek-beyond-the-end-of-the-message-v3.4.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hw24d0lx0

ZGlmZiAtLWdpdCBhL25ldC9jb3JlL2ZpbHRlci5jIGIvbmV0L2NvcmUvZmlsdGVyLmMKaW5kZXgg
NmY3NTVjYy4uM2I3Mzk4YSAxMDA2NDQKLS0tIGEvbmV0L2NvcmUvZmlsdGVyLmMKKysrIGIvbmV0
L2NvcmUvZmlsdGVyLmMKQEAgLTMyMiw2ICszMjIsOCBAQCBsb2FkX2I6CiAKIAkJCWlmIChza2Jf
aXNfbm9ubGluZWFyKHNrYikpCiAJCQkJcmV0dXJuIDA7CisJCQlpZiAoc2tiLT5sZW4gPCBzaXpl
b2Yoc3RydWN0IG5sYXR0cikpCisJCQkJcmV0dXJuIDA7CiAJCQlpZiAoQSA+IHNrYi0+bGVuIC0g
c2l6ZW9mKHN0cnVjdCBubGF0dHIpKQogCQkJCXJldHVybiAwOwogCkBAIC0zMzgsMTEgKzM0MCwx
MyBAQCBsb2FkX2I6CiAKIAkJCWlmIChza2JfaXNfbm9ubGluZWFyKHNrYikpCiAJCQkJcmV0dXJu
IDA7CisJCQlpZiAoc2tiLT5sZW4gPCBzaXplb2Yoc3RydWN0IG5sYXR0cikpCisJCQkJcmV0dXJu
IDA7CiAJCQlpZiAoQSA+IHNrYi0+bGVuIC0gc2l6ZW9mKHN0cnVjdCBubGF0dHIpKQogCQkJCXJl
dHVybiAwOwogCiAJCQlubGEgPSAoc3RydWN0IG5sYXR0ciAqKSZza2ItPmRhdGFbQV07Ci0JCQlp
ZiAobmxhLT5ubGFfbGVuID4gQSAtIHNrYi0+bGVuKQorCQkJaWYgKG5sYS0+bmxhX2xlbiA+IHNr
Yi0+bGVuIC0gQSkKIAkJCQlyZXR1cm4gMDsKIAogCQkJbmxhID0gbmxhX2ZpbmRfbmVzdGVkKG5s
YSwgWCk7Cg==
--047d7bfd05a2bb38a304fb17048a--
