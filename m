Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182Ab3EFV4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 17:56:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59188 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756585Ab3EFV4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 17:56:34 -0400
Date: Mon, 6 May 2013 17:56:29 -0400
From: Dave Jones <davej@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: rcu_init allocation failure trace on bootup
Message-ID: <20130506215629.GA20273@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20130506175647.GA1309@redhat.com>
 <20130506190522.GD3501@linux.vnet.ibm.com>
 <20130506192653.GA16819@redhat.com>
 <20130506194351.GH3501@linux.vnet.ibm.com>
 <20130506202413.GA1261@redhat.com>
 <20130506210249.GJ3501@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130506210249.GJ3501@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 02:02:49PM -0700, Paul E. McKenney wrote:

 > >  > You are quite right, I am getting ahead of myself.  Please see below
 > >  > for the patch.
 > > 
 > > Doesn't fix it for me.
 > > 
 > > Is it this one instead perhaps ?
 > > 
 > >   89 #ifndef CONFIG_RCU_NOCB_CPU_NONE
 > >   90         if (!have_rcu_nocb_mask) {
 > >   91                 alloc_bootmem_cpumask_var(&rcu_nocb_mask);
 > >   92                 have_rcu_nocb_mask = true;
 > >   93         }
 > 
 > Hmmm...  That was in fact the one that the patch was intended to change.
 > Just out of curiosity, where did the patch apply instead?

I think this might be my screwup. I did it by hand, and misapplied it
to the top of rcu_nocb_setup() instead.

	Dave



