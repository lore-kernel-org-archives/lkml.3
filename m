Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071Ab3GTAca (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 20:32:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733Ab3GTAc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 20:32:29 -0400
Date: Fri, 19 Jul 2013 20:32:12 -0400
From: Dave Jones <davej@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        kosaki.motohiro@gmail.com, walken@google.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: mlockall triggred rcu_preempt stall.
Message-ID: <20130720003212.GA31308@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
	kosaki.motohiro@gmail.com, walken@google.com,
	akpm@linux-foundation.org, torvalds@linux-foundation.org
References: <20130719145323.GA1903@redhat.com>
 <20130719221538.GH21367@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130719221538.GH21367@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 03:15:39PM -0700, Paul E. McKenney wrote:
 > On Fri, Jul 19, 2013 at 10:53:23AM -0400, Dave Jones wrote:
 > > My fuzz tester keeps hitting this. Every instance shows the non-irq stack
 > > came in from mlockall.  I'm only seeing this on one box, but that has more
 > > ram (8gb) than my other machines, which might explain it.
 > 
 > Are you building CONFIG_PREEMPT=n?  I don't see any preemption points in
 > do_mlockall(), so a range containing enough vmas might well stall the
 > CPU in that case.  

That was with full preempt.

 > Does the patch below help?  If so, we probably need others, but let's
 > first see if this one helps.  ;-)

I'll try it on Monday.

	Dave

