Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924Ab3KTWIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 17:08:42 -0500
Received: from mga11.intel.com ([192.55.52.93]:49988 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858Ab3KTWIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 17:08:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,739,1378882800"; 
   d="scan'208";a="436915185"
Date: Wed, 20 Nov 2013 14:08:21 -0800
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, lenb@kernel.org,
        rjw@rjwysocki.net, Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        Chris Leech <christopher.leech@intel.com>,
        David Miller <davem@davemloft.net>, rui.zhang@intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 3/7] idle, thermal, acpi: Remove home grown idle
 implementations
Message-ID: <20131120140821.1d5607c2@ultegra>
In-Reply-To: <alpine.DEB.2.02.1311201959460.30673@ionos.tec.linutronix.de>
References: <20131120160450.072555619@infradead.org>
	<20131120162736.508462614@infradead.org>
	<528CE611.8040903@linux.intel.com>
	<alpine.DEB.2.02.1311201814410.30673@ionos.tec.linutronix.de>
	<528CF028.2040002@linux.intel.com>
	<alpine.DEB.2.02.1311201851040.30673@ionos.tec.linutronix.de>
	<528CFDB1.3020300@linux.intel.com>
	<alpine.DEB.2.02.1311201959460.30673@ionos.tec.linutronix.de>
Organization: OTC
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Nov 2013 20:38:03 +0100 (CET)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Wed, 20 Nov 2013, Arjan van de Ven wrote:
> > 
> > but for powerclamp to work, it needs to inject a deep idle....  I'm
> > very ok using generic abstractions for that, but the abstraction
> > needs to then include a "don't be nice about picking shallow C
> > states for performance reasons, just pick something very deep"
> > parameter.
> 
> And that's what you should have done in the first place. Make the
> generic code take a parameter to indicate that. Or tell the scheduler
> to throttle the machine and go deep idle. That would also be helpful
> to others who might need some similar thing.
> 
I thought about that. Since the generic code is in performance critical
path and idle injection is a rare case. Then the question is do we
want sacrifice the 99% for %1 usage?

> No, you went with the worst design:
> 
>     - Hack it into some random driver
>     - Export random core interfaces so it's harder to change them
>     - Let others deal with the fallout
> 
> I'm cleaning up that kind of mess for more than 9 years now and I'm
> really disappointed that you went over to the "who cares, works for
> me" camp.
> 
> I can lively remember our discussions when we were cleaning up the
> whole timer mess together in order to make NOHZ actually useful. Your
> cursing about such code was definitely impressive back then.
> 
> Thanks,
> 
> 	tglx
> 
> 
> 
> 

[Jacob Pan]
