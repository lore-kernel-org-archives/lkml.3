Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab3AaJpF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 04:45:05 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:27608 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752950Ab3AaJo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 04:44:59 -0500
X-IronPort-AV: E=Sophos;i="4.84,575,1355068800"; 
   d="scan'208";a="6671513"
Message-ID: <510A3CE6.202@cn.fujitsu.com>
Date: Thu, 31 Jan 2013 17:44:06 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Simon Jeons <simon.jeons@gmail.com>
CC: akpm@linux-foundation.org, rientjes@google.com, len.brown@intel.com,
        benh@kernel.crashing.org, paulus@samba.org, cl@linux.com,
        minchan.kim@gmail.com, kosaki.motohiro@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, wujianguo@huawei.com,
        wency@cn.fujitsu.com, hpa@zytor.com, linfeng@cn.fujitsu.com,
        laijs@cn.fujitsu.com, mgorman@suse.de, yinghai@kernel.org,
        glommer@parallels.com, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-acpi@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-ia64@vger.kernel.org,
        cmetcalf@tilera.com, sparclinux@vger.kernel.org
Subject: Re: [PATCH v6 00/15] memory-hotplug: hot-remove physical memory
References: <1357723959-5416-1-git-send-email-tangchen@cn.fujitsu.com>    <1359463973.1624.15.camel@kernel> <5108F2B3.3090506@cn.fujitsu.com>   <1359595344.1557.13.camel@kernel> <5109E59F.5080104@cn.fujitsu.com>  <1359613162.1587.0.camel@kernel> <510A18FA.2010107@cn.fujitsu.com> <1359622123.1391.19.camel@kernel>
In-Reply-To: <1359622123.1391.19.camel@kernel>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/31 17:43:43,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/31 17:43:47,
	Serialize complete at 2013/01/31 17:43:47
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Simon,

On 01/31/2013 04:48 PM, Simon Jeons wrote:
> Hi Tang,
> On Thu, 2013-01-31 at 15:10 +0800, Tang Chen wrote:
>
> 1. IIUC, there is a button on machine which supports hot-remove memory,
> then what's the difference between press button and echo to /sys?

No important difference, I think. Since I don't have the machine you are
saying, I cannot surely answer you. :)
AFAIK, pressing the button means trigger the hotplug from hardware, sysfs
is just another entrance. At last, they will run into the same code.

> 2. Since kernel memory is linear mapping(I mean direct mapping part),
> why can't put kernel direct mapping memory into one memory device, and
> other memory into the other devices?

We cannot do that because in that way, we will lose NUMA performance.

If you know NUMA, you will understand the following example:

node0:                    node1:
    cpu0~cpu15                cpu16~cpu31
    memory0~memory511         memory512~memory1023

cpu16~cpu31 access memory16~memory1023 much faster than memory0~memory511.
If we set direct mapping area in node0, and movable area in node1, then
the kernel code running on cpu16~cpu31 will have to access 
memory0~memory511.
This is a terrible performance down.

>As you know x86_64 don't need
> highmem, IIUC, all kernel memory will linear mapping in this case. Is my
> idea available? If is correct, x86_32 can't implement in the same way
> since highmem(kmap/kmap_atomic/vmalloc) can map any address, so it's
> hard to focus kernel memory on single memory device.

Sorry, I'm not quite familiar with x86_32 box.

> 3. In current implementation, if memory hotplug just need memory
> subsystem and ACPI codes support? Or also needs firmware take part in?
> Hope you can explain in details, thanks in advance. :)

We need firmware take part in, such as SRAT in ACPI BIOS, or the firmware
based memory migration mentioned by Liu Jiang.

So far, I only know this. :)

> 4. What's the status of memory hotplug? Apart from can't remove kernel
> memory, other things are fully implementation?

I think the main job is done for now. And there are still bugs to fix.
And this functionality is not stable.

Thanks. :)
