Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab3BNCb0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 21:31:26 -0500
Received: from mga01.intel.com ([192.55.52.88]:42088 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712Ab3BNCbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 21:31:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,660,1355126400"; 
   d="scan'208";a="290877737"
From: "Moore, Robert" <robert.moore@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Toshi Kani <toshi.kani@hp.com>
CC: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <liuj97@gmail.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Myron Stowe <mstowe@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: RE: [Update][PATCH] ACPI / hotplug: Fix concurrency issues and
 memory leaks
Thread-Topic: [Update][PATCH] ACPI / hotplug: Fix concurrency issues and
 memory leaks
Thread-Index: AQHOCkL6WO0GND/HtUaZIu27Tc3Y7ph4obWw
Date: Thu, 14 Feb 2013 02:31:22 +0000
Message-ID: <94F2FBAB4432B54E8AACC7DFDE6C92E368CB39A9@ORSMSX101.amr.corp.intel.com>
References: <1837481.7dT8hTZ4MT@vostro.rjw.lan>
 <4594350.VXNmDOeCvt@vostro.rjw.lan>
 <1360796969.3869.146.camel@misato.fc.hp.com>
 <5284026.QPQbFciqVT@vostro.rjw.lan>
In-Reply-To: <5284026.QPQbFciqVT@vostro.rjw.lan>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1E2VRDF002148

> > > I thought about that, but actually there's no guarantee that the
> > > handle will be valid after _EJ0 as far as I can say.  So the race
> > > condition is going to be there anyway and using struct acpi_device
> > > just makes it easier to avoid it.
> >
> > In theory, yes, a stale handle could be a problem, if _EJ0 performs
> > unload table and if ACPICA frees up its internal data structure
> > pointed by the handle as a result.  But we should not see such issue
> > now since we do not support dynamic ACPI namespace yet.
> 
> I'm waiting for information from Bob about that.  If we can assume ACPI
> handles to be always valid, that will simplify things quite a bit.

If a table is unloaded, all the namespace nodes for that table are removed from the namespace, and thus any ACPI_HANDLE pointers go stale and invalid.

Bob

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
