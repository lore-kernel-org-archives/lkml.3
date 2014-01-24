Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbaAXOMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 09:12:36 -0500
Received: from mga09.intel.com ([134.134.136.24]:28966 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359AbaAXOMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 09:12:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,712,1384329600"; 
   d="scan'208";a="471875853"
Date: Fri, 24 Jan 2014 16:19:23 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/RFT][PATCH v2 0/6] PM / QoS: Introduce latency tolerance
 device PM QoS type
Message-ID: <20140124141923.GQ18029@intel.com>
References: <5434847.aCyiWHNRe7@vostro.rjw.lan>
 <1447517.8AFrWcAgld@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1447517.8AFrWcAgld@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 02:34:59PM +0100, Rafael J. Wysocki wrote:
> On Friday, January 17, 2014 03:42:13 PM Rafael J. Wysocki wrote:
> > Hi All,
> > 
> > On some platforms hardware may switch to an energy-saving mode on the fly
> > on the basis of certain utilization metrics used by it.  That usually is
> > desirable from the energy conservation standpoint, but it generally causes
> > latencies to increase which may adversely affect some operations.  For this
> > reason, the platforms in question usually provide some interfaces for software
> > to indicate its latency tolerance and possibly to prevent the energy-saving
> > modes from being selected too aggressively.
> > 
> > The following series of patches introduces a device PM QoS type allowing
> > those interfaces to be used by kernel code and user space.  It is designed
> > in analogy with the existing resume latency device PM QoS type, which allows
> > some pieces of the existing device PM QoS code to be re-used and makes the
> > new user space interface fit into the existing framework.
> > 
> > Patch [1/5] modifies the names of symbols, variables, functions and structure
> > fields associated with the existing resume latency device PM QoS type to
> > avoid any confusion with the new one introduced by the subsequent patches.
> > 
> > Patch [2/5] introduces a new field in struct pm_qos_constraints for specifying
> > a special value to be returned as the effective requirement when the given list
> > of PM QoS requirements is empty.  That field is necessary for the new latency
> > tolerance device PM QoS type.
> > 
> > Patch [3/5] introduces the latency tolerance device PM QoS type along with
> > documentation.
> > 
> > Patch [4/5] modifies the ACPI LPSS (Low-Power Subsystem) driver to hook up
> > LPSS devices to the new latency tolerance device PM QoS interface.
> > 
> > Patch [5/5] modifies the dev_pm_qos_add_ancestor_request() routine so that it
> > can be used by drivers of devices without hardware latency tolerance support
> > for specifying their requirements via the ancestors of those devies.
> 
> As usual, testing uncovered some issues, so an updated series follows.

I tested this series on HSWULT and adding/removing QoS LTR requests from
both userspace and from a modified i2c-hid driver (calling
dev_pm_qos_add_ancestor_request()) and seems to work nicely -- When I read
back the HW LTR values they are what is expected.

Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
