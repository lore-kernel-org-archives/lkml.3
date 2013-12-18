Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab3LRAza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 19:55:30 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:60358 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750875Ab3LRAz2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 19:55:28 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Josh Triplett <josh@joshtriplett.org>,
        "Moore, Robert" <robert.moore@intel.com>,
        "Zheng, Lv" <lv.zheng@intel.com>
Cc: Rashika Kheria <rashika.kheria@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "devel@acpica.org" <devel@acpica.org>
Subject: Re: [PATCH 05/11] drivers: acpi: Include appropriate header file in utstate.c
Date: Wed, 18 Dec 2013 02:08:46 +0100
Message-ID: <2756776.dGKMpKb0nz@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131217202518.GA17790@jtriplet-mobl1>
References: <c676af6619fc5a84208740bfc7edcf56bb78ed4e.1387271324.git.rashika.kheria@gmail.com> <94F2FBAB4432B54E8AACC7DFDE6C92E37C7B99F5@ORSMSX103.amr.corp.intel.com> <20131217202518.GA17790@jtriplet-mobl1>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 17, 2013 12:25:18 PM Josh Triplett wrote:
> On Tue, Dec 17, 2013 at 05:35:46PM +0000, Moore, Robert wrote:
> > I'm not sure what version of ACPICA you are looking at, but in the master git tree for ACPICA, the file accommon.h includes "acutils.h".
> 
> This is the version in the latest git tree for the Linux kernel.

Well, I guess that's something for Lv to look at, then.

Lv, we seem to have a divergence here, can you please see if we can fix it
shortly?

Rafael


> > > -----Original Message-----
> > > From: Rashika Kheria [mailto:rashika.kheria@gmail.com]
> > > Sent: Tuesday, December 17, 2013 1:22 AM
> > > To: linux-kernel@vger.kernel.org
> > > Cc: Moore, Robert; Zheng, Lv; Wysocki, Rafael J; Len Brown; linux-
> > > acpi@vger.kernel.org; josh@joshtriplett.org; devel@acpica.org
> > > Subject: [PATCH 05/11] drivers: acpi: Include appropriate header file in
> > > utstate.c
> > > 
> > > Include appropriate header file acutils.h in acpica/utstate.c because
> > > function acpi_ut_create_pkg_state_and_push() has its prototype declaration
> > > in acutils.h. Also, encloses the function in acpica/utstate.c in ifdef
> > > condition of ACPI_FUTURE_USAGE.
> > > 
> > > This eliminates the following warning in utstate.c:
> > > drivers/acpi/acpica/utstate.c:64:1: warning: no previous prototype for
> > > ‘acpi_ut_create_pkg_state_and_push’ [-Wmissing-prototypes]
> > > 
> > > Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> > > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> > > ---
> > >  drivers/acpi/acpica/utstate.c |    3 +++
> > >  1 file changed, 3 insertions(+)
> > > 
> > > diff --git a/drivers/acpi/acpica/utstate.c b/drivers/acpi/acpica/utstate.c
> > > index 03c4c2f..0920d23 100644
> > > --- a/drivers/acpi/acpica/utstate.c
> > > +++ b/drivers/acpi/acpica/utstate.c
> > > @@ -43,6 +43,7 @@
> > > 
> > >  #include <acpi/acpi.h>
> > >  #include "accommon.h"
> > > +#include "acutils.h"
> > > 
> > >  #define _COMPONENT          ACPI_UTILITIES
> > >  ACPI_MODULE_NAME("utstate")
> > > @@ -60,6 +61,7 @@ ACPI_MODULE_NAME("utstate")
> > >   * DESCRIPTION: Create a new state and push it
> > >   *
> > > 
> > > **************************************************************************
> > > ****/
> > > +#ifdef  ACPI_FUTURE_USAGE
> > >  acpi_status
> > >  acpi_ut_create_pkg_state_and_push(void *internal_object,
> > >  				  void *external_object,
> > > @@ -79,6 +81,7 @@ acpi_ut_create_pkg_state_and_push(void *internal_object,
> > >  	acpi_ut_push_generic_state(state_list, state);
> > >  	return (AE_OK);
> > >  }
> > > +#endif
> > > 
> > > 
> > > /*************************************************************************
> > > ******
> > >   *
> > > --
> > > 1.7.9.5
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
