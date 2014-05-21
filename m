Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036AbaEULFJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 07:05:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:62934 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018AbaEULFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 07:05:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,879,1392192000"; 
   d="scan'208";a="515365831"
Date: Wed, 21 May 2014 14:04:44 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, bhelgaas@google.com,
        matthew.garrett@nebula.com, rafael.j.wysocki@intel.com,
        dmitry.torokhov@gmail.com
Subject: Re: [PATCH V6 09/11] ACPI: introduce flag .is_master_device
Message-ID: <20140521110444.GU1651@lahna.fi.intel.com>
References: <1400136256-2218-1-git-send-email-rui.zhang@intel.com>
 <1400136256-2218-10-git-send-email-rui.zhang@intel.com>
 <20140521085207.GR1651@lahna.fi.intel.com>
 <2394524.GkgpdWbBbP@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2394524.GkgpdWbBbP@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 01:10:33PM +0200, Rafael J. Wysocki wrote:
> On Wednesday, May 21, 2014 11:52:07 AM Mika Westerberg wrote:
> > On Thu, May 15, 2014 at 02:44:14PM +0800, Zhang Rui wrote:
> > > For some ACPI device objects, they represent master devices,
> > > and their children devices are enumerated by bus controller drivers
> > > for the buses they are on.
> > > 
> > > In this case, we do not want to enumerate their children devices to
> > > platform bus explicitly in acpi scan code.
> > > 
> > > Thus a new flag .is_master_device is introduced in this patch.
> > > 
> > > For devices with this flag set, we will not do default enumeration
> > > for their children.
> > 
> > Is there any particular reason we would like to enumerate everything
> > below the first device by default?
> 
> Yes, there is.  Device objects without _ADR under the PCI host bridge.

OK.

> Or we can skip the children under every *platform* device created by this by
> default and mark the ones where we want the children to be enumerated as
> platform devices too in a special way if needed.
> 
> I guess we could try that (that was the Rui's original idea IIRC).

That sounds better to me.

I wonder if we can do this analogous to of_platform_bus_probe() and
friends?
