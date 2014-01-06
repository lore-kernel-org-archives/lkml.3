Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445AbaAFD3G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 22:29:06 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:53607 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbaAFD27 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 22:28:59 -0500
X-Originating-IP: 50.43.14.201
Date: Sun, 5 Jan 2014 19:28:49 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Rashika Kheria <rashika.kheria@gmail.com>, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 11/11] drivers: acpi: Include header file in debugfs.c
 and rectify prototype declaration in internal.h
Message-ID: <20140106032849.GA20605@leaf>
References: <c676af6619fc5a84208740bfc7edcf56bb78ed4e.1387271324.git.rashika.kheria@gmail.com>
 <37de640470c91e2e54ab68a158e19dde3938f18a.1387271324.git.rashika.kheria@gmail.com>
 <1528697.GH1GrQaKgp@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1528697.GH1GrQaKgp@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 12:33:57AM +0100, Rafael J. Wysocki wrote:
> On Tuesday, December 17, 2013 03:06:54 PM Rashika Kheria wrote:
> > Include header file internal.h in debugfs.c and change the return
> > value's type in header file internal.h.
> > 
> > This eliminates the following warning in debugfs.c:
> > drivers/acpi/debugfs.c:16:13: warning: no previous prototype for ‘acpi_debugfs_init’ [-Wmissing-prototypes]
> > 
> > Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> > ---
> >  drivers/acpi/debugfs.c  |    3 +++
> >  drivers/acpi/internal.h |    2 +-
> >  2 files changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/acpi/debugfs.c b/drivers/acpi/debugfs.c
> > index b55d6a2..96bcaf7 100644
> > --- a/drivers/acpi/debugfs.c
> > +++ b/drivers/acpi/debugfs.c
> > @@ -6,6 +6,7 @@
> >  #include <linux/init.h>
> >  #include <linux/debugfs.h>
> >  #include <acpi/acpi_drivers.h>
> > +#include "internal.h"
> >  
> >  #define _COMPONENT		ACPI_SYSTEM_COMPONENT
> >  ACPI_MODULE_NAME("debugfs");
> > @@ -13,7 +14,9 @@ ACPI_MODULE_NAME("debugfs");
> >  struct dentry *acpi_debugfs_dir;
> >  EXPORT_SYMBOL_GPL(acpi_debugfs_dir);
> >  
> > +#ifdef  CONFIG_DEBUG_FS
> >  void __init acpi_debugfs_init(void)
> >  {
> >  	acpi_debugfs_dir = debugfs_create_dir("acpi", NULL);
> >  }
> > +#endif
> 
> What about avoiding to build the entire debugfs.c for CONFIG_DEBUG_FS unset?
> 
> That surely would make sense? 

It exports the symbol acpi_debugfs_dir, which is used unconditionally.

- Josh Triplett
