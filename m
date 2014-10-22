Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbaJVFod (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 01:44:33 -0400
Received: from [42.62.48.242] ([42.62.48.242]:37942 "EHLO manager.mioffice.cn"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750831AbaJVFob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 01:44:31 -0400
From: =?gb2312?B?1uy71A==?= <zhuhui@xiaomi.com>
To: Pavel Machek <pavel@denx.de>
CC: "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mina86@mina86.com" <mina86@mina86.com>,
        "aneesh.kumar@linux.vnet.ibm.com" <aneesh.kumar@linux.vnet.ibm.com>,
        "iamjoonsoo.kim@lge.com" <iamjoonsoo.kim@lge.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "riel@redhat.com" <riel@redhat.com>,
        "mgorman@suse.de" <mgorman@suse.de>,
        "minchan@kernel.org" <minchan@kernel.org>,
        "nasa4836@gmail.com" <nasa4836@gmail.com>,
        "ddstreet@ieee.org" <ddstreet@ieee.org>,
        "hughd@google.com" <hughd@google.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "rientjes@google.com" <rientjes@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "atomlin@redhat.com" <atomlin@redhat.com>,
        "raistlin@linux.it" <raistlin@linux.it>, "axboe@fb.com" <axboe@fb.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "n-horiguchi@ah.jp.nec.com" <n-horiguchi@ah.jp.nec.com>,
        "k.khlebnikov@samsung.com" <k.khlebnikov@samsung.com>,
        "msalter@redhat.com" <msalter@redhat.com>,
        "deller@gmx.de" <deller@gmx.de>,
        "tangchen@cn.fujitsu.com" <tangchen@cn.fujitsu.com>,
        "ben@decadent.org.uk" <ben@decadent.org.uk>,
        "akinobu.mita@gmail.com" <akinobu.mita@gmail.com>,
        "lauraa@codeaurora.org" <lauraa@codeaurora.org>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "sasha.levin@oracle.com" <sasha.levin@oracle.com>,
        "vdavydov@parallels.com" <vdavydov@parallels.com>,
        "suleiman@google.com" <suleiman@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 1/4] (CMA_AGGRESSIVE) Add CMA_AGGRESSIVE to Kconfig
Thread-Topic: [PATCH 1/4] (CMA_AGGRESSIVE) Add CMA_AGGRESSIVE to Kconfig
Thread-Index: AQHP6PJVlMR9bONqakO6B9lMcs478w==
Date: Wed, 22 Oct 2014 05:44:24 +0000
Message-ID: <2c27ad87839b42ca85c03c9541550d30@cnbox4.mioffice.cn>
References: <1413430551-22392-1-git-send-email-zhuhui@xiaomi.com>
 <1413430551-22392-2-git-send-email-zhuhui@xiaomi.com>
 <201410220126.s9M1Qita026502@spam.xiaomi.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [106.37.216.50]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9M5ic53004559



On 10/22/14 09:27, Pavel Machek wrote:
> Hi!
>
>> Add CMA_AGGRESSIVE config that depend on CMA to Linux kernel config.
>> Add CMA_AGGRESSIVE_PHY_MAX, CMA_AGGRESSIVE_FREE_MIN and CMA_AGGRESSIVE_SHRINK
>> that depend on CMA_AGGRESSIVE.
>>
>> If physical memory size (not include CMA memory) in byte less than or equal to
>> CMA_AGGRESSIVE_PHY_MAX, CMA aggressive switch (sysctl vm.cma-aggressive-switch)
>> will be opened.
>
> Ok...
>
> Do I understand it correctly that there is some problem with
> hibernation not working on machines not working on machines with big
> CMA areas...?

No, these patches want to handle this issue that most of CMA memory is 
not allocated before lowmemorykiller or oom_killer begin to kill tasks.

>
> But adding 4 config options end-user has no chance to set right can
> not be the best solution, can it?
>
>> +config CMA_AGGRESSIVE_PHY_MAX
>> +	hex "Physical memory size in Bytes that auto turn on the CMA aggressive switch"
>> +	depends on CMA_AGGRESSIVE
>> +	default 0x40000000
>> +	help
>> +	  If physical memory size (not include CMA memory) in byte less than or
>> +	  equal to this value, CMA aggressive switch will be opened.
>> +	  After the Linux boot, sysctl "vm.cma-aggressive-switch" can control
>> +	  the CMA AGGRESSIVE switch.
>
> For example... how am I expected to figure right value to place here?

I agree with that.  I will update this config to auto set in next version.

Thanks,
Hui

>
> 									Pavel
>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
