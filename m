Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbaDWBHF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 21:07:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:31723 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbaDWBHC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 21:07:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,908,1389772800"; 
   d="scan'208";a="497741725"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: RE: [PATCH 1/4] ACPICA: Add <acpi/platform/aclinuxxf.h> to remove
 mis-ordered inclusion of <acpi/actypes.h> from <acpi/platform/aclinux.h>.
Thread-Topic: [PATCH 1/4] ACPICA: Add <acpi/platform/aclinuxxf.h> to remove
 mis-ordered inclusion of <acpi/actypes.h> from <acpi/platform/aclinux.h>.
Thread-Index: AQHPXaI9lV/jhfK5X0Sgd13es7oQhpsc3PXggAAaJwCAAW3ncA==
Date: Wed, 23 Apr 2014 01:06:56 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E880255760D@SHSMSX101.ccr.corp.intel.com>
References: <cover.1385110130.git.lv.zheng@intel.com>
 <3086544.JUcChlMM9C@vostro.rjw.lan>
 <1AE640813FDE7649BE1B193DEA596E8802556F33@SHSMSX101.ccr.corp.intel.com>
 <1465848.IEpXGNryLP@vostro.rjw.lan>
In-Reply-To: <1465848.IEpXGNryLP@vostro.rjw.lan>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3N18EGw014226

Hi, Rafael

> From: Rafael J. Wysocki [mailto:rjw@rjwysocki.net]
> Sent: Tuesday, April 22, 2014 7:16 PM
> 
> On Tuesday, April 22, 2014 02:01:57 AM Zheng, Lv wrote:
> > Hi,
> >
> > <skip>
> >
> > > > +#define ACPI_NATIVE_INTERFACE_HEADER	<acpi/platform/aclinuxxf.h>
> > >
> > > This is not good.
> > >
> > > We don't do things like this in the kernel, because they are confusing and hard
> > > to debug if necessary, so please find a different way to make this work.
> >
> > I use this extra header file to collect:
> 
> I was not talking about the new header, which is basically OK, but about the
> #define above, which is just too confusing to live.
> 
> Please use header file paths directly with #include.

OK.

> 
> > 1. static inline OSL functions
> > 2. divergences of prototypes that haven't been back ported to ACPICA.
> > This file is useful for ACPICA release automation.
> >
> > There are the following concerns that lead to the use of this solution:
> > 1. for this extra header file itself
> >     A. The new header file is OSPM specific, thus it needn't be upstreamed to ACPICA;
> >     B. Since it needn't be upstreamed to ACPICA, ACPICA needn't determine the name of this extra header;
> >     C. It has to be the last file included by <acpi/acpi.h>.
> > 2. for the file that includes this extra header file
> >     A. Currently there is no OSPM specific code in <acpi/acpi.h>.
> > Thus I use a macro so that there is still no OSPM specific code in <acpi/acpi.h> and the name of the extra header can be determined
> by OSPM.
> >
> > If you want another solution, is the following acceptable?
> > 1. In <acpi/platform/aclinux.h>
> >     #define ACPI_INCLUDE_EXTRA_NATIVE_HEADER	1
> > 2. In <acpi/acpi.h> <- this is an ACPICA header file,
> >     #ifdef ACPI_INCLUDE_EXTRA_NATIVE_HEADER
> >     #include <acpi/platform/acextra.h>
> >     #endif
> > Note that in this solution, the name of the extra header file will be determined by ACPICA.
> 
> I think I see what you're trying to do now.  And I see that this ACPI_NATIVE_INTERFACE_HEADER
> thing is already there in the Linus' tree which is not good at all.
> 
> I probably would create an extra ACPICA header, something like <acpios_opt.h>,
> that would be empty for all hosts except for Linux and that would contain the
> stuff you want to put into acextra.h in Linux.
> 
> That would be clean enough I suppose?

Yes, it is clear.
Thanks for the helping.
I'll update this patch and re-send this series.

Best regards
-Lv
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
