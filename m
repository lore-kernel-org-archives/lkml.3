Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab3AKUej (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 15:34:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:51252 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754780Ab3AKUeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 15:34:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,453,1355126400"; 
   d="scan'208";a="271089090"
Date: Fri, 11 Jan 2013 22:37:59 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing0307@gmail.com>, Jiang Liu <liuj97@gmail.com>
Subject: Re: [PATCH 1/16] ACPI: Separate adding ACPI device objects from
 probing ACPI drivers
Message-ID: <20130111203759.GC13897@intel.com>
References: <8498184.VilrUmatxI@vostro.rjw.lan>
 <23002897.6xbQGtPaGy@vostro.rjw.lan>
 <20130111200046.GB13897@intel.com>
 <2859994.arbXorpfaz@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2859994.arbXorpfaz@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 09:31:43PM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Subject: ACPI / scan: Fix check of device_attach() return value.
> 
> Since device_attach() returns 1 on success and 0 on failure,
> the check against its return value in acpi_bus_device_attach()
> should be reveresed.  Make it so.

Not sure if it matters but it returns 0 if no device was bound to a driver
and -ENODEV in case of error. If we only want to terminate in case of
error, following might be better.

	} else if (device_attach(&device->dev) < 0) {
