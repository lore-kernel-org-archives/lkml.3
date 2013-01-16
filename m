Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030Ab3APWB1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 17:01:27 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48848 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028Ab3APWB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 17:01:26 -0500
Message-ID: <50F72333.60200@jp.fujitsu.com>
Date: Wed, 16 Jan 2013 17:01:23 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: isimatu.yasuaki@jp.fujitsu.com, tony.luck@intel.com, hpa@zytor.com,
        tangchen@cn.fujitsu.com, jiang.liu@huawei.com, wujianguo@huawei.com,
        wency@cn.fujitsu.com, laijs@cn.fujitsu.com, linfeng@cn.fujitsu.com,
        yinghai@kernel.org, rob@landley.net, kosaki.motohiro@jp.fujitsu.com,
        minchan.kim@gmail.com, mgorman@suse.de, rientjes@google.com,
        guz.fnst@cn.fujitsu.com, rusty@rustcorp.com.au, lliubbo@gmail.com,
        jaegeuk.hanse@gmail.com, glommer@parallels.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v5 0/5] Add movablecore_map boot option
References: <1358154925-21537-1-git-send-email-tangchen@cn.fujitsu.com> <50F440F5.3030006@zytor.com> <20130114143456.3962f3bd.akpm@linux-foundation.org> <3908561D78D1C84285E8C5FCA982C28F1C97C2DA@ORSMSX108.amr.corp.intel.com> <20130114144601.1c40dc7e.akpm@linux-foundation.org> <50F647E8.509@jp.fujitsu.com> <20130116132953.6159b673.akpm@linux-foundation.org>
In-Reply-To: <20130116132953.6159b673.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/16/2013 4:29 PM, Andrew Morton wrote:
> On Wed, 16 Jan 2013 15:25:44 +0900
> Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com> wrote:
> 
>>>
>>> Things I'm wondering:
>>>
>>> - is there *really* a case for retaining the boot option if/when
>>>    SRAT support is available?
>>
>> Yes. If SRAT support is available, all memory which enabled hotpluggable
>> bit are managed by ZONEMOVABLE. But performance degradation may
>> occur by NUMA because we can only allocate anonymous page and page-cache
>> from these memory.
>>
>> In this case, if user cannot change SRAT information, user needs a way to
>> select/set removable memory manually.
> 
> If I understand this correctly you mean that once SRAT parsing is
> implemented, the user can use movablecore_map to override that SRAT
> parsing, yes?  That movablecore_map will take precedence over SRAT?

I think movablecore_map (I prefer movablemem than it, btw) should behave so.
because of, for past three years, almost all memory hotplug bug was handled
only I and kamezawa-san and, afaik, both don't have hotremove aware specific
hardware.

So, if the new feature require specific hardware, we can't maintain this area
any more.


