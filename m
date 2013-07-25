Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab3GYDre (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 23:47:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:34935 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753484Ab3GYDrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 23:47:31 -0400
X-IronPort-AV: E=Sophos;i="4.89,740,1367942400"; 
   d="scan'208";a="8015253"
Message-ID: <51F0A074.403@cn.fujitsu.com>
Date: Thu, 25 Jul 2013 11:50:12 +0800
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
References: <1374220774-29974-1-git-send-email-tangchen@cn.fujitsu.com> <1374220774-29974-18-git-send-email-tangchen@cn.fujitsu.com> <20130723210435.GV21100@mtj.dyndns.org> <20130723211119.GW21100@mtj.dyndns.org>
In-Reply-To: <20130723211119.GW21100@mtj.dyndns.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/25 11:45:23,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/25 11:45:26,
	Serialize complete at 2013/07/25 11:45:26
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2013 05:11 AM, Tejun Heo wrote:
> On Tue, Jul 23, 2013 at 05:04:35PM -0400, Tejun Heo wrote:
>> On Fri, Jul 19, 2013 at 03:59:30PM +0800, Tang Chen wrote:
>> ...
>>> Users can specify "movablecore=acpi" in kernel commandline to enable this
>>> functionality. For those who don't use memory hotplug or who don't want
>>> to lose their NUMA performance, just don't specify anything. The kernel
>>> will work as before.
>>
>> The param name is pretty obscure and why would the user care where
>
> I mean, having movable zone is required for having any decent chance
> of memory hotplug and movable zone implies worse affinity for kernel
> data structures, so there's no point in distinguishing memory hotplug
> enable/disable and this, right?
>

Sorry, I don't quite get this.

By movable zone, do you mean movable node (which has ZONE_MOVABLE only) ?


movablecore boot option was used to specify the size of ZONE_MOVABLE. And
this patch-set aims to arrange ZONE_MOVABLE with SRAT info. So my original
thinking is to reuse movablecore.

Since you said above, I think we have two problems here:
1. Should not let users care about where the hotplug info comes from.
2. Should not distinguish movable node and memory hotplug, since for now,
    to use memory hotplug is to use movable node.

So how about something like "movablenode", just like "quiet" boot option.
If users specify "movablenode", then memblock will reserve hotpluggable
memory, and create movable nodes if any. If users specify nothing, then
the kernel acts as before.

Thanks.
