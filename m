Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbaFFPsJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 11:48:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:49279 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692AbaFFPsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 11:48:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,989,1392192000"; 
   d="scan'208";a="543637757"
Date: Fri, 6 Jun 2014 08:47:42 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, lenb@kernel.org, mingo@kernel.org,
        tglx@linutronix.de, hpa@zytor.com, arjan@linux.intel.com,
        rui.zhang@intel.com, luto@amacapital.net
Subject: Re: [PATCH] idle, thermal, acpi: Remove home grown idle
 implementations
Message-ID: <20140606084742.1ff06c12@ultegra>
In-Reply-To: <20140605065520.GB3213@twins.programming.kicks-ass.net>
References: <20140604085418.GA11096@twins.programming.kicks-ass.net>
	<20140604015812.140a00d1@jacob-desktop>
	<20140605065520.GB3213@twins.programming.kicks-ass.net>
Organization: OTC
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jun 2014 08:55:20 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, Jun 04, 2014 at 01:58:12AM -0700, Jacob Pan wrote:
> > On Wed, 4 Jun 2014 10:54:18 +0200
> > Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > 
> > > I'm still sitting on this patch. Jacub you were going to make it
> > > play nice with QoS?
> > > 
> > I had a patchset to work through system PM QOS and still maintain
> > the idle injection efficiency. When I saw you did not merge the
> > patch below, I thought you have abandoned it :)
> 
> I was waiting for you to do the QoS bits :-)
> 
> > The only issue as per our last discussion is the lack of
> > notification when PM QOS cannot be met. But that is intrinsic to PM
> > QOS itself.
> > 
> > I also consulted with Arjan and looked at directly intercept with
> > intel_idle since both intel_powerclamp and intel_idle are arch
> > specific drivers. But I think that is hard to do at per idle period
> > basis, since we should still allow "natural" idle during the forced
> > idle time.
> > 
> > So, I think we can take a two stepped approach,
> > 1. integrate your patch with a
> > updated version of https://lkml.org/lkml/2013/11/26/534 such that
> > there is no performance/efficiency regression.
> > 2. add notification mechanism to system qos when constraints cannot
> > be met.
> 
> That's fine with me; can you respin those bits?

yes, working on it. it may take some time since lots of testing needed.
will include acpipad as well.
