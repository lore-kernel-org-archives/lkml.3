Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601Ab3GJPjG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 11:39:06 -0400
Received: from smtpauth12.mfg.siteprotect.com ([64.26.60.150]:60930 "EHLO
	smtpauth02.mfg.siteprotect.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753897Ab3GJPjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 11:39:04 -0400
Date: Wed, 10 Jul 2013 11:39:50 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Dave Jones <davej@redhat.com>
cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Anvin <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: Yet more softlockups.
In-Reply-To: <20130710151324.GA11309@redhat.com>
Message-ID: <alpine.DEB.2.02.1307101137160.2022@pianoman.cluster.toy>
References: <20130704015525.GA8486@redhat.com> <CA+55aFykwkTVtZuoCEvwpF+5q1LUscw1shkWNPtGdHu+1DgDJA@mail.gmail.com> <20130705143821.GB325@redhat.com> <alpine.DEB.2.02.1307051710070.32106@ionos.tec.linutronix.de> <20130705160043.GF325@redhat.com>
 <20130706072408.GA14865@gmail.com> <20130710151324.GA11309@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A02020A.51DD8018.004F,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Jul 2013, Dave Jones wrote:

> Something is really fucked up in the kernel side of perf.
> I get this right after booting..
> 
> [  114.516619] perf samples too long (4262 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
> 
> That's before I even get a chance to log in, so I'm pretty sure perf isn't even being run.
> 
> And this is just booting up my desktop, not fuzzing.

This is probably related to the problem described in the thread
   perf: fix interrupt handler timing harness
   http://comments.gmane.org/gmane.linux.kernel/1520775
which in theory has a fix.  Not sure why it'd trigger during boot.
NMI watchdog?

Vince

