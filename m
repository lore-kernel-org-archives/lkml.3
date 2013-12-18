Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037Ab3LRGRs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 01:17:48 -0500
Received: from mga09.intel.com ([134.134.136.24]:12671 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277Ab3LRGRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 01:17:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,505,1384329600"; 
   d="scan'208";a="426444796"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: "Moore, Robert" <robert.moore@intel.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "devel@acpica.org" <devel@acpica.org>
Subject: RE: [PATCH 05/11] drivers: acpi: Include appropriate header file in
 utstate.c
Thread-Topic: [PATCH 05/11] drivers: acpi: Include appropriate header file
 in utstate.c
Thread-Index: AQHO+wmRBBxSuCtrkU2Nn50yaEdgSZpYIKYAgAFZSHA=
Date: Wed, 18 Dec 2013 06:17:33 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E88024987F6@SHSMSX101.ccr.corp.intel.com>
References: <c676af6619fc5a84208740bfc7edcf56bb78ed4e.1387271324.git.rashika.kheria@gmail.com>
 <c8f6f6fbcd7de593a726d091f5d0f6a245f6e0f7.1387271324.git.rashika.kheria@gmail.com>
 <94F2FBAB4432B54E8AACC7DFDE6C92E37C7B99F5@ORSMSX103.amr.corp.intel.com>
In-Reply-To: <94F2FBAB4432B54E8AACC7DFDE6C92E37C7B99F5@ORSMSX103.amr.corp.intel.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBI6IGNL007831

Hi,

Currently we didn't do much on automatically optimized out ACPI_FUTURE_USAGE functions as long as they do not affect the generation of vmlinux binary.

> From: Moore, Robert
> Sent: Wednesday, December 18, 2013 1:36 AM
> 
> I'm not sure what version of ACPICA you are looking at, but in the master git tree for ACPICA, the file accommon.h includes "acutils.h".
> 
> > -----Original Message-----
> > From: Rashika Kheria [mailto:rashika.kheria@gmail.com]
> > Sent: Tuesday, December 17, 2013 1:22 AM
> > To: linux-kernel@vger.kernel.org
> > Cc: Moore, Robert; Zheng, Lv; Wysocki, Rafael J; Len Brown; linux-
> > acpi@vger.kernel.org; josh@joshtriplett.org; devel@acpica.org
> > Subject: [PATCH 05/11] drivers: acpi: Include appropriate header file in
> > utstate.c
> >
> > Include appropriate header file acutils.h in acpica/utstate.c because
> > function acpi_ut_create_pkg_state_and_push() has its prototype declaration
> > in acutils.h. Also, encloses the function in acpica/utstate.c in ifdef
> > condition of ACPI_FUTURE_USAGE.
> >
> > This eliminates the following warning in utstate.c:
> > drivers/acpi/acpica/utstate.c:64:1: warning: no previous prototype for
> > â€˜acpi_ut_create_pkg_state_and_pushâ€™ [-Wmissing-prototypes]
> >
> > Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> > ---
> >  drivers/acpi/acpica/utstate.c |    3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/drivers/acpi/acpica/utstate.c b/drivers/acpi/acpica/utstate.c
> > index 03c4c2f..0920d23 100644
> > --- a/drivers/acpi/acpica/utstate.c
> > +++ b/drivers/acpi/acpica/utstate.c
> > @@ -43,6 +43,7 @@
> >
> >  #include <acpi/acpi.h>
> >  #include "accommon.h"
> > +#include "acutils.h"

IMO, this line is useless.

> >
> >  #define _COMPONENT          ACPI_UTILITIES
> >  ACPI_MODULE_NAME("utstate")
> > @@ -60,6 +61,7 @@ ACPI_MODULE_NAME("utstate")
> >   * DESCRIPTION: Create a new state and push it
> >   *
> >
> > **************************************************************************
> > ****/
> > +#ifdef  ACPI_FUTURE_USAGE
> >  acpi_status
> >  acpi_ut_create_pkg_state_and_push(void *internal_object,
> >  				  void *external_object,
> > @@ -79,6 +81,7 @@ acpi_ut_create_pkg_state_and_push(void *internal_object,
> >  	acpi_ut_push_generic_state(state_list, state);
> >  	return (AE_OK);
> >  }
> > +#endif

IMO, these lines are useful.
I have a plan to do a cleanup on all ACPICA build warnings so that such inconsistencies can be sorted out.
Maybe it is time to do it right now.

Thanks
-Lv

> >
> >
> > /*************************************************************************
> > ******
> >   *
> > --
> > 1.7.9.5

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
