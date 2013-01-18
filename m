Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750939Ab3ARHjF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 02:39:05 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35473 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab3ARHjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 02:39:03 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <50F8FBE9.6040501@jp.fujitsu.com>
Date: Fri, 18 Jan 2013 16:38:17 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, <tony.luck@intel.com>,
        <akpm@linux-foundation.org>, <tangchen@cn.fujitsu.com>,
        <jiang.liu@huawei.com>, <wujianguo@huawei.com>, <wency@cn.fujitsu.com>,
        <laijs@cn.fujitsu.com>, <linfeng@cn.fujitsu.com>, <yinghai@kernel.org>,
        <rob@landley.net>, <minchan.kim@gmail.com>, <mgorman@suse.de>,
        <rientjes@google.com>, <guz.fnst@cn.fujitsu.com>,
        <rusty@rustcorp.com.au>, <lliubbo@gmail.com>,
        <jaegeuk.hanse@gmail.com>, <glommer@parallels.com>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH v5 0/5] Add movablecore_map boot option
References: <1358154925-21537-1-git-send-email-tangchen@cn.fujitsu.com> <50F440F5.3030006@zytor.com> <20130114143456.3962f3bd.akpm@linux-foundation.org> <3908561D78D1C84285E8C5FCA982C28F1C97C2DA@ORSMSX108.amr.corp.intel.com> <20130114144601.1c40dc7e.akpm@linux-foundation.org> <50F647E8.509@jp.fujitsu.com> <20130116132953.6159b673.akpm@linux-foundation.org> <50F72F17.9030805@zytor.com> <50F78750.8070403@jp.fujitsu.com> <50F79422.6090405@zytor.com> <3908561D78D1C84285E8C5FCA982C28F1C986D98@ORSMSX108.amr.corp.intel.com> <50F85ED5.3010003@jp.fujitsu.com> <50F8E63F.5040401@jp.fujitsu.com> <818a2b0a-f471-413f-9231-6167eb2d9607@email.android.com>
In-Reply-To: <818a2b0a-f471-413f-9231-6167eb2d9607@email.android.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/01/18 15:25, H. Peter Anvin wrote:
> We already do DMI parsing in the kernel...

Thank you for giving the infomation.

Is your mention /sys/firmware/dmi/entries?

If so, my box does not have memory information.
My box has only type 0, 1, 2, 3, 4, 7, 8, 9, 38, 127 in DMI.
At least, my box cannot use the information...

If users use the boot parameter for investigating firmware bugs
or debugging, users cannot use DMI information on like my box.

Thanks,
Yasuaki Ishimatsu

>
> Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com> wrote:
>
>> 2013/01/18 5:28, KOSAKI Motohiro wrote:
>>> On 1/17/2013 11:30 AM, Luck, Tony wrote:
>>>>> 2. If the user *does* care which nodes are movable, then the user
>> needs
>>>>> to be able to specify that *in a way that makes sense to the user*.
>>>>> This may mean involving the DMI information as well as SRAT in
>> order to
>>>>> get "silk screen" type information out.
>>>>
>>>> One reason they might care would be which I/O devices are connected
>>>> to each node.  DMI might be a good way to get an invariant name for
>> the
>>>> node, but they might also want to specify in terms of what they
>> actually
>>>> want. E.g. "eth0 and eth4 are a redundant bonded pair of NICs -
>> don't
>>>> mark both these nodes as removable".  Though this is almost
>> certainly not
>>>> a job for kernel options, but for some user configuration tool that
>> would
>>>> spit out the DMI names.
>>>
>>> I agree DMI parsing should be done in userland if we really need DMI
>> parsing.
>>>
>>
>> If users use the boot parameter for bugs or debugging,  users need
>> a method which sets in detail range of movable memory. So specifying
>> node number is not enough because whole memory becomes movable memory.
>>
>> For this, we are discussing other ways, memory range and DMI
>> information.
>> By using DMI information, users may get an invariant name. But is it
>> really user friendly interface? I don't think so.
>>
>> You will think using memory range is not user friendly interface too.
>> But I think that using memory range is friendlier than using DMI
>> information since we can get easily memory range. So from developper
>> side, using memory range is good.
>>
>> Of course, using SRAT information is necessary solution. So we are
>> developing it now.
>>
>> Thanks,
>> Yasuaki Ishimatsu
>


