Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587Ab3LECoH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 21:44:07 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:45632 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab3LECoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 21:44:02 -0500
Date: Wed, 4 Dec 2013 18:43:55 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: lots of brief rcu stalls.
Message-ID: <20131205024355.GK15492@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131204232838.GA25592@redhat.com>
 <20131205001614.GI15492@linux.vnet.ibm.com>
 <1386209910.30495.146.camel@edumazet-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386209910.30495.146.camel@edumazet-glaptop2.roam.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120502-8236-0000-0000-0000048A6413
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 06:18:30PM -0800, Eric Dumazet wrote:
> On Wed, 2013-12-04 at 16:16 -0800, Paul E. McKenney wrote:
> > +	if (rdp->rsp == rcu_state &&
> > +	    ULONG_CMP_GE(ACCESS_ONCE(jiffies), rdp->rsp->jiffies_resched)) {
> > +		rdp->rsp->jiffies_resched += 5;
> > +		resched_cpu(rdp->cpu);
> > +	}
> > +
> >  	return 0;
> >  }
> 
> jiffies should not need ACCESS_ONCE(), right ?
> 
> It is one of the few variables marked with volatile keyword.

Good point!  I have queued a patch fixing this and four other occurrences
with your Submitted-by.

							Thanx, Paul

