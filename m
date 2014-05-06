Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935010AbaEFLIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 07:08:35 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43766 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934988AbaEFLI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 07:08:27 -0400
Date: Tue, 6 May 2014 13:08:26 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Zheng, Lv" <lv.zheng@intel.com>
Cc: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Moore, Robert" <robert.moore@intel.com>
Subject: Re: [PATCH 02/27] ACPICA: Utilities: Deploy ACPI_DEBUGGER_EXEC for
 ACPI_DEBUGGER enabled code in utglobal.c.
Message-ID: <20140506110826.GB7089@amd.pavel.ucw.cz>
References: <cover.1398817612.git.lv.zheng@intel.com>
 <53dbe352c16de24ea99d00af21eb01750af90074.1398817612.git.lv.zheng@intel.com>
 <20140506075353.GA20931@xo-6d-61-c0.localdomain>
 <1AE640813FDE7649BE1B193DEA596E880255A03B@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E880255A03B@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > From: Pavel Machek [mailto:pavel@ucw.cz]
> > Sent: Tuesday, May 06, 2014 3:54 PM
> > 
> > On Wed 2014-04-30 10:03:39, Lv Zheng wrote:
> > > This patch deploys ACPI_DEBUGGER_EXEC usage to utglobal.c to reduce "ifdef"
> > > of ACPI_DEBUGGER.  No functional changes.  Lv Zheng.
> > >
> > > Signed-off-by: Lv Zheng <lv.zheng@intel.com>
> > > Signed-off-by: Bob Moore <robert.moore@intel.com>
> > > ---
> > >  drivers/acpi/acpica/utglobal.c |    4 +---
> > >  1 file changed, 1 insertion(+), 3 deletions(-)
> > >
> > > diff --git a/drivers/acpi/acpica/utglobal.c b/drivers/acpi/acpica/utglobal.c
> > > index f3abeae..825b064 100644
> > > --- a/drivers/acpi/acpica/utglobal.c
> > > +++ b/drivers/acpi/acpica/utglobal.c
> > > @@ -377,9 +377,7 @@ acpi_status acpi_ut_init_globals(void)
> > >  	acpi_gbl_disable_mem_tracking = FALSE;
> > >  #endif
> > >
> > > -#ifdef ACPI_DEBUGGER
> > > -	acpi_gbl_db_terminate_threads = FALSE;
> > > -#endif
> > > +	ACPI_DEBUGGER_EXEC(acpi_gbl_db_terminate_threads = FALSE);
> > >
> > >  	return_ACPI_STATUS(AE_OK);
> > 
> > Is it just me or is this incredibly ugly?
> 
> This patch is no-op for Linux kernel.
> ACPI_DEBUGGER is not enabled for Linux kernel.
> 
> This patch is here to reduce the source code differences between
> Linux and ACPICA.

> ACPICA release is done by a set of conversion utilities, the process is known as linuxizing.
> The generation result of the linuxizing will require more human
> interventions if such differences grow bigger.

You don't have to do the change to the original ACPICA release, do
you?

Would it be feasible to modify your linuxizing scripts to simply
delete #ifdefs that can not happen for linux?
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
