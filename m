Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbaF0UnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 16:43:19 -0400
Received: from mga03.intel.com ([143.182.124.21]:63693 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550AbaF0UnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 16:43:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,563,1400050800"; 
   d="scan'208";a="450900159"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>, Xie XiuQi <xiexiuqi@huawei.com>
CC: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "Chen, Gong" <gong.chen@linux.intel.com>,
        "joe@perches.com" <joe@perches.com>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "arozansk@redhat.com" <arozansk@redhat.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Bin <huawei.libin@huawei.com>
Subject: RE: [PATCH v3 4/9] ACPI, x86: Extended error log driver for x86
 platform
Thread-Topic: [PATCH v3 4/9] ACPI, x86: Extended error log driver for x86
 platform
Thread-Index: AQHPkcm24el9M4t/u06Dbv5Xkx8eRZuFJGWAgABIXRA=
Date: Fri, 27 Jun 2014 20:43:14 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F3284BBB1@ORSMSX114.amr.corp.intel.com>
References: <1382084624-10857-1-git-send-email-gong.chen@linux.intel.com>
 <1382084624-10857-5-git-send-email-gong.chen@linux.intel.com>
 <52612BA4.2060906@linux.vnet.ibm.com> <53AD0275.7020003@huawei.com>
 <20140627092227.GA23153@pd.tnic>
In-Reply-To: <20140627092227.GA23153@pd.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5RKhURH028494

>> There's a logbuf_lock in printk. If logbuf_lock is held by other cpu,
>> it'll lead to an infinity spin here. Isn't it?
>
> Yes, but we want to take the risk and print something out before the
> machine dies instead of waiting to get into printk-safe context first
> and maybe corrupt state.

Not all machine checks are fatal - it would be bad for us to go into an
infinite spin instead of executing the recovery code.

> Besides, there's work currently going on to make printk safe in atomic
> context so...

Good - we need this.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
