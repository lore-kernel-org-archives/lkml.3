Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbaBRTsa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 14:48:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199AbaBRTs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 14:48:28 -0500
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Torvald Riegel <triegel@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
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
In-Reply-To: <CA+55aFw7QYEMFs0BCxqRJW3Cz=tLbaku-tmN6hLXPKP9jbom7Q@mail.gmail.com>
References: <1392321837.18779.3249.camel@triegel.csb>
	 <20140214020144.GO4250@linux.vnet.ibm.com>
	 <1392352981.18779.3800.camel@triegel.csb>
	 <20140214172920.GQ4250@linux.vnet.ibm.com>
	 <CA+55aFx9CbgrfK4rBVYD75y2KoWiO90dSYsAW83O-tYVLK-gkg@mail.gmail.com>
	 <CA+55aFypfiTFwundih8QEA6ZwVGk=g5L4sabsN0932eih5knOQ@mail.gmail.com>
	 <1392486310.18779.6447.camel@triegel.csb>
	 <CA+55aFwTrt_6m1inNHQkk74i7uPkHNnacwHiBgioZSXieAs5Sw@mail.gmail.com>
	 <1392666947.18779.6838.camel@triegel.csb>
	 <CA+55aFwUnRVk6q3VZeYjWfduoHcExW=Pht6jgp=4bBSaLHNPMA@mail.gmail.com>
	 <20140218030002.GA15857@linux.vnet.ibm.com>
	 <CA+55aFyqLrj4d2TA+2aazRqXnbVsUvs0yaBL2D5rXF1G=Kiu_g@mail.gmail.com>
	 <CA+55aFwsq5E8kMoEeHJJ1f2=+QAUCu_HndfPxHNz8fUBprS-jQ@mail.gmail.com>
	 <1392740258.18779.7732.camel@triegel.csb>
	 <CA+55aFw7QYEMFs0BCxqRJW3Cz=tLbaku-tmN6hLXPKP9jbom7Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Feb 2014 20:47:47 +0100
Message-ID: <1392752867.18779.8120.camel@triegel.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-18 at 09:44 -0800, Linus Torvalds wrote:
> On Tue, Feb 18, 2014 at 8:17 AM, Torvald Riegel <triegel@redhat.com> wrote:
> > The standard is clear on what's required.  I strongly suggest reading
> > the formalization of the memory model by Batty et al.
> 
> Can you point to it? Because I can find a draft standard, and it sure
> as hell does *not* contain any clarity of the model. It has a *lot* of
> verbiage, but it's pretty much impossible to actually understand, even
> for somebody who really understands memory ordering.

http://www.cl.cam.ac.uk/~mjb220/n3132.pdf
This has an explanation of the model up front, and then the detailed
formulae in Section 6.  This is from 2010, and there might have been
smaller changes since then, but I'm not aware of any bigger ones.

The cppmem tool is based on this, so if you want to play around with a
few code examples, it's pretty nice because it shows you all allowed
executions, including graphs like in the paper (see elsewhere in this
thread for CAS syntax):
http://svr-pes20-cppmem.cl.cam.ac.uk/cppmem/

