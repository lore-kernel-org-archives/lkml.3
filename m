Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174AbaKEQhZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 11:37:25 -0500
Received: from mga01.intel.com ([192.55.52.88]:34720 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932121AbaKEQhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 11:37:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,320,1413270000"; 
   d="scan'208";a="627078365"
Message-ID: <5459646E.9000707@linux.intel.com>
Date: Tue, 04 Nov 2014 15:42:38 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Grant Likely <grant.likely@secretlab.ca>
CC: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI / GPIO: Pass index to acpi_get_gpiod_by_index()
 when using properties
References: <1414494927-204923-1-git-send-email-mika.westerberg@linux.intel.com> <CACxGe6uXogQaT9m_Zysb+daSHCz2B97OdMBHuCzJvNYj9oNWfQ@mail.gmail.com> <2107668.8toVpPDgB1@vostro.rjw.lan> <3196606.Sy6xFg88zg@vostro.rjw.lan>
In-Reply-To: <3196606.Sy6xFg88zg@vostro.rjw.lan>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/4/14 14:54, Rafael J. Wysocki wrote:

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

In this case, do we never expect a property to contain more than one
ACPI_TYPE_LOCAL_REFERENCE?

Package () { "foobar",
              Package () {
                  "PCI0.FOO", "PCI0.BAR", 0, 1, 0,
                  "PCI0.FOO", "PCI0.BAR2", 0, 1, 1
              }
}

This seems like it could be useful for connecting various types of
devices together, but I confess not to have a specific exmaple in mind.
It does concern me to limit the data format in this way.

I suppose should such a case become necessary, we can deal with the
issue then - and still avoid having a potential abuse point in the API
from the start.

-- 
Darren Hart
Intel Open Source Technology Center
