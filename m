Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559Ab3GNHDE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 03:03:04 -0400
Received: from mga14.intel.com ([143.182.124.37]:1531 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414Ab3GNHDC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 03:03:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,662,1367996400"; 
   d="scan'208";a="268080251"
Date: Sun, 14 Jul 2013 10:08:28 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Jiang Liu <liuj97@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH] PCI / hotplug / ACPI: Get rid of check_sub_bridges()
Message-ID: <20130714070828.GS4898@intel.com>
References: <1373735399-28055-1-git-send-email-mika.westerberg@linux.intel.com>
 <3395919.UaDiFX78Zn@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3395919.UaDiFX78Zn@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 13, 2013 at 11:47:26PM +0200, Rafael J. Wysocki wrote:
> On Saturday, July 13, 2013 08:09:59 PM Mika Westerberg wrote:
> > Now that acpiphp_check_bridge() always enumerates devices behind the
> > bridge, there is no need to do that for each sub-bridge anymore like it is
> > done in the current ACPI-based PCI hotplug code. Given this we don't need
> > check_sub_bridges() anymore and can drop the function completely.
> > 
> > This also simplifies the ACPIPHP code a bit.
> > 
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > ---
> > This applies on top of v3.10 with Rafael's ACPIPHP + Thunderbolt series
> > applied:
> >
> 
> OK, I added it to my bleeding-edge branch along with this series:
> 
> > 	http://www.spinics.net/lists/linux-acpi/msg44480.html
> 
> rebased on top of some previous ACPI cleanup commits.  I needed to make some
> changes in the process (and fixed up some breakage reported by the auto build
> testing), hopefully I didn't break anything.  If you're in an adventurous mood,
> testing would be welcome. ;-)  [That already includes the majority of 3.11
> material from Linus, though, so unexpected breakage elsewhere may happen.]

Tried the bleeding-edge branch on both of our test machines and Thunderbolt
still works fine.
