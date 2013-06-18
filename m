Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933455Ab3FRVeI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 17:34:08 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:41853 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756307Ab3FRVeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 17:34:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toshi Kani <toshi.kani@hp.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiang Liu <liuj97@gmail.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] ACPI / dock: Take ACPI scan lock in write_undock()
Date: Tue, 18 Jun 2013 23:43:27 +0200
Message-ID: <7930194.VHtf9LiNRh@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1371590917.13194.8.camel@misato.fc.hp.com>
References: <1886227.aipra45Zvt@vostro.rjw.lan> <1371590917.13194.8.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 18, 2013 03:28:37 PM Toshi Kani wrote:
> On Sun, 2013-06-16 at 00:16 +0200, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > Since commit 3757b94 (ACPI / hotplug: Fix concurrency issues and
> > memory leaks) acpi_bus_scan() and acpi_bus_trim() must always be
> > called under acpi_scan_lock, but currently the following scenario
> > violating that requirement is possible:
> > 
> >  write_undock()
> >   handle_eject_request()
> >    hotplug_dock_devices()
> >     dock_remove_acpi_device()
> >      acpi_bus_trim()
> > 
> > Fix that by making write_undock() acquire acpi_scan_lock before
> > calling handle_eject_request() as appropriate (begin_undock() is
> > under the lock too in analogy with acpi_dock_deferred_cb()).
> > 
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Looks good.
> 
> Acked-by: Toshi Kani <toshi.kani@hp.com>

Thanks!


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
