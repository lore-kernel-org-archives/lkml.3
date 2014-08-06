Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113AbaHFNO0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 09:14:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:50175 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549AbaHFNOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 09:14:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,811,1400050800"; 
   d="scan'208";a="554575002"
From: "Lan, Tianyu" <tianyu.lan@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "toshi.kani@hp.com" <toshi.kani@hp.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "jan.kiszka@siemens.com" <jan.kiszka@siemens.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "huawei.libin@huawei.com" <huawei.libin@huawei.com>,
        "prarit@redhat.com" <prarit@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brandt, Todd E" <todd.e.brandt@intel.com>
Subject: RE: [PATCH] X86/CPU: Avoid 100ms sleep for cpu offline  during S3
Thread-Topic: [PATCH] X86/CPU: Avoid 100ms sleep for cpu offline  during S3
Thread-Index: AQHPr8KvpaX7HAgFk0W7O5vf/xRx7pu/toGAgAGXe4D//9FOgIAAoKYAgAEnvgCAAKebMA==
Date: Wed, 6 Aug 2014 13:13:21 +0000
Message-ID: <4CFBC02C07DA244CA19D6815A05BE6EE0119E1CF@SHSMSX103.ccr.corp.intel.com>
References: <1407142742-29202-1-git-send-email-tianyu.lan@intel.com>
 <20140804102301.GB4808@pd.tnic> <53E04457.2060507@intel.com>
 <20140805075419.GA18234@pd.tnic> <53E0A3EE.50708@intel.com>
 <20140806110748.GC27033@pd.tnic>
In-Reply-To: <20140806110748.GC27033@pd.tnic>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s76DEYAF011245

Have you tried my attached kernel config file? When someone reported
the issue to me, I also was very hard to reproduce the issue by my own config
file. Maybe once 100 tries. But I can reproduced the issue every time with
the attached configure file on several my machines and even on server.

-----Original Message-----
From: Borislav Petkov [mailto:bp@alien8.de] 
Sent: Wednesday, August 06, 2014 7:08 PM
To: Lan, Tianyu
Cc: tglx@linutronix.de; mingo@redhat.com; hpa@zytor.com; x86@kernel.org; toshi.kani@hp.com; imammedo@redhat.com; jan.kiszka@siemens.com; mingo@kernel.org; huawei.libin@huawei.com; prarit@redhat.com; linux-kernel@vger.kernel.org; Brandt, Todd E
Subject: Re: [PATCH] X86/CPU: Avoid 100ms sleep for cpu offline during S3

On Tue, Aug 05, 2014 at 05:29:18PM +0800, Lan Tianyu wrote:
> I think you can pull Tod's tool from git hub and do test from your 
> laptop. I attached a configure file come from ubuntu which is easier 
> to produce the issue. You can use it to reproduce the issue.

Right, so I ran it on an old dualcore AMD laptop I have lying around here and it didn't show any difference with or without your patch.

For all 4 runs I did with the tool running it without any arguments (so it did the default thing), I got suspend time for CPU1 of 4-6 msec and resume of ~20msec.

I don't know whether it is the dual core or AMD but your patch doesn't change anything on that laptop which is ok, I'd guess.

> Ok. BTW, I have tested it on the Ivbridge and Haswell machines.

Yeah, add those numbers to the commit message too.

Thanks.

--
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
