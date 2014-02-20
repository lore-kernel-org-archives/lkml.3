Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbaBTTGk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 14:06:40 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:37100 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799AbaBTTGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 14:06:38 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFx9ZZeSEmZL2H69Mou=JcYr77Tb8SdDhMvV+GUVvEmd5Q@mail.gmail.com>
References: <CA+55aFwTrt_6m1inNHQkk74i7uPkHNnacwHiBgioZSXieAs5Sw@mail.gmail.com>
	<1392666947.18779.6838.camel@triegel.csb>
	<CA+55aFwUnRVk6q3VZeYjWfduoHcExW=Pht6jgp=4bBSaLHNPMA@mail.gmail.com>
	<20140218030002.GA15857@linux.vnet.ibm.com>
	<CA+55aFyqLrj4d2TA+2aazRqXnbVsUvs0yaBL2D5rXF1G=Kiu_g@mail.gmail.com>
	<CA+55aFwsq5E8kMoEeHJJ1f2=+QAUCu_HndfPxHNz8fUBprS-jQ@mail.gmail.com>
	<1392740258.18779.7732.camel@triegel.csb>
	<CA+55aFw7QYEMFs0BCxqRJW3Cz=tLbaku-tmN6hLXPKP9jbom7Q@mail.gmail.com>
	<1392752867.18779.8120.camel@triegel.csb>
	<CA+55aFxQPxQ8WOaZL8yAqBA=Y4k2gDn4r4oepMyi0uL6XLzv3w@mail.gmail.com>
	<20140220040102.GM4250@linux.vnet.ibm.com>
	<CA+55aFwwscSzwTr+xRdirtTx7HzugmMY9HrDe0GBqNhn=AuNVA@mail.gmail.com>
	<1392918576.18779.10198.camel@triegel.csb>
	<CA+55aFwV3pH+CP7Anv_YXzChL5V3_zre0+Ry-a1tJGYsbn-3iQ@mail.gmail.com>
	<CA+55aFx9ZZeSEmZL2H69Mou=JcYr77Tb8SdDhMvV+GUVvEmd5Q@mail.gmail.com>
Date: Thu, 20 Feb 2014 11:06:37 -0800
X-Google-Sender-Auth: BYhcffNjknWYv_K1pd3SonK0-mw
Message-ID: <CA+55aFw-1oeOvH2eJgoJc5eU-0RRVER+gqqAkCYmJ+4MNpz53w@mail.gmail.com>
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

On Thu, Feb 20, 2014 at 11:02 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Again, the way I'd expect a compiler writer to actually *do* this is
> to just default to "ac

Oops, pressed send by mistake too early.

I was almost done:

I'd expect a compiler to just default to "acquire" semantics, but then
have a few "obvious peephole" optimizations for cases that it
encounters and where it is easy to replace the synchronization point
with just an address dependency.

             Linus
