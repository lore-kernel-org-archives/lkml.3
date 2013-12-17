Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab3LQT7e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 14:59:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54512 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220Ab3LQT7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 14:59:32 -0500
Date: Tue, 17 Dec 2013 11:59:33 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: stable@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: Question regarding updating intel_pstate driver in stable
Message-ID: <20131217195933.GC28274@kroah.com>
References: <52B09DAE.8060309@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B09DAE.8060309@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 10:53:34AM -0800, Dirk Brandewie wrote:
> Hi All,
> 
> I would like to see what is required to update intel_pstate in the stable
> trees.  Some of the patches do NOT meet the all the rules in
> stable_kernel_rules.txt.

Then there's not much we can do, right?  Why do you want to go against
the well-known rules we have been following for the past 8+ years?  What
makes this hardware so "special" in that regard (hint, everyone thinks
that _their_ hardware/driver is "special", and they are, just like
everyone else.)

> v3.10.xx with intel_pstate is being used by multiple
> projects at Intel that support the Baytrail and Haswell platforms.  I assume
> this will be case for projects outside of Intel as well.  Baytrail support
> came into v3.13.x and has the patch that falls outside of the stable rules.
> 
> 016c815 intel_pstate: Refactor driver to support CPUs with different MSR layouts
> 
> Unfortunately the Baytrail group decided not to follow the lead of the core
> group on enumerating and selecting P states which required refactoring the
> driver to add support.
> 
> I would like to update all the stable tree to include the bugfixes up to
> v3.12 and add Baytrail support.  All of the changes are under active test on
> Haswell/Baytrail with v3.10.xx and v3.13-rcX with Android, ChromeOS, Fedora
> and Ubuntu.

There are projects like LTSI that can take patches that are beyond the
stable kernel rules, and some of the above listed projects are using
LTSI for their kernels, so perhaps that might be the better solution
here?

> The complete list of changes:
> git log --oneline stable/linux-3.10.y..v3.13-rc4  --no-merges
> drivers/cpufreq/intel_pstate.c
> fbbcdc0 intel_pstate: skip the driver if ACPI has power mgmt option
> e0a261a cpufreq/intel_pstate: Add static declarations to internal functions
> 19e77c2 intel_pstate: Add Baytrail support
> 016c815 intel_pstate: Refactor driver to support CPUs with different MSR layouts
> 7244cb6 intel_pstate: Correct calculation of min pstate value
> d253d2a intel_pstate: Improve accuracy by not truncating until final result
> 09c87e2 intel_pstate: Fix type mismatch warning
> 52e0a50 cpufreq / intel_pstate: Fix max_perf_pct on resume
> be49e34 cpufreq: add new routine cpufreq_verify_within_cpu_limits()
> 1ccf7a1 intel_pstate: fix no_turbo
> 6cdcdb7 intel_pstate: Add Haswell CPU models
> adc97d6 cpufreq: Drop the owner field from struct cpufreq_driver
> 2134ed4 cpufreq / intel_pstate: Change to scale off of max P-state
> 2760984 cpufreq: delete __cpuinit usage from all cpufreq files

Do you really need all of those changes for the 3.10-stable kernel tree?
(hint, I don't think so...)

How about distilling it down to a specific set of commits that you feel
is needed.  Some of the above patches could go into a stable kernel tree
just fine, as they do follow the "rules", but others can't, as you point
out.

> Changes
> adc97d6 cpufreq: Drop the owner field from struct cpufreq_driver
> be49e34 cpufreq: add new routine cpufreq_verify_within_cpu_limits()
> 
> Will be not carried back beyond the point where they entered mainline since
> they are cleanup patches from the cpufreq core.

What do you mean by this?

thanks,

greg k-h
