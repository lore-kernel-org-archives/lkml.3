Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759337Ab3GRStd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 14:49:33 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:49650 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494Ab3GRStb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 14:49:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH 5/30] ACPI / hotplug / PCI: Unified notify handler for hotplug events
Date: Thu, 18 Jul 2013 20:59:25 +0200
Message-ID: <1752714.boAZzg4FTs@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAE9FiQU99a=BeHCrt0FWSeNs8NORg85C4uwQyY7Ky+-nqaSfxg@mail.gmail.com>
References: <26431283.HJCKsss0rt@vostro.rjw.lan> <1551099.EAQDd0lEcY@vostro.rjw.lan> <CAE9FiQU99a=BeHCrt0FWSeNs8NORg85C4uwQyY7Ky+-nqaSfxg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 17, 2013 07:07:02 PM Yinghai Lu wrote:
> On Wed, Jul 17, 2013 at 4:18 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >
> > Using the hotplug context objects introduced previously rework the
> > ACPI-based PCI hotplug (ACPIPHP) core code so that all notifications
> > for ACPI device objects corresponding to the hotplug PCI devices are
> > handled by one function, handle_hotplug_event(), which recognizes
> > whether it has to handle a bridge or a function.
> >
> > In addition to code size reduction it allows some ugly pieces of code
> > where notify handlers have to be uninstalled and installed again to
> > go away.  Moreover, it fixes a theoretically possible race between
> > handle_hotplug_event() and free_bridge() tearing down data structures
> > for the same handle.
> >
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > ---
> >  drivers/pci/hotplug/acpiphp.h      |    1
> >  drivers/pci/hotplug/acpiphp_glue.c |  132 ++++++++++++++-----------------------
> >  2 files changed, 53 insertions(+), 80 deletions(-)
> 
> Can you put this patches in one temp branch ?

They are in linux-pm.git/bleeding-edge.

> 
> Like to check final bits.

Sure.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
