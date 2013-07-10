Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab3GJPqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 11:46:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14275 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753948Ab3GJPqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 11:46:18 -0400
Date: Wed, 10 Jul 2013 11:45:40 -0400
From: Dave Jones <davej@redhat.com>
To: Vince Weaver <vince@deater.net>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Anvin <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: Yet more softlockups.
Message-ID: <20130710154540.GC11309@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Vince Weaver <vince@deater.net>, Ingo Molnar <mingo@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Peter Anvin <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
References: <20130704015525.GA8486@redhat.com>
 <CA+55aFykwkTVtZuoCEvwpF+5q1LUscw1shkWNPtGdHu+1DgDJA@mail.gmail.com>
 <20130705143821.GB325@redhat.com>
 <alpine.DEB.2.02.1307051710070.32106@ionos.tec.linutronix.de>
 <20130705160043.GF325@redhat.com>
 <20130706072408.GA14865@gmail.com>
 <20130710151324.GA11309@redhat.com>
 <alpine.DEB.2.02.1307101137160.2022@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1307101137160.2022@pianoman.cluster.toy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 11:39:50AM -0400, Vince Weaver wrote:
 > On Wed, 10 Jul 2013, Dave Jones wrote:
 > 
 > > Something is really fucked up in the kernel side of perf.
 > > I get this right after booting..
 > > 
 > > [  114.516619] perf samples too long (4262 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
 > > 
 > > That's before I even get a chance to log in, so I'm pretty sure perf isn't even being run.
 > > 
 > > And this is just booting up my desktop, not fuzzing.
 > 
 > This is probably related to the problem described in the thread
 >    perf: fix interrupt handler timing harness
 >    http://comments.gmane.org/gmane.linux.kernel/1520775
 > which in theory has a fix.  Not sure why it'd trigger during boot.

Ah, missed that thread. Thanks for the pointer. That looks important,
and might actually explain some of the other oddness I've been seeing.

 > NMI watchdog?

likely.

	Davek


