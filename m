Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757632Ab3APG0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 01:26:24 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38597 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab3APG0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 01:26:23 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <50F647E8.509@jp.fujitsu.com>
Date: Wed, 16 Jan 2013 15:25:44 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Luck, Tony" <tony.luck@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
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
References: <1358154925-21537-1-git-send-email-tangchen@cn.fujitsu.com> <50F440F5.3030006@zytor.com> <20130114143456.3962f3bd.akpm@linux-foundation.org> <3908561D78D1C84285E8C5FCA982C28F1C97C2DA@ORSMSX108.amr.corp.intel.com> <20130114144601.1c40dc7e.akpm@linux-foundation.org>
In-Reply-To: <20130114144601.1c40dc7e.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/01/15 7:46, Andrew Morton wrote:
> On Mon, 14 Jan 2013 22:41:03 +0000
> "Luck, Tony" <tony.luck@intel.com> wrote:
>
>>> hm, why.  Obviously SRAT support will improve things, but is it
>>> actually unusable/unuseful with the command line configuration?
>>
>> Users will want to set these moveable zones along node boundaries
>> (the whole purpose is to be able to remove a node by making sure
>> the kernel won't allocate anything tricky in it, right?)  So raw addresses
>> are usable ... but to get them right the user will have to go parse the
>> SRAT table manually to come up with the addresses. Any time you
>> make the user go off and do some tedious calculation that the computer
>> should have done for them is user-abuse.
>>
>
> Sure.  But SRAT configuration is in progress and the boot option is
> better than nothing?

Yes. I think boot option which specifies memory range is necessary.

>
> Things I'm wondering:
>
> - is there *really* a case for retaining the boot option if/when
>    SRAT support is available?

Yes. If SRAT support is available, all memory which enabled hotpluggable
bit are managed by ZONEMOVABLE. But performance degradation may
occur by NUMA because we can only allocate anonymous page and page-cache
from these memory.

In this case, if user cannot change SRAT information, user needs a way to
select/set removable memory manually.

Thanks,
Yasuaki Ishimatsu

>
> - will the boot option be needed for other archictectures, presumably
>    because they don't provide sufficient layout information to the
>    kernel?
>


