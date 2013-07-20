Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab3GTOAh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 10:00:37 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:44134 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967Ab3GTOAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 10:00:35 -0400
Date: Sat, 20 Jul 2013 07:00:15 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, kosaki.motohiro@gmail.com, walken@google.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: mlockall triggred rcu_preempt stall.
Message-ID: <20130720140015.GA5860@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130719145323.GA1903@redhat.com>
 <20130719221538.GH21367@linux.vnet.ibm.com>
 <20130720003212.GA31308@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130720003212.GA31308@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072014-5406-0000-0000-00000AA4D3D5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 08:32:12PM -0400, Dave Jones wrote:
> On Fri, Jul 19, 2013 at 03:15:39PM -0700, Paul E. McKenney wrote:
>  > On Fri, Jul 19, 2013 at 10:53:23AM -0400, Dave Jones wrote:
>  > > My fuzz tester keeps hitting this. Every instance shows the non-irq stack
>  > > came in from mlockall.  I'm only seeing this on one box, but that has more
>  > > ram (8gb) than my other machines, which might explain it.
>  > 
>  > Are you building CONFIG_PREEMPT=n?  I don't see any preemption points in
>  > do_mlockall(), so a range containing enough vmas might well stall the
>  > CPU in that case.  
> 
> That was with full preempt.
> 
>  > Does the patch below help?  If so, we probably need others, but let's
>  > first see if this one helps.  ;-)
> 
> I'll try it on Monday.

Given full preempt, I wouldn't think that my patch would have any effect,
but look forward to hearing what happens.

Hmmm....  Were you running mlockall() concurrently from a bunch of
different processes sharing lots of memory via mmap() or some such?

							Thanx, Paul

