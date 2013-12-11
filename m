Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692Ab3LKRsd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 12:48:33 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:57141 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab3LKRsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 12:48:30 -0500
Date: Wed, 11 Dec 2013 18:48:27 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <bitbucket@online.de>,
        Borislav Petkov <bp@alien8.de>, Len Brown <lenb@kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Eder <jeder@redhat.com>, x86@kernel.org
Subject: Re: 50 Watt idle power regression bisected to Linux-3.10
Message-ID: <20131211174827.GB12431@gmail.com>
References: <1386732093.5964.6.camel@marge.simpson.net>
 <alpine.DEB.2.02.1312111206200.28330@ionos.tec.linutronix.de>
 <20131211113839.GF21683@pd.tnic>
 <20131211115239.GA21999@twins.programming.kicks-ass.net>
 <1386764955.12005.60.camel@marge.simpson.net>
 <20131211124352.GB21999@twins.programming.kicks-ass.net>
 <20131211144238.GA4510@gmail.com>
 <alpine.DEB.2.02.1312111556390.28330@ionos.tec.linutronix.de>
 <20131211150911.GA11048@gmail.com>
 <20131211164442.GC2480@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131211164442.GC2480@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, Dec 11, 2013 at 04:09:11PM +0100, Ingo Molnar wrote:
> > 
> > * Thomas Gleixner <tglx@linutronix.de> wrote:
> > 
> > > On Wed, 11 Dec 2013, Ingo Molnar wrote:
> > > > 
> > > > Another thing that is required I think is to issue a write barrier 
> > > > before CLFLUSH instruction. By my (possibly incorrect ...) reading of 
> > > > the documentation CLFLUSH does not appear to be ordered (at all), so 
> > > > it might execute before the modification to the affected memory?
> > > 
> > > We already have a write barrier in the code which modifies
> > > current_thread_info()->flags.
> > 
> > Which code is that, could you please cite it? (I tried finding it but 
> > my grep-fu failed me.)
> 
> current_set_polling_and_test().

Thx, those variants have the right barrier indeed.

Thanks,

	Ingo
