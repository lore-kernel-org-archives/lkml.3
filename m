Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab3LQUZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 15:25:29 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:59698 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab3LQUZ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 15:25:28 -0500
X-Originating-IP: 173.246.103.110
Date: Tue, 17 Dec 2013 12:25:18 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Moore, Robert" <robert.moore@intel.com>
Cc: Rashika Kheria <rashika.kheria@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zheng, Lv" <lv.zheng@intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "devel@acpica.org" <devel@acpica.org>
Subject: Re: [PATCH 05/11] drivers: acpi: Include appropriate header file in
 utstate.c
Message-ID: <20131217202518.GA17790@jtriplet-mobl1>
References: <c676af6619fc5a84208740bfc7edcf56bb78ed4e.1387271324.git.rashika.kheria@gmail.com>
 <c8f6f6fbcd7de593a726d091f5d0f6a245f6e0f7.1387271324.git.rashika.kheria@gmail.com>
 <94F2FBAB4432B54E8AACC7DFDE6C92E37C7B99F5@ORSMSX103.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <94F2FBAB4432B54E8AACC7DFDE6C92E37C7B99F5@ORSMSX103.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 05:35:46PM +0000, Moore, Robert wrote:
> I'm not sure what version of ACPICA you are looking at, but in the master git tree for ACPICA, the file accommon.h includes "acutils.h".

This is the version in the latest git tree for the Linux kernel.

- Josh Triplett

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
> > ‘acpi_ut_create_pkg_state_and_push’ [-Wmissing-prototypes]
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
> > 
> > 
> > /*************************************************************************
> > ******
> >   *
> > --
> > 1.7.9.5
> 
