Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159Ab3JNUhu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:37:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56854 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932289Ab3JNUhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:37:05 -0400
Message-ID: <525C55A6.1030406@zytor.com>
Date: Mon, 14 Oct 2013 13:35:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>, Zhang Yanfei <zhangyanfei.yes@gmail.com>
CC: Tejun Heo <tj@kernel.org>, Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Toshi Kani <toshi.kani@hp.com>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH part2 v2 0/8] Arrange hotpluggable memory as ZONE_MOVABLE
References: <5258E560.5050506@cn.fujitsu.com>	<525B19C3.9040907@gmail.com>	<20131014133835.GG4722@htj.dyndns.org>	<525BFCF3.5010908@gmail.com>	<20131014142719.GI4722@htj.dyndns.org>	<525C02DC.4050706@gmail.com>	<20131014145131.GJ4722@htj.dyndns.org>	<525C0866.2010808@gmail.com>	<20131014151902.GL4722@htj.dyndns.org>	<525C0EFE.2010409@gmail.com> <CAE9FiQX0xeR61ehPy2SfWfN-fgSZVS=dtaWT-QQ+RR12tx+A0w@mail.gmail.com>
In-Reply-To: <CAE9FiQX0xeR61ehPy2SfWfN-fgSZVS=dtaWT-QQ+RR12tx+A0w@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2013 12:34 PM, Yinghai Lu wrote:
> 
> The points for parsing SRAT early instead of Yanfei/Tang v7:
> 1. We just reached one unified path to setup page tables for 32bit,
> 64bit and xen or non xen after several years. We should not have add
> another path for system
> that support hotplug.
> 
> 2. also we should avoid adding "movable_nodes" command line.
> 
> 3. debug mapping 4k, and it is working all the way, why breaking it even for
> memory hotplug path?
> 
> 4. numa_meminfo now is static structure.
> we have no reason that we can not parse SRAT etc to fill that struct.
> 
> 5. for device tree, i assume that we could do same like srat parsing to find out
> numa to fill the numa_meminfo early. or with help of BRK.
> 
> 6. in the long run, We should rework our NUMA booting:
> a. boot system with boot numa nodes early only.
> b. in later init stage or user space, init other nodes
> RAM/CPU/PCI...in parallel.
> that will reduce boot time for 8 sockets/32 sockets dramatically.
> 
> We will need to parse srat table early so could avoid init memory for
> non-boot nodes.
> 

I really like the long-term plan (and, I might want to add, the above
writeup.)

However, I don't understand how we can avoid #2, given that it is
fundamentally a sysadmin-driven tradeoff between performance and
reliability.

	-hpa

