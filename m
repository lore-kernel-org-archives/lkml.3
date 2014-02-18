Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751222AbaBRFCA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 00:02:00 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:40766 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbaBRFB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 00:01:58 -0500
Date: Mon, 17 Feb 2014 21:01:52 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Torvald Riegel <triegel@redhat.com>, Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
Message-ID: <20140218050152.GF4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1392352981.18779.3800.camel@triegel.csb>
 <20140214172920.GQ4250@linux.vnet.ibm.com>
 <CA+55aFx9CbgrfK4rBVYD75y2KoWiO90dSYsAW83O-tYVLK-gkg@mail.gmail.com>
 <CA+55aFypfiTFwundih8QEA6ZwVGk=g5L4sabsN0932eih5knOQ@mail.gmail.com>
 <1392486310.18779.6447.camel@triegel.csb>
 <CA+55aFwTrt_6m1inNHQkk74i7uPkHNnacwHiBgioZSXieAs5Sw@mail.gmail.com>
 <1392666947.18779.6838.camel@triegel.csb>
 <CA+55aFwUnRVk6q3VZeYjWfduoHcExW=Pht6jgp=4bBSaLHNPMA@mail.gmail.com>
 <20140218030002.GA15857@linux.vnet.ibm.com>
 <CA+55aFyqLrj4d2TA+2aazRqXnbVsUvs0yaBL2D5rXF1G=Kiu_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyqLrj4d2TA+2aazRqXnbVsUvs0yaBL2D5rXF1G=Kiu_g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021805-0928-0000-0000-000006C5549D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 07:24:56PM -0800, Linus Torvalds wrote:
> On Mon, Feb 17, 2014 at 7:00 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> >
> > One example that I learned about last week uses the branch-prediction
> > hardware to validate value speculation.  And no, I am not at all a fan
> > of value speculation, in case you were curious.
> 
> Heh. See the example I used in my reply to Alec Teal. It basically
> broke the same dependency the same way.

;-)

> Yes, value speculation of reads is simply wrong, the same way
> speculative writes are simply wrong. The dependency chain matters, and
> is meaningful, and breaking it is actively bad.
> 
> As far as I can tell, the intent is that you can't do value
> speculation (except perhaps for the "relaxed", which quite frankly
> sounds largely useless). But then I do get very very nervous when
> people talk about "proving" certain values.

That was certainly my intent, but as you might have notice in the
discussion earlier in this thread, the intent can get lost pretty
quickly.  ;-)

The HPC guys appear to be the most interested in breaking dependencies.
Their software does't rely on dependencies, and from their viewpoint
anything that has any chance of leaving an FP unit of any type idle is
a very bad thing.  But there are probably other benchmarks for which
breaking dependencies gives a few percent performance boost.

							Thanx, Paul

