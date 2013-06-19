Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935047Ab3FSUd6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 16:33:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:65385 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934714Ab3FSUd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 16:33:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,899,1363158000"; 
   d="scan'208";a="332339968"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "ananth@in.ibm.com" <ananth@in.ibm.com>,
        "masbock@linux.vnet.ibm.com" <masbock@linux.vnet.ibm.com>,
        "lcm@linux.vnet.ibm.com" <lcm@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>
Subject: RE: [PATCH v2 2/2] mce: acpi/apei: Add a boot option to disable ff
 mode for corrected errors
Thread-Topic: [PATCH v2 2/2] mce: acpi/apei: Add a boot option to disable ff
 mode for corrected errors
Thread-Index: AQHObRaMG8NLWdbwnkKYI9OOtTgcdZk9yhyA//+MXBCAAHyTAP//kUdQgACKGAD//4yfcA==
Date: Wed, 19 Jun 2013 20:33:49 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F2DA8838B@ORSMSX106.amr.corp.intel.com>
References: <20130619175438.2852.93449.stgit@localhost.localdomain>
 <20130619175728.2852.73156.stgit@localhost.localdomain>
 <20130619180441.GK28300@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F2DA88106@ORSMSX106.amr.corp.intel.com>
 <20130619183640.GL28300@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F2DA881C2@ORSMSX106.amr.corp.intel.com>
 <20130619201438.GM28300@pd.tnic>
In-Reply-To: <20130619201438.GM28300@pd.tnic>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5JKY6LS012585

>> There is (or should be)
>
> Ha!

Oh ye of little faith - I'm sure the BIOS will get this right this time :-)


> Ok, seriously: so the situation should still be fine, FF reported errors
> get the CPER format while the rest, the "old" MCE format.
>
> cper.c is doing printk so I'm guessing it would need to get its own
> tracepoint and carry that to userspace.

Yes - a tracepoint is the right answer here for all the new stuff.

> Concerning the RAS daemon, Robert and I are making good progress so once
> we have the persistent events in perf, we can read that tracepoint in
> userspace and do whatever we want with the error info.

Mauro has a rasdaemon in progress
       git://git.fedorahosted.org/rasdaemon.git
just picks up perf/events and logs to a sqlite database.

>> In this new modern world - Naveen wants to have the BIOS decide the
>> threshold, so we'd like Linux to take some action as soon as it sees
>> just one CPER.
>
> Why would Linux have to intervene if it is doing FF - wasn't the deal
> behind Firmware First for the firmware to get the error first and handle
> accordingly?

Because Linux can do runtime things that the BIOS can't - like offline a 4K page.
Idea here is that BIOS does whatever the OEM thinks is the right level of
threshholding - not bothering the OS with petty details of random corrected
erorrs that mean nothing.  But if there is some repeated error (like a stuck bit)
then the BIOS can provide a CPER to the OS telling it that it would be a good idea
to stop using that page.

And this is where the semantics of a CPER change between the original WSM-EX
implementation ... where Linux expects to see all the errors and do its own
thresholding only taking a page offline if it sees a lot of CPER refer to the same
page; and now - where the BIOS does the counting and tells Linux just once to
take the page offline.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
