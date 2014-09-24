Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbaIXUjl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 16:39:41 -0400
Received: from one.firstfloor.org ([193.170.194.197]:32847 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbaIXUjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 16:39:40 -0400
Date: Wed, 24 Sep 2014 22:39:37 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 08/11] perf/x86/intel: Add Intel Cache QoS Monitoring
 support
Message-ID: <20140924203937.GD15923@two.firstfloor.org>
References: <1411567455-31264-1-git-send-email-matt@console-pimps.org>
 <1411567455-31264-9-git-send-email-matt@console-pimps.org>
 <874mvx6kgl.fsf@tassilo.jf.intel.com>
 <20140924202739.GP18635@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924202739.GP18635@console-pimps.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 09:27:39PM +0100, Matt Fleming wrote:
> > > +static int __init intel_cqm_init(void)
> > > +{
> > > +	int i, cpu, ret;
> > > +
> > > +	if (!cpu_has(&boot_cpu_data, X86_FEATURE_CQM_OCCUP_LLC))
> > > +		return -ENODEV;
> > 
> > This should use cpufeature.h
>  
> What? Please be more explicit.

Using x86_match_cpu and friends, then it would work for module
auto loading too.

> > But in fact what good is the test then if you only
> > every likely check cpu #0?
> 
> We don't, we check every online cpu, not just cpu 0.

There are no other cpus online at this point?

-Andi
