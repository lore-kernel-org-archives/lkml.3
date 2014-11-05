Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298AbaKEJQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 04:16:42 -0500
Received: from mga01.intel.com ([192.55.52.88]:53525 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754081AbaKEJQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 04:16:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,319,1413270000"; 
   d="scan'208";a="626852182"
Date: Wed, 5 Nov 2014 11:16:22 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Darren Hart <dvhart@linux.intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI / GPIO: Pass index to acpi_get_gpiod_by_index()
 when using properties
Message-ID: <20141105091622.GW1618@lahna.fi.intel.com>
References: <1414494927-204923-1-git-send-email-mika.westerberg@linux.intel.com>
 <CACxGe6uXogQaT9m_Zysb+daSHCz2B97OdMBHuCzJvNYj9oNWfQ@mail.gmail.com>
 <2107668.8toVpPDgB1@vostro.rjw.lan>
 <3196606.Sy6xFg88zg@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3196606.Sy6xFg88zg@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 11:54:41PM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Subject: ACPI / property: Drop size_prop from acpi_dev_get_property_reference()
> 
> The size_prop argument of the recently added function
> acpi_dev_get_property_reference() is not used by the only current
> caller of that function and is very unlikely to be used at any time
> going forward.
> 
> Namely, for a property whose value is a list of items each containing
> a references to a device object possibly accompanied by some integers,
> the number of items in the list can always be computed as the number
> of elements of type ACPI_TYPE_LOCAL_REFERENCE in the property package.
> Thus it should never be necessary to provide an additional "cells"
> property with a value equal to the number of items in that list.
> 
> For this reason, drop the size_prop argument from
> acpi_dev_get_property_reference() and update its caller accordingly.
> 
> Link: http://marc.info/?l=linux-kernel&m=141511255610556&w=2
> Suggested-by: Grant Likely <grant.likely@linaro.org>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Just pulled your latest bleeding-edge (including this patch) and it
still works fine with both Minnowboards. Feel free to add my:

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
