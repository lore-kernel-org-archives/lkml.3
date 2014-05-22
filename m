Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbaEVIw1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 04:52:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:25371 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbaEVIwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 04:52:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,885,1392192000"; 
   d="scan'208";a="544789724"
Date: Thu, 22 May 2014 11:51:35 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, matthew.garrett@nebula.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com
Subject: Re: [PATCH V6 09/11] ACPI: introduce flag .is_master_device
Message-ID: <20140522085135.GC1651@lahna.fi.intel.com>
References: <1400136256-2218-1-git-send-email-rui.zhang@intel.com>
 <1400136256-2218-10-git-send-email-rui.zhang@intel.com>
 <20140521085207.GR1651@lahna.fi.intel.com>
 <1400683387.13930.26.camel@rzhang1-toshiba>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1400683387.13930.26.camel@rzhang1-toshiba>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 10:43:07PM +0800, Zhang Rui wrote:
> On 三, 2014-05-21 at 11:52 +0300, Mika Westerberg wrote:
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
> we do not enumerate everything below the first device by default, we
> just enumerate all the devices with _HID.

OK.

> But if a device has _HID and it is enumerated by its parents to a
> separate bus, we need this flag set for its parent.

How about checking if the device has *SerialBus() connector and in such
case skip the device (given that it is not listed in a special list,
like acpi_platform_device_ids)?
