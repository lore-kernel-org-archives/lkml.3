Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567AbaJBGv3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 02:51:29 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:33654 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaJBGv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 02:51:28 -0400
Date: Thu, 2 Oct 2014 07:51:24 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v2 00/11] perf: Intel Cache QoS Monitoring support
Message-ID: <20141002065124.GF14343@console-pimps.org>
References: <1412174192-7010-1-git-send-email-matt@console-pimps.org>
 <8738b7eac2.fsf@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8738b7eac2.fsf@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Oct, at 02:42:05PM, Andi Kleen wrote:
> Matt Fleming <matt@console-pimps.org> writes:
> >
> > Changes in v2:
> >
> >  - Added Jiri Olsa's Acked-by to PATCH 02/11.
> >
> >  - Use x86_match_cpu() in intel_cqm_init() and make sure we grab the
> >    hotplug lock to prevent races as pointed out by Andi Kleen in
> >    PATCH 08/11.
> >
> >  - Delete a stale comment in commit message of PATCH 10/11.
> 
> No support for a modular driver?

I didn't include support for that because none of the other x86 pmu
drivers are buildable as modules. Is there a reason for that?

It's not clear to me that it would be a worthwhile change to make this
buildable as a module, since that would require a Kconfig entry and the
user would be required to make a decision regarding whether or not they
want to build CQM support.

It's much simpler to just build it in and enable it based on
CONFIG_PERF_EVENTS + CONFIG_INTEL_CPU. In fact, that's one of the things
I've always liked about the pmu drivers, if I move to a new machine and
turn on PERF_EVENTS the correct drivers will be run.

-- 
Matt Fleming, Intel Open Source Technology Center
