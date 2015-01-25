Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307AbbAYXHI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 18:07:08 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:60093 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbbAYXHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 18:07:04 -0500
Date: Sun, 25 Jan 2015 23:07:01 +0000
From: Matt Fleming <matt@codeblueprint.co.uk>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Kanaka Juvva <kanaka.d.juvva@intel.com>,
        Vikas Shivappa <vikas.shivappa@linux.intel.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 5/9] perf/x86/intel: Add Intel Cache QoS Monitoring
 support
Message-ID: <20150125230701.GC4148@codeblueprint.co.uk>
References: <1422038748-21397-1-git-send-email-matt@codeblueprint.co.uk>
 <1422038748-21397-6-git-send-email-matt@codeblueprint.co.uk>
 <20150125183455.GA15208@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150125183455.GA15208@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Jan, at 07:34:55PM, Jiri Olsa wrote:
> On Fri, Jan 23, 2015 at 06:45:44PM +0000, Matt Fleming wrote:
> 
> SNIP
> 
> > +	int phys_id = topology_physical_package_id(cpu);
> > +	int i;
> > +
> > +	for_each_cpu(i, &cqm_cpumask) {
> > +		if (phys_id == topology_physical_package_id(i))
> > +			return;	/* already got reader for this socket */
> > +	}
> > +
> > +	cpumask_set_cpu(cpu, &cqm_cpumask);
> > +}
> > +
> > +static void intel_cqm_cpu_prepare(unsigned int cpu)
> > +{
> > +	struct intel_cqm_state *state = &per_cpu(cqm_state, cpu);
> > +	struct cpuinfo_x86 *c = &cpu_data(cpu);
> > +
> > +	raw_spin_lock_init(&state->lock);
> > +	state->rmid = 0;
> 
> shouldn't you also init state->cnt?

Oops. Good catch, thanks!

-- 
Matt Fleming, Intel Open Source Technology Center
