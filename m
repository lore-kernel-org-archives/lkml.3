Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759084AbbA2D4E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:56:04 -0500
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:59034 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751548AbbA2BKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:10:49 -0500
Message-ID: <1422483088.3621.56.camel@x220>
Subject: Re: [PATCH 1/6] x86/intel_cat: Intel Cache Allocation Technology
 detection
From: Paul Bolle <pebolle@tiscali.nl>
To: Vikas Shivappa <vikas.shivappa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, vikas.shivappa@intel.com, hpa@zytor.com,
        tglx@linutronix.de, mingo@kernel.org, tj@kernel.org,
        peterz@infradead.org, matt.fleming@intel.com, will.auld@intel.com
Date: Wed, 28 Jan 2015 23:11:28 +0100
In-Reply-To: <1422403209-15533-2-git-send-email-vikas.shivappa@linux.intel.com>
References: <1422403209-15533-1-git-send-email-vikas.shivappa@linux.intel.com>
	 <1422403209-15533-2-git-send-email-vikas.shivappa@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jan 2015 22:11:28.0869 (UTC) FILETIME=[5D5AC150:01D03B47]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial nit below.

On Tue, 2015-01-27 at 16:00 -0800, Vikas Shivappa wrote:
> This patch adds support for the new Cache Allocation Technology (CAT)
> feature found in future Intel Xeon processors.  It includes CPUID
> enumeration routines for CAT and new values to track CAT resources to
> the cpuinfo_x86 structure.
> 
> Cache Allocation Technology(CAT) provides a way for the Software
> (OS/VMM) to restrict cache allocation to a defined 'subset' of cache
> which may be overlapping with other 'subsets'.  This feature is used
> when allocating a line in cache ie when pulling new data into the cache.
> The programming of the h/w is done via programming  MSRs.
> 
> More information about CAT be found in the Intel (R) x86 Architecture
> Software Developer Manual, section 17.15.
> 
> Signed-off-by: Vikas Shivappa <vikas.shivappa@linux.intel.com>

[...]

> diff --git a/init/Kconfig b/init/Kconfig
> index 9afb971..475b7b7 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -961,6 +961,17 @@ config CPUSETS
>  
>  	  Say N if unsure.
>  
> +config CGROUP_CAT
> +  bool "Cache Allocation Technology cgroup subsystem"
> +  depends on X86_64

Odd indentation. Just make it a tab (as I suppose the indentation of
"help" already is).

> +	help
> +	  This option provides framework to allocate cache lines when
> +	  applications fill cache.
> +	  This can be used by users to configure how much cache that can be
> +	  allocated to different PIDs.
> +
> +	  Say N if unsure.
> +
>  config PROC_PID_CPUSET
>  	bool "Include legacy /proc/<pid>/cpuset file"
>  	depends on CPUSETS


Paul Bolle

