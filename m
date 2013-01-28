Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751067Ab3A1CH5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 21:07:57 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49286 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750710Ab3A1CH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 21:07:56 -0500
X-IronPort-AV: E=Sophos;i="4.84,549,1355068800"; 
   d="scan'208";a="6651371"
Message-ID: <5105DD4B.9020901@cn.fujitsu.com>
Date: Mon, 28 Jan 2013 10:07:07 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Andrew Morton <akpm@linux-foundation.org>, jiang.liu@huawei.com,
        wujianguo@huawei.com, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        linfeng@cn.fujitsu.com, yinghai@kernel.org,
        isimatu.yasuaki@jp.fujitsu.com, rob@landley.net,
        kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, mgorman@suse.de,
        rientjes@google.com, guz.fnst@cn.fujitsu.com, rusty@rustcorp.com.au,
        lliubbo@gmail.com, jaegeuk.hanse@gmail.com, tony.luck@intel.com,
        glommer@parallels.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 3/3] acpi, memory-hotplug: Support getting hotplug info
 from SRAT.
References: <1359106929-3034-1-git-send-email-tangchen@cn.fujitsu.com> <1359106929-3034-4-git-send-email-tangchen@cn.fujitsu.com> <20130125171230.34c5a273.akpm@linux-foundation.org> <51033186.3000706@zytor.com>
In-Reply-To: <51033186.3000706@zytor.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/28 10:06:50,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/28 10:06:51,
	Serialize complete at 2013/01/28 10:06:51
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2013 09:29 AM, H. Peter Anvin wrote:
> On 01/25/2013 05:12 PM, Andrew Morton wrote:
>> On Fri, 25 Jan 2013 17:42:09 +0800
>> Tang Chen<tangchen@cn.fujitsu.com>  wrote:
>>
>>> NOTE: Using this way will cause NUMA performance down because the whole node
>>>        will be set as ZONE_MOVABLE, and kernel cannot use memory on it.
>>>        If users don't want to lose NUMA performance, just don't use it.
>>
>> I agree with this, but it means that nobody will test any of your new code.
>>
>> To get improved testing coverage, can you think of any temporary
>> testing-only patch which will cause testers to exercise the
>> memory-hotplug changes?
>>
>
> There is another problem: if ALL the nodes in the system support
> hotpluggable memory, what happens?
>

Hi HPA,

I think I missed this case. If all the memory is hotpluggable, and user 
specified
movablemem_map=acpi, all the memory could be set as movable, and the 
kernel will
fail to start.

I will post a patch to fix it. How about always keep node0 unhotpluggable ?

Thanks. :)
