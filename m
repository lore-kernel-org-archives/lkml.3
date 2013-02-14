Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934928Ab3BNUpU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 15:45:20 -0500
Received: from mga03.intel.com ([143.182.124.21]:35925 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758953Ab3BNUpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 15:45:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,666,1355126400"; 
   d="scan'208";a="257120444"
From: "Moore, Robert" <robert.moore@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Toshi Kani <toshi.kani@hp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
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
Thread-Index: AQHOCkL6WO0GND/HtUaZIu27Tc3Y7ph4obWwgAEmnICAAAtGEA==
Date: Thu, 14 Feb 2013 20:45:14 +0000
Message-ID: <94F2FBAB4432B54E8AACC7DFDE6C92E368CB5D05@ORSMSX101.amr.corp.intel.com>
References: <1837481.7dT8hTZ4MT@vostro.rjw.lan>
 <5284026.QPQbFciqVT@vostro.rjw.lan>
 <94F2FBAB4432B54E8AACC7DFDE6C92E368CB39A9@ORSMSX101.amr.corp.intel.com>
 <7010893.9OBeMt5Fzh@vostro.rjw.lan>
In-Reply-To: <7010893.9OBeMt5Fzh@vostro.rjw.lan>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1EKjMNl006719



> -----Original Message-----
> From: Rafael J. Wysocki [mailto:rjw@sisk.pl]
> Sent: Thursday, February 14, 2013 4:04 AM
> To: Moore, Robert
> Cc: Toshi Kani; ACPI Devel Maling List; LKML; Bjorn Helgaas; Jiang Liu;
> Yinghai Lu; Yasuaki Ishimatsu; Myron Stowe; linux-pci@vger.kernel.org
> Subject: Re: [Update][PATCH] ACPI / hotplug: Fix concurrency issues and
> memory leaks
> 
> On Thursday, February 14, 2013 02:31:22 AM Moore, Robert wrote:
> > > > > I thought about that, but actually there's no guarantee that the
> > > > > handle will be valid after _EJ0 as far as I can say.  So the
> > > > > race condition is going to be there anyway and using struct
> > > > > acpi_device just makes it easier to avoid it.
> > > >
> > > > In theory, yes, a stale handle could be a problem, if _EJ0
> > > > performs unload table and if ACPICA frees up its internal data
> > > > structure pointed by the handle as a result.  But we should not
> > > > see such issue now since we do not support dynamic ACPI namespace
> yet.
> > >
> > > I'm waiting for information from Bob about that.  If we can assume
> > > ACPI handles to be always valid, that will simplify things quite a
> bit.
> >
> > If a table is unloaded, all the namespace nodes for that table are
> > removed from the namespace, and thus any ACPI_HANDLE pointers go stale
> and invalid.
> 
> OK, thanks!
> 
> To me this means that we cannot assume a handle to stay valid between a
> notify handler and acpi_bus_hot_remove_device() run from a workqueue.
> 
> Is there a mechanism in ACPICA to ensure that a handle won't become stale
> while a notify handler is running for it or is the OS responsible for
> ensuring that
> _EJ0 won't be run in parallel with notify handlers for device objects
> being ejected?
> 

It is up to the host.
Bob


> Rafael
> 
> 
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
