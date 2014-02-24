Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbaBXBff (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 20:35:35 -0500
Received: from mail-ve0-f170.google.com ([209.85.128.170]:36218 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbaBXBf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 20:35:29 -0500
MIME-Version: 1.0
In-Reply-To: <20140224011651.GC8264@linux.vnet.ibm.com>
References: <20140220181116.GT4250@linux.vnet.ibm.com>
	<CA+55aFwn9gXWVq_GL=tPPP63vsqs-9QB4ii4s06xqG4UscCV5w@mail.gmail.com>
	<1392922421.28840.36.camel@triegel.csb>
	<CA+55aFwos2Gwd2LEvht4ymVxHb6GRVjtZ9wwJSaj1p--FqNUWw@mail.gmail.com>
	<1393095223.28840.4914.camel@triegel.csb>
	<CA+55aFz9=RQoMO2ipyZgNPNzWGVXi_R9Ar5=o9VBWwXzDDz6jg@mail.gmail.com>
	<20140223003933.GQ4250@linux.vnet.ibm.com>
	<CA+55aFyjzR_Ga_HOKnBXpKYbuesqovj1-sFTVisD9UwA6JuJtw@mail.gmail.com>
	<20140223063426.GT4250@linux.vnet.ibm.com>
	<CA+55aFxMJvaQhoEwqgN=XA6gDOdZwoZQHdcAnB-FhAri_hK-6Q@mail.gmail.com>
	<20140224011651.GC8264@linux.vnet.ibm.com>
Date: Sun, 23 Feb 2014 17:35:28 -0800
X-Google-Sender-Auth: yhkRb2Oev_0B1RGJWd3AjXd6dYU
Message-ID: <CA+55aFx06UTTeypXOGUiwwbzJyqpVNR90zBDLPmxFzBkz=VwgQ@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Torvald Riegel <triegel@redhat.com>, Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 23, 2014 at 5:16 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>>
>>  (a) we've said 'q' is restricted, so there is no aliasing between q
>> and the pointers b/c. So the compiler is free to move those accesses
>> around the "q = p->next" access.
>
> Ah, if I understand you, very good!
>
> My example intentionally left "q" -not- restricted.

No, I 100% agree with that. "q" is *not* restricted. But "p" is, since
it came from that consuming load.

But "q = p->next" is ordered by how something can alias "p->next", not by 'q'!

There is no need to restrict anything but 'p' for all of this to work.

Btw, it's also worth pointing out that I do *not* in any way expect
people to actually write the "restrict" keyword anywhere. So no need
to change source code.

What you have is a situation where the pointer coming out of the
memory_order_consume is restricted. But if you assign it to a
non-restricted pointer, that's *fine*. That's perfectly normal C
behavior. The "restrict" concept is not something that the programmer
needs to worry about or ever even notice, it's basically just a
promise to the compiler that "if somebody has another pointer lying
around, accesses though that other pointer do not require ordering".

So it sounds like you believe that the programmer would mark things
"restrict", and I did not mean that at all.

             Linus
