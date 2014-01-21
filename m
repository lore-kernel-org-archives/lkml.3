Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363AbaAUXDL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 18:03:11 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:49861 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752698AbaAUXDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 18:03:08 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Toshi Kani <toshi.kani@hp.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Len Brown <lenb@kernel.org>,
        Robert Moore <robert.moore@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, devel@acpica.org
Subject: Re: [Patch v1 1/3] ACPI: add callback prepare() into acpi_hotplug_handler
Date: Wed, 22 Jan 2014 00:17:17 +0100
Message-ID: <2201697.uqWgsYrLat@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0-rc8+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <1390338897.1792.467.camel@misato.fc.hp.com>
References: <1390013297-23462-1-git-send-email-jiang.liu@linux.intel.com> <1390338897.1792.467.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 21, 2014 02:14:57 PM Toshi Kani wrote:
> On Sat, 2014-01-18 at 10:48 +0800, Jiang Liu wrote:
> > Add callback prepare() into acpi_hotplug_handler, which will get called
> > at the very beginning of ACPI hotplug event handler. The ACPI core will
> > ignore the event if prepare() returns NOTIFY_STOP.
> > 
> > Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> > ---
> >  drivers/acpi/scan.c     |    4 ++++
> >  include/acpi/acpi_bus.h |    1 +
> >  2 files changed, 5 insertions(+)
> > 
> > diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> > index fd39459..6b0f419 100644
> > --- a/drivers/acpi/scan.c
> > +++ b/drivers/acpi/scan.c
> > @@ -392,6 +392,10 @@ static void acpi_hotplug_notify_cb(acpi_handle handle, u32 type, void *data)
> >  	struct acpi_device *adev;
> >  	acpi_status status;
> >  
> > +	if (handler->prepare &&
> > +	    handler->prepare(handle, type, data) == NOTIFY_STOP)
> > +		return;
> 
> The OS is responsible for calling _OST when it is implemented.  So you
> cannot just return here.  See acpi_hotplug_unsupported(handle, type)
> next line.  Also, please describe why prepare() needs to be added.

I don't think it's needed any more, please see:

http://marc.info/?l=linux-acpi&m=139001691317575&w=2

Thanks,
Rafael

