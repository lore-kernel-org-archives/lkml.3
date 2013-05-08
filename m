Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537Ab3EHRX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 13:23:27 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:47040 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756740Ab3EHRXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 13:23:24 -0400
From: "Ortiz, Lance E" <lance.oritz@hp.com>
To: Borislav Petkov <bp@alien8.de>
CC: =?utf-8?B?QnJ1bm8gUHLDqW1vbnQ=?= <bonbons@linux-vserver.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-ACPI <linux-acpi@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tony Luck <tony.luck@intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "Dall, Elizabeth J (MCLinux)" <betty.dall@hp.com>
Subject: RE: WARNING at drivers/pci/search.c:214 for 3.9
Thread-Topic: WARNING at drivers/pci/search.c:214 for 3.9
Thread-Index: AQHOSmT7XmlaV8+Pw0um1uzzkieDY5j4QjGAgABv+XWAAtf9cA==
Date: Wed, 8 May 2013 17:22:24 +0000
Message-ID: <A961433CDFF2F640A2866803152E61F951775BD5@G9W0715.americas.hpqcorp.net>
References: <20130506162112.6b79b7b1@pluto.restena.lu>
 <20130506150757.GC22041@pd.tnic>
 <A961433CDFF2F640A2866803152E61F951772648@G9W0715.americas.hpqcorp.net>
 <20130506214913.GE22041@pd.tnic>
In-Reply-To: <20130506214913.GE22041@pd.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.31]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r48HNbpZ010639

> > The only reason we are calling pci_get_domain_bus_and_slot() is to
> get
> > the pci_dev* to pass into cper_print_aer() so we can have the
> device's
> > name to put into the trace event for AER. If we can find another way
> > to get the device name for the trace event we could remove this call
> > to pci_get_domain_bus_and_slot(). I will continue to look into an
> > alternative. If you have any ideas on how to get the device data from
> > this context let me know.
> 
> Hmm, not sure.
> 
> Off the top of my head, maybe add the whole code around:
> 
> #ifdef CONFIG_ACPI_APEI_PCIEAER
> ...
> 
> #endif
> 
> in cper_print_pcie() into a separate function which is called from a
> workqueue right after the interrupt is done.. Or something to that
> effect.

I am sending out a patch that should fix the warning and remove the call to get_pci* out of interrupt context.  It is called: 

[PATCH] aerdrv: Move cper_print_pcie() out of interrupt context

Please take a look when you get a chance.

Lance
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
