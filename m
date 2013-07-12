Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932902Ab3GLOwX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 10:52:23 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:45883 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932588Ab3GLOwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 10:52:21 -0400
Message-ID: <1373640689.24916.15.camel@misato.fc.hp.com>
Subject: Re: [PATCH] ACPI / memhotplug: Fix a stale pointer in error path
From: Toshi Kani <toshi.kani@hp.com>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: rjw@sisk.pl, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 12 Jul 2013 08:51:29 -0600
In-Reply-To: <51DF4CB6.4060903@jp.fujitsu.com>
References: <1373474833-14047-1-git-send-email-toshi.kani@hp.com>
	 <51DF4CB6.4060903@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-12 at 09:24 +0900, Yasuaki Ishimatsu wrote:
> (2013/07/11 1:47), Toshi Kani wrote:
> > device->driver_data needs to be cleared when releasing its data,
> > mem_device, in an error path of acpi_memory_device_add().
> > 
> > Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> > ---
> 
> Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Thanks Yasuaki!
-Toshi



> 
> Thanks,
> Yasuaki Ishimatsu
> 
> >   drivers/acpi/acpi_memhotplug.c |    1 +
> >   1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
> > index c711d11..999adb5 100644
> > --- a/drivers/acpi/acpi_memhotplug.c
> > +++ b/drivers/acpi/acpi_memhotplug.c
> > @@ -323,6 +323,7 @@ static int acpi_memory_device_add(struct acpi_device *device,
> >   	/* Get the range from the _CRS */
> >   	result = acpi_memory_get_device_resources(mem_device);
> >   	if (result) {
> > +		device->driver_data = NULL;
> >   		kfree(mem_device);
> >   		return result;
> >   	}
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> 


