Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965495Ab3GLVaT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 17:30:19 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:40385 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965436Ab3GLVaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 17:30:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toshi Kani <toshi.kani@hp.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI / memhotplug: Fix a stale pointer in error path
Date: Fri, 12 Jul 2013 23:40:06 +0200
Message-ID: <1907509.WiI0tI5uDZ@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1373663544.24916.19.camel@misato.fc.hp.com>
References: <1373474833-14047-1-git-send-email-toshi.kani@hp.com> <2971486.2Wa9ROjLYK@vostro.rjw.lan> <1373663544.24916.19.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 12, 2013 03:12:24 PM Toshi Kani wrote:
> On Fri, 2013-07-12 at 23:13 +0200, Rafael J. Wysocki wrote:
> > On Friday, July 12, 2013 03:01:15 PM Toshi Kani wrote:
> > > On Fri, 2013-07-12 at 22:42 +0200, Rafael J. Wysocki wrote:
> > > > On Friday, July 12, 2013 08:51:29 AM Toshi Kani wrote:
> > > > > On Fri, 2013-07-12 at 09:24 +0900, Yasuaki Ishimatsu wrote:
> > > > > > (2013/07/11 1:47), Toshi Kani wrote:
> > > > > > > device->driver_data needs to be cleared when releasing its data,
> > > > > > > mem_device, in an error path of acpi_memory_device_add().
> > > > > > > 
> > > > > > > Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> > > > > > > ---
> > > > > > 
> > > > > > Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> > > > > 
> > > > > Thanks Yasuaki!
> > > > 
> > > > Queued up as a fix for 3.11.
> > > 
> > > Thanks!
> > > 
> > > > Do we need that in -stable as well?
> > > 
> > > Good point.  Yes, we need that in -stable as well.
> > 
> > What's the oldest mainline major release that fix is applicable to?
> 
> The fix is applicable all ways up to 2.6.32.

For -stable I'll need to say some more about what practical consequences of
the bug are.  Is it difficult to trigger?

Rafael


> > > > > > >   drivers/acpi/acpi_memhotplug.c |    1 +
> > > > > > >   1 file changed, 1 insertion(+)
> > > > > > > 
> > > > > > > diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
> > > > > > > index c711d11..999adb5 100644
> > > > > > > --- a/drivers/acpi/acpi_memhotplug.c
> > > > > > > +++ b/drivers/acpi/acpi_memhotplug.c
> > > > > > > @@ -323,6 +323,7 @@ static int acpi_memory_device_add(struct acpi_device *device,
> > > > > > >   	/* Get the range from the _CRS */
> > > > > > >   	result = acpi_memory_get_device_resources(mem_device);
> > > > > > >   	if (result) {
> > > > > > > +		device->driver_data = NULL;
> > > > > > >   		kfree(mem_device);
> > > > > > >   		return result;
> > > > > > >   	}
> > > > > > > --
> > > > > > > To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> > > > > > > the body of a message to majordomo@vger.kernel.org
> > > > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > > > > 
> > > > > > 
> > > > > > 
> > > > > 
> > > > > 
> > > 
> > > 
> 
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
