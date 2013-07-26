Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424Ab3GZD4E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 23:56:04 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:48839 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753924Ab3GZD4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 23:56:01 -0400
X-IronPort-AV: E=Sophos;i="4.89,748,1367942400"; 
   d="scan'208";a="8029947"
Message-ID: <51F1F3F5.9030906@cn.fujitsu.com>
Date: Fri, 26 Jul 2013 11:58:45 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, trenn@suse.de, yinghai@kernel.org,
        jiang.liu@huawei.com, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, izumi.taku@jp.fujitsu.com,
        mgorman@suse.de, minchan@kernel.org, mina86@mina86.com,
        gong.chen@linux.intel.com, vasilis.liaskovitis@profitbricks.com,
        lwoodman@redhat.com, riel@redhat.com, jweiner@redhat.com,
        prarit@redhat.com, zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com,
        x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 17/21] page_alloc, mem-hotplug: Improve movablecore to
 {en|dis}able using SRAT.
References: <1374220774-29974-1-git-send-email-tangchen@cn.fujitsu.com> <1374220774-29974-18-git-send-email-tangchen@cn.fujitsu.com> <20130723210435.GV21100@mtj.dyndns.org> <20130723211119.GW21100@mtj.dyndns.org> <51F0A074.403@cn.fujitsu.com> <20130725150913.GD26107@mtj.dyndns.org>
In-Reply-To: <20130725150913.GD26107@mtj.dyndns.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/26 11:53:54,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/26 11:53:55,
	Serialize complete at 2013/07/26 11:53:55
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2013 11:09 PM, Tejun Heo wrote:
> Hello, Tang.
>
> On Thu, Jul 25, 2013 at 11:50:12AM +0800, Tang Chen wrote:
>> movablecore boot option was used to specify the size of ZONE_MOVABLE. And
>> this patch-set aims to arrange ZONE_MOVABLE with SRAT info. So my original
>> thinking is to reuse movablecore.
>>
>> Since you said above, I think we have two problems here:
>> 1. Should not let users care about where the hotplug info comes from.
>> 2. Should not distinguish movable node and memory hotplug, since for now,
>>     to use memory hotplug is to use movable node.
>>
>> So how about something like "movablenode", just like "quiet" boot option.
>> If users specify "movablenode", then memblock will reserve hotpluggable
>> memory, and create movable nodes if any. If users specify nothing, then
>> the kernel acts as before.
>
> Maybe I'm confused but memory hotplug isn't likely to work without
> this, right?

I don't think so. On x86, I think you are right because we cannot hotplug
a single memory_block (128MB on x86), which is only a small part of a modern
memory device. And now x86 kernel doesn't support a single memory device
hotplug, and what we are trying to do is node hotplug. So on x86, memory
hotplug won't work without movable node.

But on other platform, memory hotplug may work without this.

>If so, wouldn't it make more sense to have
> "memory_hotplug" option rather than "movablecore=acpi" which in no way
> indicates that it has something to do with memory hotplug?

I'm not working on ppcm, but I heard that memory hotplug was introduced 
firstly
on ppc, and a memory_block on ppc is only 16MB, which can be hotplugged. It
doesn't need movable node support.

Here, 16MB memory_block hotplug is not the physical device hotplug, I think.
Just logically remove it from one OS, and add it to another OS running 
on one
ppc server. This is done by the hardware.

But on x86, we don't have this kind of functionality. A single memory_block
hotplug means nothing. Actually I think struct memory_block is useless 
on x86.
But for other platforms, we have to keep this structure.

So for the same reason, I think we cannot just introduce a boot option like
"memory_hotplug" to enable/disable what we are doing in this patch-set.

Sorry I didn't clarify this earlier.

Thanks.
