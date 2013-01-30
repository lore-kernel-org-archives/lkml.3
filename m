Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab3A3JGI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 04:06:08 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:16495 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753146Ab3A3JGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 04:06:00 -0500
X-IronPort-AV: E=Sophos;i="4.84,567,1355068800"; 
   d="scan'208";a="6665446"
Message-ID: <5108E245.9060501@cn.fujitsu.com>
Date: Wed, 30 Jan 2013 17:05:09 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: akpm@linux-foundation.org, jiang.liu@huawei.com, wujianguo@huawei.com,
        hpa@zytor.com, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        linfeng@cn.fujitsu.com, yinghai@kernel.org,
        isimatu.yasuaki@jp.fujitsu.com, rob@landley.net,
        kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, mgorman@suse.de,
        guz.fnst@cn.fujitsu.com, rusty@rustcorp.com.au, lliubbo@gmail.com,
        jaegeuk.hanse@gmail.com, tony.luck@intel.com, glommer@parallels.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH Bug fix] acpi, movablemem_map: node0 should always be
 unhotpluggable when using SRAT.
References: <1359532470-28874-1-git-send-email-tangchen@cn.fujitsu.com> <alpine.DEB.2.00.1301300049100.19679@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1301300049100.19679@chino.kir.corp.google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/30 17:04:47,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/30 17:04:50,
	Serialize complete at 2013/01/30 17:04:50
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2013 04:50 PM, David Rientjes wrote:
> On Wed, 30 Jan 2013, Tang Chen wrote:
>
>> When using movablemem_map=acpi, always set node0 as unhotpluggable, otherwise
>> if all the memory is hotpluggable, the kernel will fail to boot.
>>
>> When using movablemem_map=nn[KMG]@ss[KMG], we don't stop users specifying
>> node0 as hotpluggable, and ignore all the info in SRAT, so that this option
>> can be used as a workaround of firmware bugs.
>>
>
> Could you elaborate on the failure you're seeing?
>
> I've booted the kernel many times without memory on a node 0.
>

Hi David,

The failure I'm trying to fix is that if all the memory is hotpluggable, 
and user
specified movablemem_map, my code will set all the memory as 
ZONE_MOVABLE, and kernel
will fail to allocate any memory, and it will fail to boot.

But I'm sorry if I didn't answer your question. :)

Are you saying your memory is not on node0, and your physical address
0x0 is not on node0 ? And your /sys fs don't have a node0 interface, it is
node1 or something else ?

If so, I think I'd better find another way to fix this problem because 
node0 may not be
the first node on the system.

Thanks. :)
