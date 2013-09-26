Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab3IZHDM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 03:03:12 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:46316 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab3IZHDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 03:03:11 -0400
Date: Thu, 26 Sep 2013 09:03:07 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Don Zickus <dzickus@redhat.com>, Andi Kleen <ak@linux.jf.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [RFC 00/21] perf tools: Add toggling events support
Message-ID: <20130926070307.GE19090@gmail.com>
References: <1380113447-17144-1-git-send-email-jolsa@redhat.com>
 <20130925191216.GE2018@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130925191216.GE2018@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@linux.intel.com> wrote:

> On Wed, Sep 25, 2013 at 02:50:26PM +0200, Jiri Olsa wrote:
> > hi,
> > sending *RFC* for toggling events support.
> > 
> > Adding perf interface that allows to create toggle events, which can
> > enable or disable another event. Whenever the toggle event is triggered
> > (has overflow), it toggles another event state and either starts or
> > stops it.
> > 
> > The goal is to be able to create toggling tracepoint events to enable and
> > disable HW counters, but the interface is generic enough to be used for
> > any kind of event. 
> 
> Haven't read the patches, but frequent full event switch in/out seems 
> very expensive.  If someone puts that switch on a common function it 
> would likely disturb things quite a bit.
>
> It would be better to keep counting and just do RDPMC on the switch 
> points, and then subtract for counting. For sampling could need a MSR 
> write to enable/disable. Still somewhat expensive, but nowhere near as 
> bad as a full switch.

This is essentially an optimized event switch and should probably be done 
on a higher level so that other instances of event/context switching 
benefit as well.

Thanks,

	Ingo
