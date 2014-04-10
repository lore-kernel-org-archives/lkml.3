Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030285AbaDJSel (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 14:34:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:1648 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752308AbaDJSei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 14:34:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,835,1389772800"; 
   d="scan'208";a="518683309"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: Matt Fleming <matt@console-pimps.org>,
        linux-efi <linux-efi@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: RE: df36ac1bc2a16 ("pstore: Don't allow high traffic options on
 fragile devices")
Thread-Topic: df36ac1bc2a16 ("pstore: Don't allow high traffic options on
 fragile devices")
Thread-Index: AQHPVOjU8PI+v/Id9EWF0yDpVxFbXZsLK99w
Date: Thu, 10 Apr 2014 18:34:34 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31E2465C@ORSMSX106.amr.corp.intel.com>
References: <20140410181503.GA4704@pd.tnic>
In-Reply-To: <20140410181503.GA4704@pd.tnic>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3AIYkY7029621

> Even though those nvram devices are fragile and can only stomach a
> limited amount of writes, wouldn't it be a nifty feature to have a
> kernel cmdline param of the sort "put_dmesg_in_nvram_this_one_time_only"
> which logs to nvram only once for debugging purposes.

Speed is also a factor ... waiting for flash to update for each printk()
would mess up timing so much that you might not see the problem
you are chasing.

A better EFI trick for this would be "capsules".  They live in regular RAM
and BIOS firmware does stuff with them at warm reset time.  Matt has
been looking at them - but BIOS support for them seems sketchy to none
right now.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
