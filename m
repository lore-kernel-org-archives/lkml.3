Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763457Ab3ECTeU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 15:34:20 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:41215 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760627Ab3ECTeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 15:34:19 -0400
Message-ID: <1367609656.16154.199.camel@misato.fc.hp.com>
Subject: Re: [PATCH 4/4] ACPI / processor: Use common hotplug infrastructure
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, isimatu.yasuaki@jp.fujitsu.com,
        vasilis.liaskovitis@profitbricks.com, Len Brown <lenb@kernel.org>
Date: Fri, 03 May 2013 13:34:16 -0600
In-Reply-To: <2355471.VAFinTCtRm@vostro.rjw.lan>
References: <1576321.HU0tZ4cGWk@vostro.rjw.lan>
	 <8416995.PXoT3vbUMm@vostro.rjw.lan>
	 <1367605674.16154.198.camel@misato.fc.hp.com>
	 <2355471.VAFinTCtRm@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-05-03 at 21:31 +0200, Rafael J. Wysocki wrote:
> On Friday, May 03, 2013 12:27:54 PM Toshi Kani wrote:
> > On Fri, 2013-05-03 at 14:05 +0200, Rafael J. Wysocki wrote:
> > > On Thursday, May 02, 2013 05:20:12 PM Toshi Kani wrote:

:

> > One minor comment.
> > 
> > +static __cpuinit int __acpi_processor_start(struct acpi_device *device)
> > >  {
> > > -	struct acpi_device *device = per_cpu(processor_device_array,
> > pr->id);
> > > +	struct acpi_processor *pr = acpi_driver_data(device);
> > > +	acpi_status status;
> > >  	int result = 0;
> > >  
> > > +	if (!pr)
> > > +		return -ENODEV;
> > > +
> > > +	if (pr->flags.need_hotplug_init)
> > > +		return 0;
> > > +
> > 
> > I felt the name of "need_hotplug_init" is a bit misleading since the
> > func actually skips when the need-flag is set.  It may be nice to rename
> > it to defer_online_init, offline or something like that.
> 
> I just wanted to avoid making too many non-essential changes in one patch.
> We can change the name of that field at any time later.

Sounds good to me.

Thanks,
-Toshi


