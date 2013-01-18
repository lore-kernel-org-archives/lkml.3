Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859Ab3ARS3W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 13:29:22 -0500
Received: from mga03.intel.com ([143.182.124.21]:15597 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332Ab3ARS3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 13:29:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,494,1355126400"; 
   d="scan'208";a="245713300"
From: "Luck, Tony" <tony.luck@intel.com>
To: li guang <lig.fnst@cn.fujitsu.com>, Tang Chen <tangchen@cn.fujitsu.com>
CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "jiang.liu@huawei.com" <jiang.liu@huawei.com>,
        "wujianguo@huawei.com" <wujianguo@huawei.com>,
        "wency@cn.fujitsu.com" <wency@cn.fujitsu.com>,
        "laijs@cn.fujitsu.com" <laijs@cn.fujitsu.com>,
        "linfeng@cn.fujitsu.com" <linfeng@cn.fujitsu.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "rob@landley.net" <rob@landley.net>,
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
Subject: RE: [PATCH v5 0/5] Add movablecore_map boot option
Thread-Topic: [PATCH v5 0/5] Add movablecore_map boot option
Thread-Index: AQHN8jfezP7hxPPawkaXDMerNaAcgJhJm6qAgABUxAD//3o84IAAiNyAgAISxwCAAPydgIAAFvqAgABpLACAAA9IAIAAJ0zwgADKV4CAAKFtgIAABXIAgAAUYYCAAAhoAIAAFReAgAAPwlA=
Date: Fri, 18 Jan 2013 18:29:17 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F1C988096@ORSMSX108.amr.corp.intel.com>
References: <1358154925-21537-1-git-send-email-tangchen@cn.fujitsu.com>
	 <50F440F5.3030006@zytor.com>
	 <20130114143456.3962f3bd.akpm@linux-foundation.org>
	 <3908561D78D1C84285E8C5FCA982C28F1C97C2DA@ORSMSX108.amr.corp.intel.com>
	 <20130114144601.1c40dc7e.akpm@linux-foundation.org>
	 <50F647E8.509@jp.fujitsu.com>
	 <20130116132953.6159b673.akpm@linux-foundation.org>
	 <50F72F17.9030805@zytor.com> <50F78750.8070403@jp.fujitsu.com>
	 <50F79422.6090405@zytor.com>
	 <3908561D78D1C84285E8C5FCA982C28F1C986D98@ORSMSX108.amr.corp.intel.com>
	 <50F85ED5.3010003@jp.fujitsu.com> <50F8E63F.5040401@jp.fujitsu.com>
	 <818a2b0a-f471-413f-9231-6167eb2d9607@email.android.com>
	 <50F8FBE9.6040501@jp.fujitsu.com>  <50F902F6.5010605@cn.fujitsu.com>
 <1358501031.22331.10.camel@liguang.fnst.cn.fujitsu.com>
In-Reply-To: <1358501031.22331.10.camel@liguang.fnst.cn.fujitsu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0IITLQV006413

> kernel absolutely should not care much about SMBIOS(DMI info),
> AFAIK, every BIOS vendor did not fill accurate info in SMBIOS,
> mostly only on demand when OEMs required SMBIOS to report some
> specific info.
> furthermore, SMBIOS is so old and benifit nobody(in my personal
> opinion), so maybe let's forget it.

The "not having right information" flaw could be fixed by OEMs selling
systems on which it is important for system functionality that it be right.
They could use monetary incentives, contractual obligations, or sharp
pointy sticks to make their BIOS vendor get the table right.

BUT there is a bigger flaw - SMBIOS is a static table with no way to
update it in response to hotplug events.  So it could in theory have the
right information at boot time ... there is no possible way for it to be
right as soon as somebody adds, removes or replaces hardware.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
