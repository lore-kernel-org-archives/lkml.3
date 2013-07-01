Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962Ab3GATT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 15:19:59 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:51051 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864Ab3GATT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 15:19:58 -0400
Date: Mon, 1 Jul 2013 12:19:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu
Subject: Re: [PATCH RFC nohz_full 0/7] v2 Provide infrastructure for
 full-system idle
Message-ID: <20130701191949.GS3773@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130628200949.GA17458@linux.vnet.ibm.com>
 <87a9m65mv6.fsf@tassilo.jf.intel.com>
 <20130701160314.GM3773@linux.vnet.ibm.com>
 <20130701161910.GN6123@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130701161910.GN6123@two.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070119-7182-0000-0000-000007986AED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 01, 2013 at 06:19:10PM +0200, Andi Kleen wrote:
> > I am guessing that you want CONFIG_NO_HZ_FULL to implicitly enable
> > the sysidle code so that CONFIG_NO_HZ_FULL_SYSIDLE can be eliminated.
> > I will be happy to take that step, but only after I gain full confidence
> > in the correctness and performance of the sysidle code.
> 
> FWIW if you want useful testing you need to enable it by default
> (as part of NO_IDLE_HZ) anyways. Users will most likely pick
> whatever is "default" in Kconfig.

At this point in the process, I want testers who choose to test.  Hapless
victim testers come later.  Well, other than randconfig testers, but I
consider them to be voluntary hapless victims.  ;-)

> > > If you want a switch for testing I would advise a sysctl or sysfs knob
> > 
> > This would work well for the correctness part, but not for the performance
> > part.
> 
> What performance part? 
> 
> Are you saying this adds so many checks to hot paths that normal runtime
> if() with a flag is too expensive?

I am saying that I don't know, and that I want to make it easy for people
to find out by comparing to the base configuration -- and for me to be
able to detect this from their .config file.

							Thanx, Paul

