Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759000Ab3HMUOD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 16:14:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:4709 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758094Ab3HMUN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 16:13:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,872,1367996400"; 
   d="scan'208";a="385801371"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "rjw@sisk.pl" <rjw@sisk.pl>, "lance.ortiz@hp.com" <lance.ortiz@hp.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3/3] mce: acpi/apei: trace: Enable ghes memory error
 trace event
Thread-Topic: [PATCH 3/3] mce: acpi/apei: trace: Enable ghes memory error
 trace event
Thread-Index: AQHOlGVcQB6qi1wV3Ei8qYoYEneewpmMKjwAgAMKHwCAArfagIAAEviAgAADVICAAXiUgIAAFsAAgABQygCAAAdFgP//i8NwgAB3kgD//6n/UA==
Date: Tue, 13 Aug 2013 20:13:56 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31CB9150@ORSMSX106.amr.corp.intel.com>
References: <20130808163822.67e0828a@samsung.com>
 <20130810180322.GC4155@pd.tnic> <20130812083355.47c1bae8@samsung.com>
 <5208D80D.5030206@linux.vnet.ibm.com> <20130812125343.GE18018@pd.tnic>
 <520A16BD.30201@linux.vnet.ibm.com> <20130813124258.GC4077@pd.tnic>
 <520A6D98.9060204@linux.vnet.ibm.com> <20130813175809.GE4077@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F31CB8F53@ORSMSX106.amr.corp.intel.com>
 <20130813181004.GF4077@pd.tnic>
In-Reply-To: <20130813181004.GF4077@pd.tnic>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r7DKE8kP001899

> What about sending tracepoint data over serial and/or network? I agree
> that dmesg over serial would be helpful but we need a similar sure-fire
> way for carrying error info out.

Generic tracepoints are architected to be able to fire at very high rates and
log huge amounts of information.  So we'd need something special to say
just log these special tracepoints to network/serial.

> Which reminds me, pstore could also be a good thing to use, in addition.
> Only put error info there as it is limited anyway.

Yes - space is very limited.  I don't know how to assign priority for logging
the dmesg data vs. some error logs.


If we just "printk()" the most important parts - then that data will automatically
flow to the serial console and to pstore.  Then we have multiple paths for the
critical bits of the error log - and the tracepoints give us more details for the
cases where the machine doesn't spontaneously explode.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
