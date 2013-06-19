Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935156Ab3FSV3D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 17:29:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:20365 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934566Ab3FSV27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 17:28:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,899,1363158000"; 
   d="scan'208";a="356311109"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "ananth@in.ibm.com" <ananth@in.ibm.com>,
        "masbock@linux.vnet.ibm.com" <masbock@linux.vnet.ibm.com>,
        "lcm@linux.vnet.ibm.com" <lcm@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Robert Richter" <rric@kernel.org>
Subject: RE: [PATCH v2 2/2] mce: acpi/apei: Add a boot option to disable ff
 mode for corrected errors
Thread-Topic: [PATCH v2 2/2] mce: acpi/apei: Add a boot option to disable ff
 mode for corrected errors
Thread-Index: AQHObRaMG8NLWdbwnkKYI9OOtTgcdZk9yhyA//+MXBCAAHyTAP//kUdQgACKGAD//4yfcAAQQVUAAA5rtIA=
Date: Wed, 19 Jun 2013 21:28:50 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F2DA884F0@ORSMSX106.amr.corp.intel.com>
References: <20130619175438.2852.93449.stgit@localhost.localdomain>
 <20130619175728.2852.73156.stgit@localhost.localdomain>
 <20130619180441.GK28300@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F2DA88106@ORSMSX106.amr.corp.intel.com>
 <20130619183640.GL28300@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F2DA881C2@ORSMSX106.amr.corp.intel.com>
 <20130619201438.GM28300@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F2DA8838B@ORSMSX106.amr.corp.intel.com>
 <20130619210706.GP28300@pd.tnic>
In-Reply-To: <20130619210706.GP28300@pd.tnic>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5JLTBJQ012889

> Ok, where is that semantics? What in a CPER record does say "this error
> should tell you that you need to offline the containing page and I'm
> telling you this exactly only once"? Error Severity 0, i.e. Recoverable?

Naveen - this one is for you (or for your BIOS team).  Can you get us a sample
CPER that you plan to provide when the BIOS decides that its threshold has
been exceeded?  How will it be different from what old WSM-EX platforms
were sending to us?  Hopefully the answer is encoded in the CPER record
and not in some code we have to put in Linux to say "if (IBMplatform) do_thing_1(); else ... "

> Ok, we're talking about the S in RAS now. Do we have error recovery
> strategies specified anywhere? Are they per-platform or generic? Is this
> CPER strategy above, for example, only valid for some platforms or for
> all APEI-using hardware?

mcelog(8) daemon has been doing this for years ... but it used the "predictive
failure analysis" buzzwords that were popular way back then (today the
marketing people seem to prefer "self healing" ). Whatever the name, the
concept is the same ... take some set of corrected event reports and infer
from them that something worse may happen soon, and use that information
to try to avoid the (possibly) impending crash.

> Questions over questions...

Questions are good - they help fill out gaps

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
