Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395Ab3LQSxk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:53:40 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:36925 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab3LQSxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:53:38 -0500
Message-ID: <52B09DAE.8060309@gmail.com>
Date: Tue, 17 Dec 2013 10:53:34 -0800
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: stable@vger.kernel.org
CC: dirk.brandewie@gmail.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Question regarding updating intel_pstate driver in stable
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I would like to see what is required to update intel_pstate in the stable
trees.  Some of the patches do NOT meet the all the rules in
stable_kernel_rules.txt.  v3.10.xx with intel_pstate is being used by multiple
projects at Intel that support the Baytrail and Haswell platforms.  I assume
this will be case for projects outside of Intel as well.  Baytrail support
came into v3.13.x and has the patch that falls outside of the stable rules.

016c815 intel_pstate: Refactor driver to support CPUs with different MSR layouts

Unfortunately the Baytrail group decided not to follow the lead of the core
group on enumerating and selecting P states which required refactoring the
driver to add support.

I would like to update all the stable tree to include the bugfixes up to
v3.12 and add Baytrail support.  All of the changes are under active test on
Haswell/Baytrail with v3.10.xx and v3.13-rcX with Android, ChromeOS, Fedora
and Ubuntu.


The complete list of changes:
git log --oneline stable/linux-3.10.y..v3.13-rc4  --no-merges 
drivers/cpufreq/intel_pstate.c
fbbcdc0 intel_pstate: skip the driver if ACPI has power mgmt option
e0a261a cpufreq/intel_pstate: Add static declarations to internal functions
19e77c2 intel_pstate: Add Baytrail support
016c815 intel_pstate: Refactor driver to support CPUs with different MSR layouts
7244cb6 intel_pstate: Correct calculation of min pstate value
d253d2a intel_pstate: Improve accuracy by not truncating until final result
09c87e2 intel_pstate: Fix type mismatch warning
52e0a50 cpufreq / intel_pstate: Fix max_perf_pct on resume
be49e34 cpufreq: add new routine cpufreq_verify_within_cpu_limits()
1ccf7a1 intel_pstate: fix no_turbo
6cdcdb7 intel_pstate: Add Haswell CPU models
adc97d6 cpufreq: Drop the owner field from struct cpufreq_driver
2134ed4 cpufreq / intel_pstate: Change to scale off of max P-state
2760984 cpufreq: delete __cpuinit usage from all cpufreq files

Changes
adc97d6 cpufreq: Drop the owner field from struct cpufreq_driver
be49e34 cpufreq: add new routine cpufreq_verify_within_cpu_limits()

Will be not carried back beyond the point where they entered mainline since they 
are cleanup patches from the cpufreq core.

Is reasonable/possible?

If so what is the correct way to deliver patches?  Patchset per stable tree.

--Dirk
