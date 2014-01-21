Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbaAUXLd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 18:11:33 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:52125 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753749AbaAUXLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 18:11:25 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/RFT][PATCH 4/5] ACPI / LPSS: Support for device latency tolerance PM QoS
Date: Wed, 22 Jan 2014 00:23:29 +0100
Message-ID: <5380624.AVmYnxjkQF@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0-rc8+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <1623216.7y3zYLQxqp@vostro.rjw.lan>
References: <5434847.aCyiWHNRe7@vostro.rjw.lan> <20140120111518.GE18029@intel.com> <1623216.7y3zYLQxqp@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 20, 2014 02:10:10 PM Rafael J. Wysocki wrote:
> On Monday, January 20, 2014 01:15:19 PM Mika Westerberg wrote:
> > On Fri, Jan 17, 2014 at 03:46:40PM +0100, Rafael J. Wysocki wrote:
> > > @@ -415,11 +472,12 @@ static int acpi_lpss_platform_notify(str
> > >  		return 0;
> > >  	}
> > >  
> > > -	if (action == BUS_NOTIFY_ADD_DEVICE)
> > > +	if (action == BUS_NOTIFY_ADD_DEVICE) {
> > >  		ret = sysfs_create_group(&pdev->dev.kobj, &lpss_attr_group);
> > > -	else if (action == BUS_NOTIFY_DEL_DEVICE)
> > > +		pdev->dev.power.set_latency_tolerance = acpi_lpss_set_ltr;
> > 
> > While trying to test this I noticed that BUS_NOTIFY_ADD_DEVICE happens
> > after call to dpm_sysfs_add(), so LTR field is never exposed to the
> > userspace.
> 
> Ahh, I confused things, thanks for reporting this!
> 
> I'll need to hook it up to acpi_platform_notify() somehow I think.

OK, two patches to replace this one ([4/5]) will follow.

On top of them we can move the code from acpi_lpss_platform_notify() to
acpi_lpss_(bind|unbind)() and get rid of acpi_lpss_nb, which I think would be
an improvement too. :-)

Thanks,
Rafael

