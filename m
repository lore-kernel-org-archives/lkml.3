Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263Ab3G3R5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 13:57:41 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:58947 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab3G3R5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 13:57:40 -0400
Date: Tue, 30 Jul 2013 10:57:18 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, kosaki.motohiro@gmail.com, walken@google.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: mlockall triggred rcu_preempt stall.
Message-ID: <20130730175718.GA8957@linux.vnet.ibm.com>
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
x-cbid: 13073017-7408-0000-0000-00001278C75B
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

Any news?  If I don't hear otherwise, I will assume that the patch did
not help, and will therefore drop it.

							Thanx, Paul

