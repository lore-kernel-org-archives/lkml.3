Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757812Ab3GLVNM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 17:13:12 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:28311 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757738Ab3GLVNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 17:13:08 -0400
Message-ID: <1373663544.24916.19.camel@misato.fc.hp.com>
Subject: Re: [PATCH] ACPI / memhotplug: Fix a stale pointer in error path
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 12 Jul 2013 15:12:24 -0600
In-Reply-To: <2971486.2Wa9ROjLYK@vostro.rjw.lan>
References: <1373474833-14047-1-git-send-email-toshi.kani@hp.com>
	 <3723604.ey6eovWnzB@vostro.rjw.lan>
	 <1373662875.24916.17.camel@misato.fc.hp.com>
	 <2971486.2Wa9ROjLYK@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-12 at 23:13 +0200, Rafael J. Wysocki wrote:
> On Friday, July 12, 2013 03:01:15 PM Toshi Kani wrote:
> > On Fri, 2013-07-12 at 22:42 +0200, Rafael J. Wysocki wrote:
> > > On Friday, July 12, 2013 08:51:29 AM Toshi Kani wrote:
> > > > On Fri, 2013-07-12 at 09:24 +0900, Yasuaki Ishimatsu wrote:
> > > > > (2013/07/11 1:47), Toshi Kani wrote:
> > > > > > device->driver_data needs to be cleared when releasing its data,
> > > > > > mem_device, in an error path of acpi_memory_device_add().
> > > > > > 
> > > > > > Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> > > > > > ---
> > > > > 
> > > > > Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> > > > 
> > > > Thanks Yasuaki!
> > > 
> > > Queued up as a fix for 3.11.
> > 
> > Thanks!
> > 
> > > Do we need that in -stable as well?
> > 
> > Good point.  Yes, we need that in -stable as well.
> 
> What's the oldest mainline major release that fix is applicable to?

The fix is applicable all ways up to 2.6.32.

Thanks,
-Toshi


> 
> Rafael
> 
> 
> > > > > >   drivers/acpi/acpi_memhotplug.c |    1 +
> > > > > >   1 file changed, 1 insertion(+)
> > > > > > 
> > > > > > diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
> > > > > > index c711d11..999adb5 100644
> > > > > > --- a/drivers/acpi/acpi_memhotplug.c
> > > > > > +++ b/drivers/acpi/acpi_memhotplug.c
> > > > > > @@ -323,6 +323,7 @@ static int acpi_memory_device_add(struct acpi_device *device,
> > > > > >   	/* Get the range from the _CRS */
> > > > > >   	result = acpi_memory_get_device_resources(mem_device);
> > > > > >   	if (result) {
> > > > > > +		device->driver_data = NULL;
> > > > > >   		kfree(mem_device);
> > > > > >   		return result;
> > > > > >   	}
> > > > > > --
> > > > > > To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> > > > > > the body of a message to majordomo@vger.kernel.org
> > > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > > > 
> > > > > 
> > > > > 
> > > > 
> > > > 
> > 
> > 


