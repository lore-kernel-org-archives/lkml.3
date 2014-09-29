Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbaI2Svo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 14:51:44 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:48265 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbaI2Svm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 14:51:42 -0400
Date: Mon, 29 Sep 2014 19:51:40 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 08/11] perf/x86/intel: Add Intel Cache QoS Monitoring
 support
Message-ID: <20140929185140.GA14343@console-pimps.org>
References: <1411567455-31264-1-git-send-email-matt@console-pimps.org>
 <1411567455-31264-9-git-send-email-matt@console-pimps.org>
 <874mvx6kgl.fsf@tassilo.jf.intel.com>
 <20140924202739.GP18635@console-pimps.org>
 <20140924203937.GD15923@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924203937.GD15923@two.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep, at 10:39:37PM, Andi Kleen wrote:
> On Wed, Sep 24, 2014 at 09:27:39PM +0100, Matt Fleming wrote:
> > > > +static int __init intel_cqm_init(void)
> > > > +{
> > > > +	int i, cpu, ret;
> > > > +
> > > > +	if (!cpu_has(&boot_cpu_data, X86_FEATURE_CQM_OCCUP_LLC))
> > > > +		return -ENODEV;
> > > 
> > > This should use cpufeature.h
> >  
> > What? Please be more explicit.
> 
> Using x86_match_cpu and friends, then it would work for module
> auto loading too.
 
OK, I'll take a look at that, thanks.

> > > But in fact what good is the test then if you only
> > > every likely check cpu #0?
> > 
> > We don't, we check every online cpu, not just cpu 0.
> 
> There are no other cpus online at this point?

There are definitely other cpus online at this point, smp_init() gets
called before do_initcalls().

-- 
Matt Fleming, Intel Open Source Technology Center
