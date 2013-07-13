Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059Ab3GMBjj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 21:39:39 -0400
Received: from smtpauth05.mfg.siteprotect.com ([64.26.60.144]:48287 "EHLO
	smtpauth05.mfg.siteprotect.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757998Ab3GMBji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 21:39:38 -0400
Date: Fri, 12 Jul 2013 21:40:19 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Dave Jones <davej@redhat.com>
cc: Dave Hansen <dave.hansen@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Anvin <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: Yet more softlockups.
In-Reply-To: <20130712154521.GD1020@redhat.com>
Message-ID: <alpine.DEB.2.02.1307122136540.2540@pianoman.cluster.toy>
References: <CA+55aFykwkTVtZuoCEvwpF+5q1LUscw1shkWNPtGdHu+1DgDJA@mail.gmail.com> <20130705143821.GB325@redhat.com> <alpine.DEB.2.02.1307051710070.32106@ionos.tec.linutronix.de> <20130705160043.GF325@redhat.com> <20130706072408.GA14865@gmail.com>
 <20130710151324.GA11309@redhat.com> <20130710152015.GA757@x4> <20130710154029.GB11309@redhat.com> <20130712103117.GA14862@gmail.com> <51E0230C.9010509@intel.com> <20130712154521.GD1020@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020207.51E0AFD9.00E0,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jul 2013, Dave Jones wrote:

> 
> Here's a fun trick:
> 
> trinity -c perf_event_open -C4 -q -l off
> 
> Within about a minute, that brings any of my boxes to its knees.
> The softlockup detector starts going nuts, and then the box wedges solid.

are you running with the patch

 [PATCH 1/2] perf: Clone child context from parent context pmu

 https://lkml.org/lkml/2013/7/9/310

It hasn't hit Linus git yet.

It fixes a bug that my perf_fuzzer would hit within seconds but it took me 
over a month of trace bisecting and kernel bisecting to isolate it.

The symptoms were stuck processes and NMI tracebacks leading to hard 
locks.  

With the patch applied my perf_fuzzer (which uses the same perf_event_open 
syscall generator as trinity) runs for hours w/o problems.

Vince
