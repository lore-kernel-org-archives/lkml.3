Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbaIVUFk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 16:05:40 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54147 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128AbaIVUFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 16:05:38 -0400
Date: Mon, 22 Sep 2014 22:05:27 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Rustad, Mark D" <mark.d.rustad@intel.com>
Cc: "sparse@chrisli.org" <sparse@chrisli.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "richard.weinberger@gmail.com" <richard.weinberger@gmail.com>,
        "linux-sparse@vger.kernel.org" <linux-sparse@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "computersforpeace@gmail.com" <computersforpeace@gmail.com>
Subject: Re: [PATCH] sched: Remove nested extern
Message-ID: <20140922200527.GA3128@worktop.programming.kicks-ass.net>
References: <CAFLxGvwfuE-458duC9ARMLLMBCvZaBQnwDjPW6uJC4FAViBXjQ@mail.gmail.com>
 <20140922175511.62229.98784.stgit@mdrustad-wks.jf.intel.com>
 <20140922190128.GA2805@worktop.programming.kicks-ass.net>
 <D428C53D-F663-4846-ACAB-74922033B048@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D428C53D-F663-4846-ACAB-74922033B048@intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 07:32:04PM +0000, Rustad, Mark D wrote:
> On Sep 22, 2014, at 12:01 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Mon, Sep 22, 2014 at 10:55:11AM -0700, Mark D Rustad wrote:
> >> Avoid W=2 nested-externs warning by moving the nested extern to
> >> a normal extern. This eliminates that warning which is generated
> >> for every inclusion of sched.h in a kernel build when W=2 is used.
> >> This also removes a point of maintenance if the definition of
> >> delayacct_on were ever to change.
> > 
> > Yeah, so why is that warning worth using? Just disable the warn if
> > you're bothered by it.
> 
> I assume that nested-externs is included in W=2 because many uses of
> them, especially with function prototypes, creates a risk of inconsistent
> declarations. The kernel has a fair number of them that seem to have
> been added to disentangle include files. If they are judged to be
> worthwhile, then it would be good to silence the warnings so that
> attention can be given to other instances of the warnings. If those
> nested externs are not worth the risk, well that is a different conversation.

So would using something like LTO not be way better at actually finding
the problems, seeing how it can actually see the inconsistency in
declarations.

It seems to me that banning the use of nested extern is misguided as
they are a useful tool; they provide some means of keeping symbols from
being globally visible even though they actually are. Its a really poor
man's 'private', but its the best C provides.

Also, why do you care about W=2 nonsense anyhow? They're default
disabled for a reason.
