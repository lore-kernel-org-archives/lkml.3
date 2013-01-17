Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544Ab3AQUVA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 15:21:00 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48376 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755742Ab3AQUU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 15:20:59 -0500
Message-ID: <50F85D25.6030003@jp.fujitsu.com>
Date: Thu, 17 Jan 2013 15:20:53 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: tangchen@cn.fujitsu.com
CC: hpa@zytor.com, akpm@linux-foundation.org, isimatu.yasuaki@jp.fujitsu.com,
        tony.luck@intel.com, jiang.liu@huawei.com, wujianguo@huawei.com,
        wency@cn.fujitsu.com, laijs@cn.fujitsu.com, linfeng@cn.fujitsu.com,
        yinghai@kernel.org, rob@landley.net, kosaki.motohiro@jp.fujitsu.com,
        minchan.kim@gmail.com, mgorman@suse.de, rientjes@google.com,
        guz.fnst@cn.fujitsu.com, rusty@rustcorp.com.au, lliubbo@gmail.com,
        jaegeuk.hanse@gmail.com, glommer@parallels.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v5 0/5] Add movablecore_map boot option
References: <1358154925-21537-1-git-send-email-tangchen@cn.fujitsu.com> <50F440F5.3030006@zytor.com> <20130114143456.3962f3bd.akpm@linux-foundation.org> <3908561D78D1C84285E8C5FCA982C28F1C97C2DA@ORSMSX108.amr.corp.intel.com> <20130114144601.1c40dc7e.akpm@linux-foundation.org> <50F647E8.509@jp.fujitsu.com> <20130116132953.6159b673.akpm@linux-foundation.org> <50F72F17.9030805@zytor.com> <50F758BC.5070308@cn.fujitsu.com>
In-Reply-To: <50F758BC.5070308@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/16/2013 8:49 PM, Tang Chen wrote:
> On 01/17/2013 06:52 AM, H. Peter Anvin wrote:
>> On 01/16/2013 01:29 PM, Andrew Morton wrote:
>>>>
>>>> Yes. If SRAT support is available, all memory which enabled hotpluggable
>>>> bit are managed by ZONEMOVABLE. But performance degradation may
>>>> occur by NUMA because we can only allocate anonymous page and page-cache
>>>> from these memory.
>>>>
>>>> In this case, if user cannot change SRAT information, user needs a way to
>>>> select/set removable memory manually.
>>>
>>> If I understand this correctly you mean that once SRAT parsing is
>>> implemented, the user can use movablecore_map to override that SRAT
>>> parsing, yes?  That movablecore_map will take precedence over SRAT?
>>>
>>
>> Yes,
> 
> Hi HPA, Andrew,
> 
> No, I don't think so. In my [PATCH v4 3/6], I checked if users specified the
> unhotpluggable memory ranges, I will remove them from movablecore_map.map[].
> So this option will not override SRAT.
> 
> It works like this:
> 
>     hotpluggable ranges:            |-----------------|
>     unhotpluggable ranges:  |-----|                      |--------|
>     user specified ranges:   |---|       |--------------------|
>     movablecore_map.map[]:               |------------|
> 
> Please refer to https://lkml.org/lkml/2012/12/19/53.
> 
> But in this v5 patch-set, I remove all SRAT related code. So this v5 users'
> option will override SRAT.

Again, boot option is often used for workaround of firmware bugs. so, if you
make a boot option, it should be override firmware info.



