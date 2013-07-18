Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934386Ab3GRT4b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 15:56:31 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:49794 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934147Ab3GRT4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 15:56:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH 4/30] ACPI / hotplug / PCI: Hotplug context objects for bridges and functions
Date: Thu, 18 Jul 2013 22:06:16 +0200
Message-ID: <2397558.EsSCoq8A3j@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <3688658.K73mT4hj2a@vostro.rjw.lan>
References: <26431283.HJCKsss0rt@vostro.rjw.lan> <CAE9FiQWjzZ6b1aGgL9OjNZF00hvwaEZJb7ABxjaVbS5FwNwpSQ@mail.gmail.com> <3688658.K73mT4hj2a@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 18, 2013 09:04:11 PM Rafael J. Wysocki wrote:
> On Wednesday, July 17, 2013 07:00:33 PM Yinghai Lu wrote:
> > On Wed, Jul 17, 2013 at 4:17 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > >
> > > When either a new hotplug bridge or a new hotplug function is added
> > > by the ACPI-based PCI hotplug (ACPIPHP) code, attach a context object
> > > to its ACPI handle to store hotplug-related information in it.  To
> > > start with, put the handle's bridge and function pointers into that
> > > object.  Count references to the context objects and drop them when
> > > they are not needed any more.
> > >
> > > First of all, this makes it possible to find out if the given bridge
> > > has been registered as a function already in a much more
> > > straightforward way and acpiphp_bridge_handle_to_function() can be
> > > dropped (Yay!).
> > >
> > > This also will allow some more simplifications to be made going
> > > forward.
> > >
> > > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > ---
> > >  drivers/pci/hotplug/acpiphp.h      |   10 ++
> > >  drivers/pci/hotplug/acpiphp_glue.c |  179 ++++++++++++++++++++++++++++---------
> > >  2 files changed, 146 insertions(+), 43 deletions(-)
> > 
> > no, more lines are added.
> 
> Well, that's what 'quilt refresh --diffstat' tells me, quite consistently.
> 
> Have you actually counted them?

Now I have done that (using "grep '^+' | wc -l") and that indeed turns out ot
the right number.

What gives?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
