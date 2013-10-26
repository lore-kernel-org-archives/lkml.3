Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab3JZRAx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 13:00:53 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:42942 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab3JZRAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 13:00:52 -0400
MIME-Version: 1.0
In-Reply-To: <20131025111422.GC1219@krava.redhat.com>
References: <1382533085-7166-1-git-send-email-eranian@google.com>
	<1382533085-7166-4-git-send-email-eranian@google.com>
	<20131025111422.GC1219@krava.redhat.com>
Date: Sat, 26 Oct 2013 19:00:51 +0200
Message-ID: <CABPqkBR0gEz7cauev0hk=oofO1m9RP=wP3NK3j0y7EiNE8j3tg@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] perf,x86: add Intel RAPL PMU support
From: Stephane Eranian <eranian@google.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>, Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25, 2013 at 1:14 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Wed, Oct 23, 2013 at 02:58:04PM +0200, Stephane Eranian wrote:
>
> SNIP
>
>> +
>> +static void rapl_init_cpu(int cpu)
>> +{
>> +     int i, phys_id = topology_physical_package_id(cpu);
>> +
>> +     spin_lock(&rapl_hotplug_lock);
>> +
>> +     /* check if phys_is is already covered */
>> +     for_each_cpu(i, &rapl_cpu_mask) {
>> +             if (phys_id == topology_physical_package_id(i))
>> +                     return;
>
> missing 'spin_unlock(&rapl_hotplug_lock)' above
>
Good catch. I fixed that now.

>> +     }
>> +     /* was not found, so add it */
>> +     cpumask_set_cpu(cpu, &rapl_cpu_mask);
>> +
>> +     spin_unlock(&rapl_hotplug_lock);
>> +}
>> +
