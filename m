Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082AbaBTTJ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 14:09:27 -0500
Received: from mail-ve0-f174.google.com ([209.85.128.174]:38116 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933AbaBTTJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 14:09:25 -0500
MIME-Version: 1.0
In-Reply-To: <1392922421.28840.36.camel@triegel.csb>
References: <CA+55aFyqLrj4d2TA+2aazRqXnbVsUvs0yaBL2D5rXF1G=Kiu_g@mail.gmail.com>
	<CA+55aFwsq5E8kMoEeHJJ1f2=+QAUCu_HndfPxHNz8fUBprS-jQ@mail.gmail.com>
	<1392740258.18779.7732.camel@triegel.csb>
	<CA+55aFw7QYEMFs0BCxqRJW3Cz=tLbaku-tmN6hLXPKP9jbom7Q@mail.gmail.com>
	<1392752867.18779.8120.camel@triegel.csb>
	<CA+55aFxQPxQ8WOaZL8yAqBA=Y4k2gDn4r4oepMyi0uL6XLzv3w@mail.gmail.com>
	<20140220040102.GM4250@linux.vnet.ibm.com>
	<CA+55aFwwscSzwTr+xRdirtTx7HzugmMY9HrDe0GBqNhn=AuNVA@mail.gmail.com>
	<20140220083032.GN4250@linux.vnet.ibm.com>
	<CA+55aFwfx==u7o1NZ66aPbkOgsvGqW3UscGqrQkGuzOkjSpm6Q@mail.gmail.com>
	<20140220181116.GT4250@linux.vnet.ibm.com>
	<CA+55aFwn9gXWVq_GL=tPPP63vsqs-9QB4ii4s06xqG4UscCV5w@mail.gmail.com>
	<1392922421.28840.36.camel@triegel.csb>
Date: Thu, 20 Feb 2014 11:09:24 -0800
X-Google-Sender-Auth: FNt0BszzdWa3n8O7WLLnulEOVM4
Message-ID: <CA+55aFwos2Gwd2LEvht4ymVxHb6GRVjtZ9wwJSaj1p--FqNUWw@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Torvald Riegel <triegel@redhat.com>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>,
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

On Thu, Feb 20, 2014 at 10:53 AM, Torvald Riegel <triegel@redhat.com> wrote:
> On Thu, 2014-02-20 at 10:32 -0800, Linus Torvalds wrote:
>> On Thu, Feb 20, 2014 at 10:11 AM, Paul E. McKenney
>> <paulmck@linux.vnet.ibm.com> wrote:
>> >
>> > You really need that "consume" to be "acquire".
>>
>> So I think we now all agree that that is what the standard is saying.
>
> Huh?
>
> The standard says that there are two separate things (among many more):
> mo_acquire and mo_consume.  They both influence happens-before in
> different (and independent!) ways.
>
> What Paul is saying is that *you* should have used *acquire* in that
> example.

I understand.

And I disagree. I think the standard is wrong, and what I *should* be
doing is point out the fact very loudly, and just tell people to NEVER
EVER use "consume" as long as it's not reliable and has insane
semantics.

So what I "should do" is to not accept any C11 atomics use in the
kernel. Because with the "acquire", it generates worse code than what
we already have, and with the "consume" it's shit.

See?

                  Linus
