Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab3B0HZV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 02:25:21 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:55371 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229Ab3B0HZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 02:25:17 -0500
MIME-Version: 1.0
In-Reply-To: <512DB199.5050203@cn.fujitsu.com>
References: <512B7D10.4060304@tpi.com>
	<512B8407.2090807@canonical.com>
	<512BD753.4080001@hp.com>
	<CAE9FiQVY4io_mO3PhTtE6FbGUgo1uZKKXO=pjx_FoZ1JuZmsAw@mail.gmail.com>
	<CAE9FiQXRZ2VjfG4L2d2zDQ3Sud=JqjS=M9=XW=ORS58_y7i4_g@mail.gmail.com>
	<CAE9FiQU-CV4mF8x=Bi_4pmpmeZW-tSoes_f-jOt7yYrbrppo+A@mail.gmail.com>
	<512D58C2.1090403@jp.fujitsu.com>
	<CAE9FiQV5APHSGXuz3NrsApC+V7rsDQMDXMNwZszZuUqQVaZSew@mail.gmail.com>
	<512D7FAD.1040003@jp.fujitsu.com>
	<CAE9FiQWxq-HPKK+XNRLggZSM4NcdfaeGDWCgd3HegEhaDSSTtA@mail.gmail.com>
	<512D8EDA.3010602@jp.fujitsu.com>
	<CAE9FiQWAxL6F70fF0dQcBZKTReJOiC+Ez0xcqcosgAdSagS-bA@mail.gmail.com>
	<512D9E69.6010102@jp.fujitsu.com>
	<CAE9FiQV9JRk1SYLkBXsQmrSEDHrYZDpBV6UZb+U5rB7=4gFhVA@mail.gmail.com>
	<512DB199.5050203@cn.fujitsu.com>
Date: Tue, 26 Feb 2013 23:25:16 -0800
X-Google-Sender-Auth: zvsOwzo4pUyl5qhe6s1iIMeYTf0
Message-ID: <CAE9FiQXvdXoW8xFO2Q_dJo4jRkse5Lg9TmLHuFhqZ9H92ipsuw@mail.gmail.com>
Subject: Re: sched: CPU #1's llc-sibling CPU #0 is not on the same node!
From: Yinghai Lu <yinghai@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Don Morris <don.morris@hp.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Tony Luck <tony.luck@intel.com>,
        Thomas Renninger <trenn@suse.de>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, a.p.zijlstra@chello.nl,
        jarkko.sakkinen@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 11:11 PM, Tang Chen <tangchen@cn.fujitsu.com> wrote:
> On 02/27/2013 02:54 PM, Yinghai Lu wrote:
>>
>> Those patches are tangled together.
>
>
> No, they are not.
>
> The following commits supports "movablemem_map=nn[KMG]@ss[KMG]".
>
> commit fb06bc8e5f42f38c011de0e59481f464a82380f6
>     page_alloc: bootmem limit with movablecore_map
> commit 42f47e27e761fee07da69e04612ec7dd0d490edd
>     page_alloc: make movablemem_map have higher priority
> commit 6981ec31146cf19454c55c130625f6cee89aab95
>     page_alloc: introduce zone_movable_limit[] to keep movable limit for nodes
> commit 34b71f1e04fcba578e719e675b4882eeeb2a1f6f
>     page_alloc: add movable_memmap kernel parameter
> commit 4d59a75125d5a4717e57e9fc62c64b3d346e603e
>     x86: get pg_data_t's memory from other node
>
> And the following supports "movablemem_map=srat".
>
> commit f7210e6c4ac795694106c1c5307134d3fc233e88
>     mm/memblock.c: use CONFIG_HAVE_MEMBLOCK_NODE_MAP to protect movablecore_map in memblock_overlaps_region().
> commit 01a178a94e8eaec351b29ee49fbb3d1c124cb7fb
>     acpi, memory-hotplug: support getting hotplug info from SRAT
> commit 27168d38fa209073219abedbe6a9de7ba9acbfad
>     acpi, memory-hotplug: extend movablemem_map ranges to the end of node
> commit e8d1955258091e4c92d5a975ebd7fd8a98f5d30f
>     acpi, memory-hotplug: parse SRAT before memblock is ready

those four can be reverted cleanly?

>
>>
>> Also it looks funny to ask user to specify mem range in boot command
>> line to enable mem hotplug.
>
>
> Well, I think sometimes users don't like the SRAT memory style, and want to
> increase or reduce hot-pluggable memory by themselves. And also, it is
> useful
> for debuging firmware bugs.
>
> I agree that "movablemem_map=srat" functionality need more work to improve.
> Can we not revert it, and improve it during 3.9rc ? I think during rc time,
> at least we can fix the problems brought by early_parse_srat().

looks like acpi_override can not be fixed.

Thanks

Yinghai
