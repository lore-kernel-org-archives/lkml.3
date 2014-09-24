Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbaIXH6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 03:58:45 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:34772 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbaIXH6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 03:58:42 -0400
Date: Wed, 24 Sep 2014 09:58:37 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Rustad, Mark D" <mark.d.rustad@intel.com>,
        "sparse@chrisli.org" <sparse@chrisli.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "richard.weinberger@gmail.com" <richard.weinberger@gmail.com>,
        "linux-sparse@vger.kernel.org" <linux-sparse@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "computersforpeace@gmail.com" <computersforpeace@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] sched: Remove nested extern
Message-ID: <20140924075837.GB3919@gmail.com>
References: <CAFLxGvwfuE-458duC9ARMLLMBCvZaBQnwDjPW6uJC4FAViBXjQ@mail.gmail.com>
 <20140922175511.62229.98784.stgit@mdrustad-wks.jf.intel.com>
 <20140922190128.GA2805@worktop.programming.kicks-ass.net>
 <D428C53D-F663-4846-ACAB-74922033B048@intel.com>
 <20140922200527.GA3128@worktop.programming.kicks-ass.net>
 <D3423D3A-814F-4E22-A84B-61D76D137A98@intel.com>
 <20140922212105.GD3128@worktop.programming.kicks-ass.net>
 <9C9DCC69-1F75-4241-A022-FFB9B6A11AC5@intel.com>
 <20140924074144.GA3467@gmail.com>
 <20140924075248.GU16043@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924075248.GU16043@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, Sep 24, 2014 at 09:41:44AM +0200, Ingo Molnar wrote:
> > 
> > * Rustad, Mark D <mark.d.rustad@intel.com> wrote:
> > 
> > > On Sep 22, 2014, at 2:21 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > > 
> > > > On Mon, Sep 22, 2014 at 08:59:32PM +0000, Rustad, Mark D wrote:
> > > >> Because I have found that enabling many warnings helps identify problems
> > > >> in code and it has been my standard practice since about 1999 to do so.
> > > >> The compiler warnings are really just another form of static analysis,
> > > >> and I use it routinely on every compile. Here is how routinely: I have
> > > >> W=1 in my environment, W=12 is just too painful. I would change that
> > > >> default to W=12 if it wasn't insane to do so.
> > > > 
> > > > Many warnings are just plain insane and stupid. They're not 
> > > > helping anybody. There's a very good reason many are 
> > > > disabled. I'm sure you can find some entertaining discussions 
> > > > on the topic if you search the LKML archives.
> > > 
> > > That is what I used to think. -Wshadow for example. What's the 
> > > problem? [...]
> > 
> > Then please add it to the default build. There are some warnings 
> > that used to be crap but have been improved over the year - 
> > enable them one by one, with good case by case justification and 
> > analysis. Just going after all W=2 warnings is insane.

So by 'try to add it' I mean -Wshadow, which is a useful warning 
that I use in user-space projects as well: it does catch 
bogosities and isn't annoyingly inaccurate.

> So I don't like the nested extern one because it either means 
> not using that language feature at all or pooping all over your 
> code with that DECL crap. That just a loose-loose proposition.

Agreed.

Thanks,

	Ingo
