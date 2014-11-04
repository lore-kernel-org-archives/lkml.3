Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375AbaKDOwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 09:52:55 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:42614 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751841AbaKDOww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 09:52:52 -0500
Date: Tue, 4 Nov 2014 09:52:50 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Joe Perches <joe@perches.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [RFA][PATCH 2/8] netfilter: Remove return values for
 print_conntrack callbacks
Message-ID: <20141104095250.3a6e1cbd@gandalf.local.home>
In-Reply-To: <1415112379.24560.6.camel@perches.com>
References: <20141029215602.535533597@goodmis.org>
	<20141029220107.465008329@goodmis.org>
	<20141104080535.5f651713@gandalf.local.home>
	<20141104142236.GA10239@salvia>
	<20141104093150.7410f6d0@gandalf.local.home>
	<1415112379.24560.6.camel@perches.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Nov 2014 06:46:19 -0800
Joe Perches <joe@perches.com> wrote:

> On Tue, 2014-11-04 at 09:31 -0500, Steven Rostedt wrote:
> > On Tue, 4 Nov 2014 15:22:36 +0100
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > On Tue, Nov 04, 2014 at 08:05:35AM -0500, Steven Rostedt wrote:
> > > > On Wed, 29 Oct 2014 17:56:04 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:
> > > > > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> > > > > [ REQUEST FOR ACKS ]
> > > > Can any of the netfilter folks give me an Acked-by for this?
> > > If Florian's concern were addressed, then:
> > Yeah, the change he mentioned was done is 3/8. As that was written by
> > Joe Perches, I did some work that he missed and put it before his
> > patch, which showed a discrepancy between the two functions. After all
> > patches are applied, it should be consistent to his liking.
> 
> I think seq_has_overflowed does not need
> to be used after every seq_<put/print> call.
> 
> It interrupts reading code flow and just
> isn't alll that necessary as every operation
> before it will be redone anyway.
> 
> It should be used before or after a large
> blocks though.
> 

It's not used in every occurrence. The problem that Florian had was that
there were two almost identical functions, and you changed one to have
the seq_has_overflowed() check, but the other one was left without it.

It wasn't about checking multiple times, it was about consistency
between two similar functions.

-- Steve
