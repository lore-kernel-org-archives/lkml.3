Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933024Ab3EOUjy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 16:39:54 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:49572 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932623Ab3EOUjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 16:39:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toshi Kani <toshi.kani@hp.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] acpi: Fix memory leak on acpi_scan_init_hotplug() error path
Date: Wed, 15 May 2013 22:48:27 +0200
Message-ID: <1462642.q2i8uhJOgR@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1368642071.5673.37.camel@misato.fc.hp.com>
References: <1368636575-5480-1-git-send-email-catalin.marinas@arm.com> <1368642071.5673.37.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 15, 2013 12:21:11 PM Toshi Kani wrote:
> On Wed, 2013-05-15 at 17:49 +0100, Catalin Marinas wrote:
> > Following commit 6b772e8f9 (ACPI: Update PNPID match handling for
> > notify), the acpi_scan_init_hotplug() calls acpi_set_pnp_ids() which
> > allocates acpi_hardware_id and copies a few strings (kstrdup). If the
> > devices does not have hardware_id set, the function exits without
> > freeing the previously allocated ids (and kmemleak complains). This
> > patch calls simply changes 'return' on error to a 'goto out' which calls
> > acpi_free_pnp_ids().
> > 
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
> > Cc: Toshi Kani <toshi.kani@hp.com>
> 
> Reviewed-by: Toshi Kani <toshi.kani@hp.com>
> Tested-by: Toshi Kani <toshi.kani@hp.com>
> 
> Testing was performed by adding a fake ACPI object with _UID only.

Applied to linux-pm.git/linux-next as v3.10-rc2 material.

Thanks,
Rafael


> > ---
> >  drivers/acpi/scan.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> > index fe158fd..c1bc608 100644
> > --- a/drivers/acpi/scan.c
> > +++ b/drivers/acpi/scan.c
> > @@ -1785,7 +1785,7 @@ static void acpi_scan_init_hotplug(acpi_handle handle, int type)
> >  	acpi_set_pnp_ids(handle, &pnp, type);
> >  
> >  	if (!pnp.type.hardware_id)
> > -		return;
> > +		goto out;
> >  
> >  	/*
> >  	 * This relies on the fact that acpi_install_notify_handler() will not
> > @@ -1800,6 +1800,7 @@ static void acpi_scan_init_hotplug(acpi_handle handle, int type)
> >  		}
> >  	}
> >  
> > +out:
> >  	acpi_free_pnp_ids(&pnp);
> >  }
> >  
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
