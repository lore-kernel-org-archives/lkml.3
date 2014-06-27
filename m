Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360AbaF0WKw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 18:10:52 -0400
Received: from mga03.intel.com ([143.182.124.21]:28139 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752844AbaF0WKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 18:10:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,564,1400050800"; 
   d="scan'208";a="450924784"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: Xie XiuQi <xiexiuqi@huawei.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
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
Thread-Index: AQHPkcm24el9M4t/u06Dbv5Xkx8eRZuFJGWAgABIXRCAAH6hgP//mUkQ
Date: Fri, 27 Jun 2014 22:10:48 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F3284C082@ORSMSX114.amr.corp.intel.com>
References: <1382084624-10857-1-git-send-email-gong.chen@linux.intel.com>
 <1382084624-10857-5-git-send-email-gong.chen@linux.intel.com>
 <52612BA4.2060906@linux.vnet.ibm.com> <53AD0275.7020003@huawei.com>
 <20140627092227.GA23153@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F3284BBB1@ORSMSX114.amr.corp.intel.com>
 <20140627211441.GA20305@nazgul.tnic>
In-Reply-To: <20140627211441.GA20305@nazgul.tnic>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5RMB6WI029135

>> Not all machine checks are fatal - it would be bad for us to go into
>> an infinite spin instead of executing the recovery code.
>
> Then for the time being extlog shouldn't hook into the decoder chain
> but into mce_process_work, i.e. the last should call it. Or maybe add
> another notifier which is not atomic...

I spoke too quickly.  The only MCE for which we have recovery code are
those that hit in application code.  So the processor that is trying to do
the printk() can't possibly be holding the locks.  Other processors might
have held the lock at the time of the MCE - but they have all returned 
from the handler at the time we try the printk - so they will make progess
and release the lock so that we can acquire it.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
