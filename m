Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab3AQFJl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 00:09:41 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33092 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab3AQFJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 00:09:39 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <50F78750.8070403@jp.fujitsu.com>
Date: Thu, 17 Jan 2013 14:08:32 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        "jiang.liu@huawei.com" <jiang.liu@huawei.com>,
        "wujianguo@huawei.com" <wujianguo@huawei.com>,
        "wency@cn.fujitsu.com" <wency@cn.fujitsu.com>,
        "laijs@cn.fujitsu.com" <laijs@cn.fujitsu.com>,
        "linfeng@cn.fujitsu.com" <linfeng@cn.fujitsu.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "rob@landley.net" <rob@landley.net>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
        "mgorman@suse.de" <mgorman@suse.de>,
        "rientjes@google.com" <rientjes@google.com>,
        "guz.fnst@cn.fujitsu.com" <guz.fnst@cn.fujitsu.com>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "lliubbo@gmail.com" <lliubbo@gmail.com>,
        "jaegeuk.hanse@gmail.com" <jaegeuk.hanse@gmail.com>,
        "glommer@parallels.com" <glommer@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH v5 0/5] Add movablecore_map boot option
References: <1358154925-21537-1-git-send-email-tangchen@cn.fujitsu.com> <50F440F5.3030006@zytor.com> <20130114143456.3962f3bd.akpm@linux-foundation.org> <3908561D78D1C84285E8C5FCA982C28F1C97C2DA@ORSMSX108.amr.corp.intel.com> <20130114144601.1c40dc7e.akpm@linux-foundation.org> <50F647E8.509@jp.fujitsu.com> <20130116132953.6159b673.akpm@linux-foundation.org> <50F72F17.9030805@zytor.com>
In-Reply-To: <50F72F17.9030805@zytor.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/01/17 7:52, H. Peter Anvin wrote:
> On 01/16/2013 01:29 PM, Andrew Morton wrote:
>>>
>>> Yes. If SRAT support is available, all memory which enabled hotpluggable
>>> bit are managed by ZONEMOVABLE. But performance degradation may
>>> occur by NUMA because we can only allocate anonymous page and page-cache
>>> from these memory.
>>>
>>> In this case, if user cannot change SRAT information, user needs a way to
>>> select/set removable memory manually.
>>
>> If I understand this correctly you mean that once SRAT parsing is
>> implemented, the user can use movablecore_map to override that SRAT
>> parsing, yes?  That movablecore_map will take precedence over SRAT?
>>
>
> Yes, but we still need a higher-level user interface which specifies
> which nodes, not which memory ranges, should be movable.

I thought about the method of specifying the node. But I think
this method is inconvenience. Node number is decided by OS.
So the number is changed easily.

for example:

o exmaple 1
   System has 3 nodes:
   node0, node1, node2

   When user remove node1, the system has:
   node0, node2

   But after rebooting the system, the system has:
   node0, node1

   So node2 becomes node1.

o example 2:
   System has 2 nodes:
   0x40000000 - 0x7fffffff : node0
   0xc0000000 - 0xffffffff : node1

   When user add a node wchih memory range is [0x80000000 - 0xbfffffff],
   system has:
   0x40000000 - 0x7fffffff : node0
   0xc0000000 - 0xffffffff : node1
   0x80000000 - 0xbfffffff : node2

   But after rebooting the system, the system's node may become:
   0x40000000 - 0x7fffffff : node0
   0x80000000 - 0xbfffffff : node1
   0xc0000000 - 0xffffffff : node2

   So node nunber is changed.

Specifying node number may be easy method than specifying memory
range. But if user uses node number for specifying removable memory,
user always need to care whether node number is changed or not at
every hotplug operation.

Thanks,
Yasuaki Ishimatsu


> That is the
> policy granularity that is actually appropriate for the administrator
> (trading off performance vs reliability.)
>
> 	-hpa
>


