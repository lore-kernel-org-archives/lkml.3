Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476AbaBTSpN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 13:45:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754244AbaBTSpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 13:45:08 -0500
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Torvald Riegel <triegel@redhat.com>
To: paulmck@linux.vnet.ibm.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
In-Reply-To: <20140220181116.GT4250@linux.vnet.ibm.com>
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
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Feb 2014 19:44:32 +0100
Message-ID: <1392921872.18779.10287.camel@triegel.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-20 at 10:11 -0800, Paul E. McKenney wrote:
> But yes, the compiler guys would be extremely happy to simply drop
> memory_order_consume from the standard, as it is the memory order
> that they most love to hate.
> 
> Getting them to agree to any sort of peep-hole optimization semantics
> for memory_order_consume is likely problematic.  

I wouldn't be so pessimistic about that.  If the transformations can be
shown to be always correct in terms of the semantics specified in the
standard, and if the performance win is sufficiently large, why not?  Of
course, somebody has to volunteer to actually implement it :)

