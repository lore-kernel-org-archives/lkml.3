Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137Ab3GIB35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 21:29:57 -0400
Received: from ozlabs.org ([203.10.76.45]:37592 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780Ab3GIB3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 21:29:55 -0400
Date: Tue, 9 Jul 2013 11:29:52 +1000
From: Michael Ellerman <michael@ellerman.id.au>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vince Weaver <vince@deater.net>, Runzhen Wang <runzhen@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        paulus@samba.org, acme@redhat.com, mingo@kernel.org,
        vincent.weaver@maine.edu, Stephane Eranian <eranian@google.com>,
        sukadev@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com
Subject: Re: [PATCH v2 2/2] perf tools: Make Power7 events available for perf
Message-ID: <20130709012952.GA7185@concordia>
References: <1372170933-4538-1-git-send-email-runzhen@linux.vnet.ibm.com>
 <1372170933-4538-3-git-send-email-runzhen@linux.vnet.ibm.com>
 <alpine.DEB.2.02.1306251240440.25443@pianoman.cluster.toy>
 <20130704125218.GA21134@concordia>
 <20130704125700.GM18898@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130704125700.GM18898@dyad.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 04, 2013 at 02:57:00PM +0200, Peter Zijlstra wrote:
> On Thu, Jul 04, 2013 at 10:52:18PM +1000, Michael Ellerman wrote:
> > I don't think it even needs libpfm4, just some csv files in tools/perf
> > would do the trick.
> 
> Right; I think Stephane and Jiri are in favour of creating a 'new' project that
> includes just the event definitions in a plain text format and a little library
> with parser to be used by all interested parties.

OK that would be great.

The part that seems to be missing to make that work is we have no way of
matching the PMU that appears in /sys with a list of events.

Eg. on my system I have /sys/bus/event_source/devices/cpu - but there's
nothing in there to identify that it's a Sandy Bridge.

For the cpu you can obviously just detect what processor you're on with
cpuid or whatever, but it's a bit of a hack. And that really doesn't
work for non-cpu PMUs.

So it seems to me we need to add an attribute to the PMU in sysfs so
that we can identify it and match it up with a list of events?

cheers
