Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab3KZA3Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 19:29:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:56399 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098Ab3KZA3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 19:29:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,771,1378882800"; 
   d="scan'208";a="414724079"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Lv Zheng <zetalog@gmail.com>
CC: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: RE: [PATCH 2/4] ACPI: Cleanup <acpi/acpi_bus.h> and
 <acpi/acpi_drivers.h> inclusions.
Thread-Topic: [PATCH 2/4] ACPI: Cleanup <acpi/acpi_bus.h> and
 <acpi/acpi_drivers.h> inclusions.
Thread-Index: AQHO6jmNjfPm2xpDdESDQcpwlpdSeZo2pfaQ
Date: Tue, 26 Nov 2013 00:29:14 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E880248D7E9@SHSMSX101.ccr.corp.intel.com>
References: <cover.1385094640.git.lv.zheng@intel.com>
 <0292f01e89b52e1f6c581fc23684ea2b5f2bb1d8.1385094641.git.lv.zheng@intel.com>
 <9115833.KtCKlFnNUO@vostro.rjw.lan>
In-Reply-To: <9115833.KtCKlFnNUO@vostro.rjw.lan>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rAQ0TUsr007841

Hi, Rafael

Thanks for commenting.

> From: Rafael J. Wysocki [mailto:rjw@rjwysocki.net]
> Sent: Tuesday, November 26, 2013 8:06 AM
> 
> On Saturday, November 23, 2013 07:29:08 AM Lv Zheng wrote:
> > From: Lv Zheng <lv.zheng@intel.com>
> >
> > This patch enfoces <linux/acpi.h> inclusion instead of direct
> > <acpi/acpi_drivers.h> and <acpi/acpi_bus.h> inclusions.
> 
> First off, please make the changelog shorter.  Here's my version:
> 
> "Replace direct inclusions of <acpi/acpi_drivers.h> and <acpi/acpi_bus.h>,
> which are incorrect, with <linux/acpi.h> inclusions.
> 
> First of all, <acpi/acpi_drivers.h> and <acpi/acpi_bus.h> should not
> be included directly from any files that are built for CONFIG_ACPI
> unset, because that generally leads to build warnings about undefined
> symbols in !CONFIG_ACPI builds.  For CONFIG_ACPI set <linux/acpi.h>
> includes those files and for CONFIG_ACPI it provides stub ACPI
> symbols to be used in that case.
> 
> Second, there are ordering dependencies between those files that
> always have to be met.  Namely, it is required that <acpi/acpi_bus.h>
> be included prior to <acpi/acpi_drivers.h> so that the acpi_pci_root
> declarations the latter depends on are always there.  That also is
> taken care of including <linux/acpi.h> as appropriate."

OK.

> 
> Second, please fold [3/4] into this one.  Keeping them separate is
> artificial and pointless in my opinion.  [Of course, the changelog will
> have to be modified then.]

OK.

> 
> [...]
> 
> Apart from the above ->
> 
> > Signed-off-by: Lv Zheng <lv.zheng@intel.com>
> > ---
[...]

> > diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
> > index ba5b56d..1bd3de4 100644
> > --- a/drivers/acpi/ec.c
> > +++ b/drivers/acpi/ec.c
> > @@ -40,8 +40,7 @@
> >  #include <linux/spinlock.h>
> >  #include <linux/slab.h>
> >  #include <asm/io.h>
> > -#include <acpi/acpi_bus.h>
> > -#include <acpi/acpi_drivers.h>
> > +#include <linux/acpi.h>
> 
> -> add the new #include above the <asm/io.h> maybe?

The patch was generated for people who even don't have too many ACPI header knowledge can review and determine that the modifications will not trigger regressions.
So it doesn't cleanup other existing inclusion issues for the affected files, for example:
1. empty lines.
2. asm files
3. other acpi inclusions

Do you mean I need to cleanup whole file other than what the patch description claimed to clean?
If so, I'll follow this comment and all the following ones to refresh the patch.

> 
> >  #include <linux/dmi.h>
> >
> >  #include "internal.h"

[...]

> > diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> > index 54a20ff..8507034 100644
> > --- a/drivers/acpi/osl.c
> > +++ b/drivers/acpi/osl.c
> > @@ -50,7 +50,6 @@
> >  #include <asm/uaccess.h>
> >
> >  #include <acpi/acpi.h>
> > -#include <acpi/acpi_bus.h>
> >  #include <acpi/processor.h>
> 
> -> I guess all of these <acpi/...> inclusions may go away from here?
> 
> >  #include "internal.h"
> >

[...]

> > diff --git a/drivers/acpi/pci_link.c b/drivers/acpi/pci_link.c
> > index 2652a61..cc5feb9 100644
> > --- a/drivers/acpi/pci_link.c
> > +++ b/drivers/acpi/pci_link.c
> > @@ -40,8 +40,7 @@
> >  #include <linux/mutex.h>
> >  #include <linux/slab.h>
> >
> 
> -> Remove the empty line too.
> 
> > -#include <acpi/acpi_bus.h>
> > -#include <acpi/acpi_drivers.h>
> > +#include <linux/acpi.h>
> >
> >  #define PREFIX "ACPI: "
> >
> > diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
> > index 20360e4..dadd0f50 100644
> > --- a/drivers/acpi/pci_root.c
> > +++ b/drivers/acpi/pci_root.c
> > @@ -35,8 +35,6 @@
> >  #include <linux/pci-aspm.h>
> >  #include <linux/acpi.h>
> >  #include <linux/slab.h>
> > -#include <acpi/acpi_bus.h>
> > -#include <acpi/acpi_drivers.h>
> >  #include <acpi/apei.h>
> 
> Does <acpi/apei.h> have to be included directly here?  If not, please remove
> it too.
> 
> >
> >  #include "internal.h"

[...]

> > diff --git a/drivers/acpi/proc.c b/drivers/acpi/proc.c
> > index 6a5b152..56d30fe 100644
> > --- a/drivers/acpi/proc.c
> > +++ b/drivers/acpi/proc.c
> > @@ -5,8 +5,7 @@
> >  #include <linux/bcd.h>
> >  #include <asm/uaccess.h>
> >
> > -#include <acpi/acpi_bus.h>
> > -#include <acpi/acpi_drivers.h>
> > +#include <linux/acpi.h>
> 
> -> Put the new line above the <asm/uaccess.h>
> 
> >
> >  #include "sleep.h"
> >
> > diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
> > index b3171f3..ad88410 100644
> > --- a/drivers/acpi/processor_core.c
> > +++ b/drivers/acpi/processor_core.c
> > @@ -11,7 +11,7 @@
> >  #include <linux/dmi.h>
> >  #include <linux/slab.h>
> >
> > -#include <acpi/acpi_drivers.h>
> > +#include <linux/acpi.h>
> >  #include <acpi/processor.h>
> 
> -> Remove the useless empty line and processor.h inclusion too.
> 
> >
> >  #include "internal.h"
> > diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
> > index 644516d..a1087d8 100644
> > --- a/drivers/acpi/processor_idle.c
> > +++ b/drivers/acpi/processor_idle.c
> > @@ -46,7 +46,6 @@
> >  #include <asm/apic.h>
> >  #endif
> >
> > -#include <acpi/acpi_bus.h>
> >  #include <acpi/processor.h>
> 
> Is the processor.h inclusion necessary here?
> 
> >
> >  #define PREFIX "ACPI: "
> > diff --git a/drivers/acpi/processor_perflib.c b/drivers/acpi/processor_perflib.c
> > index 60a7c28..df63370 100644
> > --- a/drivers/acpi/processor_perflib.c
> > +++ b/drivers/acpi/processor_perflib.c
> > @@ -36,8 +36,7 @@
> >  #include <asm/cpufeature.h>
> >  #endif
> >
> > -#include <acpi/acpi_bus.h>
> > -#include <acpi/acpi_drivers.h>
> > +#include <linux/acpi.h>
> >  #include <acpi/processor.h>
> 
> And here?  And it's better to add #include <linux/acpi.h> to the other #include
> <linux/...> things.
> 
> >  #define PREFIX "ACPI: "
> > diff --git a/drivers/acpi/processor_thermal.c b/drivers/acpi/processor_thermal.c
> > index d1d2e7f..4af89f9 100644
> > --- a/drivers/acpi/processor_thermal.c
> > +++ b/drivers/acpi/processor_thermal.c
> > @@ -33,9 +33,8 @@
> >
> >  #include <asm/uaccess.h>
> >
> > -#include <acpi/acpi_bus.h>
> > +#include <linux/acpi.h>
> >  #include <acpi/processor.h>
> > -#include <acpi/acpi_drivers.h>
> 
> Same comments as above.
> 
> >  #define PREFIX "ACPI: "
> >
> > diff --git a/drivers/acpi/processor_throttling.c b/drivers/acpi/processor_throttling.c
> > index e7dd2c1..a9de919 100644
> > --- a/drivers/acpi/processor_throttling.c
> > +++ b/drivers/acpi/processor_throttling.c
> > @@ -36,8 +36,7 @@
> >  #include <asm/io.h>
> >  #include <asm/uaccess.h>
> >
> > -#include <acpi/acpi_bus.h>
> > -#include <acpi/acpi_drivers.h>
> > +#include <linux/acpi.h>
> >  #include <acpi/processor.h>
> 
> Same comments as above.
> 
> >  #define PREFIX "ACPI: "

[...]

> > diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> > index fd39459..8870277 100644
> > --- a/drivers/acpi/scan.c
> > +++ b/drivers/acpi/scan.c
> > @@ -12,7 +12,6 @@
> >  #include <linux/dmi.h>
> >  #include <linux/nls.h>
> >
> > -#include <acpi/acpi_drivers.h>
> >
> 
> Remove the empty line too.
> 
> >  #include "internal.h"
> >
> > diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
> > index 721e949..281e5fd 100644
> > --- a/drivers/acpi/sleep.c
> > +++ b/drivers/acpi/sleep.c
> > @@ -21,8 +21,6 @@
> >
> >  #include <asm/io.h>
> >
> > -#include <acpi/acpi_bus.h>
> > -#include <acpi/acpi_drivers.h>
> >
> 
> Remove the empty line too.
> 
> OK, you should get the idea. Please keep things consistent and nice. :-)

Yes, I'll try to cover all above comments in 1 patch.
Thanks for the helping.

Best regards
-Lv
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
