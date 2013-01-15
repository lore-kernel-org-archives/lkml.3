Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618Ab3AOBX5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 20:23:57 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34327 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756944Ab3AOBX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 20:23:56 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <50F4AF88.9090201@jp.fujitsu.com>
Date: Tue, 15 Jan 2013 10:23:20 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Tang Chen <tangchen@cn.fujitsu.com>,
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
References: <1358154925-21537-1-git-send-email-tangchen@cn.fujitsu.com> <50F440F5.3030006@zytor.com> <20130114143456.3962f3bd.akpm@linux-foundation.org> <3908561D78D1C84285E8C5FCA982C28F1C97C2DA@ORSMSX108.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F1C97C2DA@ORSMSX108.amr.corp.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/01/15 7:41, Luck, Tony wrote:
>> hm, why.  Obviously SRAT support will improve things, but is it
>> actually unusable/unuseful with the command line configuration?
>

> Users will want to set these moveable zones along node boundaries
> (the whole purpose is to be able to remove a node by making sure
> the kernel won't allocate anything tricky in it, right?)

Yes

> So raw addresses
> are usable ... but to get them right the user will have to go parse the
> SRAT table manually to come up with the addresses.

I don't think so because user can easily get raw address by kernel
message in x86.

Here are kernel messages of x86 architecture.
---
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0x7fffffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x100000000-0x7ffffffff]
[    0.000000] SRAT: Node 1 PXM 2 [mem 0x1000000000-0x17ffffffff]
[    0.000000] SRAT: Node 2 PXM 3 [mem 0x1800000000-0x1fffffffff]
[    0.000000] SRAT: Node 3 PXM 4 [mem 0x2000000000-0x27ffffffff]
[    0.000000] SRAT: Node 4 PXM 5 [mem 0x2800000000-0x2fffffffff]
[    0.000000] SRAT: Node 5 PXM 6 [mem 0x3000000000-0x37ffffffff]
[    0.000000] SRAT: Node 6 PXM 7 [mem 0x3800000000-0x3fffffffff]
[    0.000000] SRAT: Node 7 PXM 1 [mem 0x800000000-0xfffffffff]
---

Thanks,
Yasuaki Ishimatsu

> Any time you
> make the user go off and do some tedious calculation that the computer
> should have done for them is user-abuse.
>
> -Tony
>


