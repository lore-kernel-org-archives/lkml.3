Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759685Ab3HOSQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 14:16:53 -0400
Received: from mga14.intel.com ([143.182.124.37]:2252 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759418Ab3HOSQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 14:16:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,886,1367996400"; 
   d="scan'208";a="346910022"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "rjw@sisk.pl" <rjw@sisk.pl>, "lance.ortiz@hp.com" <lance.ortiz@hp.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aristeu Rozanski Filho" <arozansk@redhat.com>
Subject: RE: [PATCH 3/3] mce: acpi/apei: trace: Enable ghes memory error
 trace event
Thread-Topic: [PATCH 3/3] mce: acpi/apei: trace: Enable ghes memory error
 trace event
Thread-Index: AQHOlGVcQB6qi1wV3Ei8qYoYEneewpmMKjwAgAMKHwCAArfagIAAEviAgAAiKACAAV9FAIAAEOaAgABNEAD//407sIABmBcAgADhpgCAAKPcAIAAO3WAgAAErgD//9MiAA==
Date: Thu, 15 Aug 2013 18:16:48 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31CBCE72@ORSMSX106.amr.corp.intel.com>
References: <5208D80D.5030206@linux.vnet.ibm.com>
 <20130812114404.3bd64fa0@samsung.com> <520A1B5E.8040105@linux.vnet.ibm.com>
 <20130813094147.062317f8@concha.lan> <520A6A30.1030406@linux.vnet.ibm.com>
 <3908561D78D1C84285E8C5FCA982C28F31CB8DB5@ORSMSX106.amr.corp.intel.com>
 <520B603E.3040002@linux.vnet.ibm.com> <20130814211504.393cf138@concha.lan>
 <20130815100132.GC27616@pd.tnic> <20130815103421.178a5224@samsung.com>
 <20130815135106.GG27616@pd.tnic>
In-Reply-To: <20130815135106.GG27616@pd.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r7FIGvHg017578

> * We parse some APEI table and disable those MCA banks which the BIOS
> wants to handle first.

We have no idea which errors the BIOS has chosen for itself.  We just know which
bank numbers ... and Intel processors change mappings of which errors are logged
in which banks in every new processor tock (and sometimes tick).  Some banks
are documented in processor datasheet. most are not. Most common case might
well be memory ... but it could be cache, or I/O, or ...

So this doesn't help Mauro figure out whether to allow loading of an
EDAC driver that will peek and poke at chipset specific registers in
possibly racy ways with BIOS code doing the same thing.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
