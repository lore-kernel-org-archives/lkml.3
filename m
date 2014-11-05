Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214AbaKEUj3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 15:39:29 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:64098 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752010AbaKEUjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 15:39:25 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Darren Hart <dvhart@linux.intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI / GPIO: Pass index to acpi_get_gpiod_by_index() when using properties
Date: Wed, 05 Nov 2014 22:00:10 +0100
Message-ID: <2711356.TKUHWe28Lk@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141105091622.GW1618@lahna.fi.intel.com>
References: <1414494927-204923-1-git-send-email-mika.westerberg@linux.intel.com> <3196606.Sy6xFg88zg@vostro.rjw.lan> <20141105091622.GW1618@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 05, 2014 11:16:22 AM Mika Westerberg wrote:
> On Tue, Nov 04, 2014 at 11:54:41PM +0100, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Subject: ACPI / property: Drop size_prop from acpi_dev_get_property_reference()
> > 
> > The size_prop argument of the recently added function
> > acpi_dev_get_property_reference() is not used by the only current
> > caller of that function and is very unlikely to be used at any time
> > going forward.
> > 
> > Namely, for a property whose value is a list of items each containing
> > a references to a device object possibly accompanied by some integers,
> > the number of items in the list can always be computed as the number
> > of elements of type ACPI_TYPE_LOCAL_REFERENCE in the property package.
> > Thus it should never be necessary to provide an additional "cells"
> > property with a value equal to the number of items in that list.
> > 
> > For this reason, drop the size_prop argument from
> > acpi_dev_get_property_reference() and update its caller accordingly.
> > 
> > Link: http://marc.info/?l=linux-kernel&m=141511255610556&w=2
> > Suggested-by: Grant Likely <grant.likely@linaro.org>
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Just pulled your latest bleeding-edge (including this patch) and it
> still works fine with both Minnowboards. Feel free to add my:
> 
> Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Thanks!

