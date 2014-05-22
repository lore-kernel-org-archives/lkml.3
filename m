Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbaEVIIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 04:08:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:37534 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027AbaEVII1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 04:08:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,885,1392192000"; 
   d="scan'208";a="535896584"
Date: Thu, 22 May 2014 11:08:22 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, bhelgaas@google.com,
        matthew.garrett@nebula.com, rafael.j.wysocki@intel.com,
        dmitry.torokhov@gmail.com
Subject: Re: [PATCH V6 09/11] ACPI: introduce flag .is_master_device
Message-ID: <20140522080822.GB1651@lahna.fi.intel.com>
References: <1400136256-2218-1-git-send-email-rui.zhang@intel.com>
 <1400136256-2218-10-git-send-email-rui.zhang@intel.com>
 <20140521085207.GR1651@lahna.fi.intel.com>
 <2394524.GkgpdWbBbP@vostro.rjw.lan>
 <1400684982.13930.39.camel@rzhang1-toshiba>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1400684982.13930.39.camel@rzhang1-toshiba>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 11:09:42PM +0800, Zhang Rui wrote:
> On 三, 2014-05-21 at 13:10 +0200, Rafael J. Wysocki wrote:
> > On Wednesday, May 21, 2014 11:52:07 AM Mika Westerberg wrote:
> > > On Thu, May 15, 2014 at 02:44:14PM +0800, Zhang Rui wrote:
> > > > For some ACPI device objects, they represent master devices,
> > > > and their children devices are enumerated by bus controller drivers
> > > > for the buses they are on.
> > > > 
> > > > In this case, we do not want to enumerate their children devices to
> > > > platform bus explicitly in acpi scan code.
> > > > 
> > > > Thus a new flag .is_master_device is introduced in this patch.
> > > > 
> > > > For devices with this flag set, we will not do default enumeration
> > > > for their children.
> > > 
> > > Is there any particular reason we would like to enumerate everything
> > > below the first device by default?
> > 
> > Yes, there is.  Device objects without _ADR under the PCI host bridge.
> > 
> I'm confused. Mika, what do you mean by saying "first device"?

I mean the first level devices right below the host bridge, such as
\_SB.PCI0.* but not \_SB.PCI0.*.FOO.
