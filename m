Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373Ab3E3OFx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 10:05:53 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:26117 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087Ab3E3OFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 10:05:43 -0400
From: "Ortiz, Lance E" <lance.oritz@hp.com>
To: Steven Rostedt <rostedt@goodmis.org>, Borislav Petkov <bp@alien8.de>
CC: "Luck, Tony" <tony.luck@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "lance_ortiz@hotmail.com" <lance_ortiz@hotmail.com>,
        "jiang.liu@huawei.com" <jiang.liu@huawei.com>,
        "mchehab@redhat.com" <mchehab@redhat.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3] aerdrv: Move cper_print_aer() call out of interrupt
 context
Thread-Topic: [PATCH v3] aerdrv: Move cper_print_aer() call out of interrupt
 context
Thread-Index: AQHOXL6xaJHLIdYYMUCf//A2tjAxCpkcyS2AgACME3GAAGbRAIAABCGg
Date: Thu, 30 May 2013 14:04:42 +0000
Message-ID: <A961433CDFF2F640A2866803152E61F95D13A762@G9W0715.americas.hpqcorp.net>
References: <20130529190326.24171.86905.stgit@grignak.americas.hpqcorp.net>
	 <30463843.EmBn1xaq3I@vostro.rjw.lan>
	 <3908561D78D1C84285E8C5FCA982C28F2DA70112@ORSMSX106.amr.corp.intel.com>
	 <A961433CDFF2F640A2866803152E61F95D13A6F2@G9W0715.americas.hpqcorp.net>
	 <20130530072849.GA20793@pd.tnic>
 <1369921028.26799.4.camel@gandalf.local.home>
In-Reply-To: <1369921028.26799.4.camel@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.17]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4UE5uvo017823

> >
> > Sounds to me, this TODO item should be on your TODO list - not in
> kernel
> > sources :-)
> >
> 
> Also, that TODO sounds like there's output to userspace that can be
> parsed by a userspace tool. If a tool expects the current format, it
> may
> not be acceptable to change it later.
> 
> If the contents of this patch has nothing to do with the TODO, then
> leave it out. It just confuses things.

Steve, you do have a good point here.  I am wondering if that is why we should consider changing the output to match aer_print_error().  The code path to aer_print_error() is the more common path where not as many platforms support the cper_print_error() path (firmware first AER).  So it is more likely that any tools written would know how to parse the output from aer_print_error().  It would be good for those tools to support firmware first AER when it becomes more common.  Of course this is purely conjecture.  I have no idea if there are any tools that parse this text output.

Lance
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
