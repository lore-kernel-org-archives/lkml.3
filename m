Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944Ab3AODqF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 22:46:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33855 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085Ab3AODqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 22:46:03 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <50F4AF88.9090201@jp.fujitsu.com>
References: <1358154925-21537-1-git-send-email-tangchen@cn.fujitsu.com> <50F440F5.3030006@zytor.com> <20130114143456.3962f3bd.akpm@linux-foundation.org> <3908561D78D1C84285E8C5FCA982C28F1C97C2DA@ORSMSX108.amr.corp.intel.com> <50F4AF88.9090201@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 0/5] Add movablecore_map boot option
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 14 Jan 2013 19:44:32 -0800
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Luck, Tony" <tony.luck@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
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
Message-ID: <f0b491ad-e520-4b32-8506-1a85a15b2924@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That *is* user abuse.

Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com> wrote:

>2013/01/15 7:41, Luck, Tony wrote:
>>> hm, why.  Obviously SRAT support will improve things, but is it
>>> actually unusable/unuseful with the command line configuration?
>>
>
>> Users will want to set these moveable zones along node boundaries
>> (the whole purpose is to be able to remove a node by making sure
>> the kernel won't allocate anything tricky in it, right?)
>
>Yes
>
>> So raw addresses
>> are usable ... but to get them right the user will have to go parse
>the
>> SRAT table manually to come up with the addresses.
>
>I don't think so because user can easily get raw address by kernel
>message in x86.
>
>Here are kernel messages of x86 architecture.
>---
>[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0x7fffffff]
>[    0.000000] SRAT: Node 0 PXM 0 [mem 0x100000000-0x7ffffffff]
>[    0.000000] SRAT: Node 1 PXM 2 [mem 0x1000000000-0x17ffffffff]
>[    0.000000] SRAT: Node 2 PXM 3 [mem 0x1800000000-0x1fffffffff]
>[    0.000000] SRAT: Node 3 PXM 4 [mem 0x2000000000-0x27ffffffff]
>[    0.000000] SRAT: Node 4 PXM 5 [mem 0x2800000000-0x2fffffffff]
>[    0.000000] SRAT: Node 5 PXM 6 [mem 0x3000000000-0x37ffffffff]
>[    0.000000] SRAT: Node 6 PXM 7 [mem 0x3800000000-0x3fffffffff]
>[    0.000000] SRAT: Node 7 PXM 1 [mem 0x800000000-0xfffffffff]
>---
>
>Thanks,
>Yasuaki Ishimatsu
>
>> Any time you
>> make the user go off and do some tedious calculation that the
>computer
>> should have done for them is user-abuse.
>>
>> -Tony
>>

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
