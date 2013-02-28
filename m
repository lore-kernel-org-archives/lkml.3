Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab3B1XbG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 18:31:06 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:48083 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169Ab3B1XbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 18:31:03 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-usb@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 2/2] ACPI / glue: Drop .find_bridge() callback from struct acpi_bus_type
Date: Fri, 01 Mar 2013 00:37:51 +0100
Message-ID: <3242723.ZVP4iiJczV@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0; KDE/4.9.5; x86_64; ; )
In-Reply-To: <512FD687.7060904@pobox.com>
References: <2612891.I2roH54cPk@vostro.rjw.lan> <1995794.TENtrAZA5Q@vostro.rjw.lan> <512FD687.7060904@pobox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 28, 2013 05:13:27 PM Jeff Garzik wrote:
> On 02/28/2013 04:53 PM, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >
> > After PCI and USB have stopped using the .find_bridge() callback in
> > struct acpi_bus_type, the only remaining user of it is SATA, but SATA
> > only pretends to be a user, because it points that callback to a stub
> > always returning -ENODEV.
> >
> > For this reason, drop the SATA's dummy .find_bridge() callback and
> > remove .find_bridge(), which is not used any more, from struct
> > acpi_bus_type entirely.
> >
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > ---
> >   drivers/acpi/glue.c       |   26 +-------------------------
> >   drivers/ata/libata-acpi.c |    6 ------
> >   include/acpi/acpi_bus.h   |    3 ---
> >   3 files changed, 1 insertion(+), 34 deletions(-)
> 
> patches 1-2 Acked-by: Jeff Garzik <jgarzik@pobox.com>

Thanks!


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
