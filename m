Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932890Ab3DWWAf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 18:00:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:31566 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757333Ab3DWWAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 18:00:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,537,1363158000"; 
   d="scan'208";a="299972467"
From: "Luck, Tony" <tony.luck@intel.com>
To: Jean Delvare <jdelvare@suse.de>, DuanZhenzhong <zhenzhong.duan@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Yu, Fenghua" <fenghua.yu@intel.com>
Subject: RE: memcpy_fromio in dmi_scan.c
Thread-Topic: memcpy_fromio in dmi_scan.c
Thread-Index: AQHOP/RwacaplR9CdEKkq9gPksW/N5jkWgQA
Date: Tue, 23 Apr 2013 22:00:05 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F1EA52ED3@ORSMSX104.amr.corp.intel.com>
References: <1366636689.4503.35.camel@chaos.site>
	 <5175FF0F.9050206@oracle.com> <1366702122.4667.11.camel@chaos.site>
In-Reply-To: <1366702122.4667.11.camel@chaos.site>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3NM0hIV016390

> I don't have much knowledge about IA64 either. All I see is that while
> x86 implements memcpy_fromio() with memcpy [1], ia64 implements it with
> readb [2]. There must be a reason for that, and I can only suppose that
> memcpy on __iomem pointers doesn't work on IA64. If memcpy doesn't work
> then I can't see memcmp working.

On most platforms readb() just ends up doing a regular dereference of the
address ... so I'd expect that memcmp would work just fine.  The exception
is the old SGI sn2 which end up calling ___sn_readb() ... which does something
weird with sn_dma_flush() after doing the dereference of *addr.  I don't
really understand what is going on here - but I assume that it is for real
PCI iomapped memory, as opposed to random bits of BIOS reserved memory
that we used ioremap() to get a virtual handle on.

Not sure how to test ... what would I run to exercise this code?

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
