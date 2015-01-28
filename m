Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313AbbA2Bo0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:44:26 -0500
Received: from mga14.intel.com ([192.55.52.115]:32072 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753060AbbA2BoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:44:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,483,1418112000"; 
   d="scan'208";a="658308132"
Date: Wed, 28 Jan 2015 15:17:03 -0800 (PST)
From: Vikas Shivappa <vikas.shivappa@intel.com>
X-X-Sender: vikas@vshiva-Udesk
To: Paul Bolle <pebolle@tiscali.nl>
cc: Vikas Shivappa <vikas.shivappa@linux.intel.com>,
        linux-kernel@vger.kernel.org, vikas.shivappa@intel.com, hpa@zytor.com,
        tglx@linutronix.de, mingo@kernel.org, tj@kernel.org,
        peterz@infradead.org, Matt Fleming <matt.fleming@intel.com>,
        "Auld, Will" <will.auld@intel.com>
Subject: Re: [PATCH 1/6] x86/intel_cat: Intel Cache Allocation Technology
 detection
In-Reply-To: <1422483088.3621.56.camel@x220>
Message-ID: <alpine.DEB.2.10.1501281510190.3500@vshiva-Udesk>
References: <1422403209-15533-1-git-send-email-vikas.shivappa@linux.intel.com>  <1422403209-15533-2-git-send-email-vikas.shivappa@linux.intel.com> <1422483088.3621.56.camel@x220>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 28 Jan 2015, Paul Bolle wrote:

> Trivial nit below.
>
> On Tue, 2015-01-27 at 16:00 -0800, Vikas Shivappa wrote:
>> This patch adds support for the new Cache Allocation Technology (CAT)
>> feature found in future Intel Xeon processors.  It includes CPUID
>> enumeration routines for CAT and new values to track CAT resources to
>> the cpuinfo_x86 structure.
>>
>> Cache Allocation Technology(CAT) provides a way for the Software
>> (OS/VMM) to restrict cache allocation to a defined 'subset' of cache
>> which may be overlapping with other 'subsets'.  This feature is used
>> when allocating a line in cache ie when pulling new data into the cache.
>> The programming of the h/w is done via programming  MSRs.
>>
>> More information about CAT be found in the Intel (R) x86 Architecture
>> Software Developer Manual, section 17.15.
>>
>> Signed-off-by: Vikas Shivappa <vikas.shivappa@linux.intel.com>
>
> [...]
>
>> diff --git a/init/Kconfig b/init/Kconfig
>> index 9afb971..475b7b7 100644
>> --- a/init/Kconfig
>> +++ b/init/Kconfig
>> @@ -961,6 +961,17 @@ config CPUSETS
>>
>>  	  Say N if unsure.
>>
>> +config CGROUP_CAT
>> +  bool "Cache Allocation Technology cgroup subsystem"
>> +  depends on X86_64
>
> Odd indentation. Just make it a tab (as I suppose the indentation of
> "help" already is).

ok , Will fix. Wish the checkpatch.pl caught that :)

Thanks,
Vikas

>
>> +	help
>> +	  This option provides framework to allocate cache lines when
>> +	  applications fill cache.
>> +	  This can be used by users to configure how much cache that can be
>> +	  allocated to different PIDs.
>> +
>> +	  Say N if unsure.
>> +
>>  config PROC_PID_CPUSET
>>  	bool "Include legacy /proc/<pid>/cpuset file"
>>  	depends on CPUSETS
>
>
> Paul Bolle
>
>
