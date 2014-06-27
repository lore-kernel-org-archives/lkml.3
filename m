Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbaF0X6e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 19:58:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47002 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbaF0X6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 19:58:33 -0400
Date: Fri, 27 Jun 2014 16:59:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, hpa@linux.intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Stephen Warren <swarren@wwwdotorg.org>,
        Michal Hocko <mhocko@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        Joe Perches <joe@perches.com>, Arun KS <arunks.linux@gmail.com>,
        Kees Cook <keescook@chromium.org>, Davidlohr Bueso <davidlohr@hp.com>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH v8 4/4] printk: allow increasing the ring buffer
 depending on the number of CPUs
Message-Id: <20140627165914.c41788af.akpm@linux-foundation.org>
In-Reply-To: <CAB=NE6W3HpEeKCPt+PRbUxavZY-MAv6E3J=zk9+uJwzUG=EoRg@mail.gmail.com>
References: <1403124337-14886-1-git-send-email-mcgrof@do-not-panic.com>
	<1403124337-14886-4-git-send-email-mcgrof@do-not-panic.com>
	<20140623154134.43ac7ab63896cd9ebcba84b6@linux-foundation.org>
	<20140624002050.GC27687@wotan.suse.de>
	<20140623174533.88663e64.akpm@linux-foundation.org>
	<20140624010554.GF27687@wotan.suse.de>
	<20140626144117.3412feee6234786be098259d@linux-foundation.org>
	<20140626231630.GI27687@wotan.suse.de>
	<20140626162014.156f6741c7d9d3234879054f@linux-foundation.org>
	<CAB=NE6W3HpEeKCPt+PRbUxavZY-MAv6E3J=zk9+uJwzUG=EoRg@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2014 16:32:15 -0700 "Luis R. Rodriguez" <mcgrof@suse.com> wrote:

> On Thu, Jun 26, 2014 at 4:20 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Fri, 27 Jun 2014 01:16:30 +0200 "Luis R. Rodriguez" <mcgrof@suse.com> wrote:
> >
> >> > > Another note --  since this option depends on SMP and !BASE_SMALL technically
> >> > > num_possible_cpus() won't ever return something smaller than or equal to 1
> >> > > but because of the default values chosen the -1 on the compuation does affect
> >> > > whether or not this will trigger on > 64 CPUs or >= 64 CPUs, keeping the
> >> > > -1 means we require > 64 CPUs.
> >> >
> >> > hm, that sounds like more complexity.
> >> >
> >> > > This all can be changed however we like but the language and explained logic
> >> > > would just need to be changed.
> >> >
> >> > Let's start out simple.  What's wrong with doing
> >> >
> >> >     log buf len = max(__LOG_BUF_LEN, nr_possible_cpus * per-cpu log buf len)
> >>
> >> Sure, you already took in the patch series though so how would you like to
> >> handle a respin, you just drop the last patch and we respin it?
> >
> > A fresh patch would suit.  That's if you think it is a reasonable
> > approach - you've thought about this stuff more than I have!
> 
> The way its implemented now makes more technical sense, in short it
> assumes the first boot (and CPU) gets the full default kernel ring
> buffer size, the extra size is for the gibberish that each extra CPU
> is expected to spew out in the worst case. What you propose makes the
> explanation simpler and easier to understand but sends the wrong
> message about exactly how the growth of the kernel ring buffer is
> expected scale with the addition of more CPUs.

OK, it's finally starting to sink in.  The model for the kernel-wide
printk output is "a great pile of CPU-independent stuff plus a certain
amount of per-cpu stuff".  And the code at present attempts to follow
that model.  Yes?

I'm rather internet-challenged at present - please let me take another look at
the patch on Monday.

