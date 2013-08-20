Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458Ab3HTLDJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 07:03:09 -0400
Received: from mga14.intel.com ([143.182.124.37]:50696 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937Ab3HTLDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 07:03:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,919,1367996400"; 
   d="scan'208";a="284271543"
Date: Tue, 20 Aug 2013 14:08:33 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Toshi Kani <toshi.kani@hp.com>
Subject: Re: [PATCH] ACPI / PM: Hold acpi_scan_lock over system PM transitions
Message-ID: <20130820110833.GZ4898@intel.com>
References: <2852781.TfChGuuEkJ@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2852781.TfChGuuEkJ@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 01:47:57AM +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Bad things happen if ACPI hotplug events are handled during system
> PM transitions, especially if devices are removed as a result.
> To prevent those bad things from happening, acquire acpi_scan_lock
> when a transition is started and release it when that transition
> is complete or has been aborted.
> 
> This fixes resume lockup on my test-bed Acer Aspire S5 that happens
> when Thunderbolt devices are disconnected from the machine while
> suspended.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

I tested this on Intel DZ77RE-75K and after the patch is applied the
machine didn't hang anymore once resuming.

Feel free to add my tested-by.
