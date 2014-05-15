Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969AbaEOXs4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 19:48:56 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:44240 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaEOXsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 19:48:55 -0400
Date: Thu, 15 May 2014 16:48:50 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: riel@redhat.com, linux-kernel@vger.kernel.org, rdunlap@infradead.org,
        richard@nod.at, umgwanakikbuti@gmail.com
Subject: Re: [PATCH 2/2] sysrq,rcu: suppress RCU stall warnings while sysrq
 runs
Message-ID: <20140515234850.GS4570@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1398794796-17464-1-git-send-email-riel@redhat.com>
 <1398794796-17464-3-git-send-email-riel@redhat.com>
 <20140515162412.51355f308c34768ad08c0e2f@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140515162412.51355f308c34768ad08c0e2f@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051523-1344-0000-0000-00000194BAE9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 04:24:12PM -0700, Andrew Morton wrote:
> On Tue, 29 Apr 2014 14:06:36 -0400 riel@redhat.com wrote:
> 
> > From: Rik van Riel <riel@redhat.com>
> > 
> > Some sysrq handlers can run for a long time, because they dump a lot
> > of data onto a serial console. Having RCU stall warnings pop up in
> > the middle of them only makes the problem worse.
> > 
> > This patch temporarily disables RCU stall warnings while a sysrq
> > request is handled.
> >
> > ...
> >
> >  drivers/tty/sysrq.c      |  3 +++
> >  include/linux/rcupdate.h | 12 ++++++++++++
> >  kernel/rcu/update.c      | 12 ++++++++++++
> 
> OK, what's going on here.  Someone (of, I suspect, a Paulish nature)
> has plucked out the rcu parts of this patch, put them in linux-next and
> omitted the drivers/tty part.  Very tricky!

Sounds like something I might do...  ;-)

I intend to push this for the upcoming merge window, in case it matters.

> I have done the opposite and have staged two patches against linux-next:
> 
> http://ozlabs.org/~akpm/mmots/broken-out/sysrq-rcu-ify-__handle_sysrq.patch

I defer to Rik for this one.

> http://ozlabs.org/~akpm/mmots/broken-out/sysrqrcu-suppress-rcu-stall-warnings-while-sysrq-runs.patch

The "[paulmck@linux.vnet.ibm.com: fix TINY_RCU build error]" should be
removed, since it goes with the patch I queued.  Not that it matters
that much, I suppose.

							Thanx, Paul

> Please check, review, comment, etc.
> 

