Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351Ab3FSSTk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:19:40 -0400
Received: from mga14.intel.com ([143.182.124.37]:54751 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756845Ab3FSSTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:19:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,899,1363158000"; 
   d="scan'208";a="257343846"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
CC: "ananth@in.ibm.com" <ananth@in.ibm.com>,
        "masbock@linux.vnet.ibm.com" <masbock@linux.vnet.ibm.com>,
        "lcm@linux.vnet.ibm.com" <lcm@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>
Subject: RE: [PATCH v2 2/2] mce: acpi/apei: Add a boot option to disable ff
 mode for corrected errors
Thread-Topic: [PATCH v2 2/2] mce: acpi/apei: Add a boot option to disable ff
 mode for corrected errors
Thread-Index: AQHObRaMG8NLWdbwnkKYI9OOtTgcdZk9yhyA//+MXBA=
Date: Wed, 19 Jun 2013 18:19:25 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F2DA88106@ORSMSX106.amr.corp.intel.com>
References: <20130619175438.2852.93449.stgit@localhost.localdomain>
 <20130619175728.2852.73156.stgit@localhost.localdomain>
 <20130619180441.GK28300@pd.tnic>
In-Reply-To: <20130619180441.GK28300@pd.tnic>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5JIJl5r011466

> Interesting, why? Why would we even need such an option? My impression
> is, if ACPI tells us FF, MCE code doesn't poll those banks anymore. So
> where do the duplicated reports come from?

The option is only disabling the Linux side of firmware first ... the BIOS
will still be doing it and generating records to feed to the OS using APEI.

So Linux may see the error in a bank and report it, and BIOS may report
the same error.  Though I'd expect that to be rare as whoever saw it first
would most likely clear the bank before the other could see it.

I asked for the option because I'm nervous about just skipping some banks
on the say-so of the BIOS ... what if the BIOS did something wrong. This
option gives us a way to return to the way things were before this patch.

These parts are now looking good ... but we still need to tackle what Linux
does when it does get the CPER record.  I suspect we need to preserve
the existing "fake an mcelog entry with just the address" on old platforms,
but need to do something smarter on new ones.

-Tony


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
