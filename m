Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab3DGHHS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 03:07:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:49739 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315Ab3DGHHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 03:07:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,423,1363158000"; 
   d="scan'208";a="282205044"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Paul Bolle <pebolle@tiscali.nl>
CC: Len Brown <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Moore, Robert" <robert.moore@intel.com>
Subject: RE: [PATCH] ACPI: remove "config ACPI_DEBUG_FUNC_TRACE"
Thread-Topic: [PATCH] ACPI: remove "config ACPI_DEBUG_FUNC_TRACE"
Thread-Index: AQHOJI56FFAru2ZVDk2aChD9lKJnP5i3fgqAgBKPb+CAAGICcIAABE7w
Date: Sun, 7 Apr 2013 07:07:11 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E88015CDBAA@SHSMSX101.ccr.corp.intel.com>
References: <1363689661.1390.9.camel@x61.thuisdomein>
 <3588021.V98D5VToQr@vostro.rjw.lan>
 <1AE640813FDE7649BE1B193DEA596E88015CD54B@SHSMSX101.ccr.corp.intel.com> 
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3777cH5018155

> > > > Kconfig symbol ACPI_DEBUG_FUNC_TRACE was only used (through its
> > > > corresponding macro) in drivers/acpi/acpica/acmacros.h. That macro
> > > > was removed from that header in v3.8, with commit
> > > > 86ff0e508f88eda6e479a897476026055831d2d8 ("ACPICA: Fix unmerged
> > > > acmacros.h divergences."). That commit did not explain why that
> > > > macro was removed. But it seems that ACPI_DEBUG_FUNC_TRACE can
> > now
> > > > be removed too, as it is unused.
> > >
> > > Lv, can you please comment here?
> >
> > Sorry for the delayed reply.
> >
> > The commit should have done something that already have been done in
> > the ACPICA.
> > I'll take a look at this.
> 
> The original commit deleted CONFIG_ACPI_DEBUG_FUNC_TRACE from
> acmacros.h as it is in the __wrong__ place.
> CONFIG_xxx is linux specific codes thus should appear in OSL layer - aclinux.h.
> ACPICA specific codes should only use selective definitions in #ifdef ACPI_xxx
> style and such codes should be merged into ACPICA rather than being merged
> into Linux ACPI.
> 
> Now we have two choices:
> Re-implement it in the aclinux.h using "ACPI_DEBUG_OUTPUT"
> defined/undefined or delete this kernel configuration item temporarily.

Sorry, I made a mistake here.
ACPI_DEBUG_OUTPUT is already covered by the CONFIG_ACPI_DEBUG.
The corrected statement should be:
If we want to fine tune the output, then the codes might be implemented in ACPICA first and then get utilized in Linux using the new ACPICA feature.

Best regards
-Lv

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
