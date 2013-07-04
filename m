Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab3GDMwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 08:52:23 -0400
Received: from ozlabs.org ([203.10.76.45]:51345 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828Ab3GDMwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 08:52:21 -0400
Date: Thu, 4 Jul 2013 22:52:18 +1000
From: Michael Ellerman <michael@ellerman.id.au>
To: Vince Weaver <vince@deater.net>
Cc: Runzhen Wang <runzhen@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
        Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org,
        vincent.weaver@maine.edu, Stephane Eranian <eranian@google.com>,
        sukadev@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com
Subject: Re: [PATCH v2 2/2] perf tools: Make Power7 events available for perf
Message-ID: <20130704125218.GA21134@concordia>
References: <1372170933-4538-1-git-send-email-runzhen@linux.vnet.ibm.com>
 <1372170933-4538-3-git-send-email-runzhen@linux.vnet.ibm.com>
 <alpine.DEB.2.02.1306251240440.25443@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1306251240440.25443@pianoman.cluster.toy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 12:46:42PM -0400, Vince Weaver wrote:
> On Tue, 25 Jun 2013, Runzhen Wang wrote:
> 
> > This patch makes all the POWER7 events available in sysfs.
> > 
> > ...
> >
> > $ size arch/powerpc/perf/power7-pmu.o
> >    text	   data	    bss	    dec	    hex	filename
> >    3073	   2720	      0	   5793	   16a1	arch/powerpc/perf/power7-pmu.o
> > 
> > and after the patch is applied, it is:
> > 
> > $ size arch/powerpc/perf/power7-pmu.o
> >    text	   data	    bss	    dec	    hex	filename
> >   15950	  31112	      0	  47062	   b7d6	arch/powerpc/perf/power7-pmu.o
> 
> So if I'm reading this right, there's 45k of overhead for just one cpu 
> type?

I think there's another ~56K at runtime too, at least on my system where
each sysfs_dirent is 112 bytes.
 
> What happens if we do this on x86?
> 
> If we have similar for p6/p4/core2/nehalem/ivb/snb/amd10h/amd15h/amd16h/knb
> that's 450k of event defintions in the kernel.  And may I remind everyone 
> that you can't compile perf_event support as a module, nor can you 
> unconfigure it on x86 (it's always built in, no option to disable).

To be honest on Power7 systems we're not really bothered about ~100K,
that's less than two pages. But I agree with your point that it's
getting a bit silly.

Various folks have tried over the years to get alternative approaches
adopted (as I'm sure you know), and this has just ended up as the path
of least resistance.

> I'd like to repeat my unpopular position that we just link perf against 
> libpfm4 and keep event tables in userspace where they belong.

I don't think it even needs libpfm4, just some csv files in tools/perf
would do the trick.

Instead we have Google using gooda, which provides event decoding on top
of perf (via libpfm4). Andi Kleen at Intel has a tool that provides
event decoding on top of perf. Presumably Facebook do too? And at IBM
most folks still use oprofile, because it provides event decoding. 

cheers
