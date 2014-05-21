Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137AbaEUPKH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 11:10:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:9704 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018AbaEUPKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 11:10:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,880,1392192000"; 
   d="scan'208";a="542778898"
Message-ID: <1400684982.13930.39.camel@rzhang1-toshiba>
Subject: Re: [PATCH V6 09/11] ACPI: introduce flag .is_master_device
From: Zhang Rui <rui.zhang@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, matthew.garrett@nebula.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com
Date: Wed, 21 May 2014 23:09:42 +0800
In-Reply-To: <2394524.GkgpdWbBbP@vostro.rjw.lan>
References: <1400136256-2218-1-git-send-email-rui.zhang@intel.com>
	 <1400136256-2218-10-git-send-email-rui.zhang@intel.com>
	 <20140521085207.GR1651@lahna.fi.intel.com>
	 <2394524.GkgpdWbBbP@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 三, 2014-05-21 at 13:10 +0200, Rafael J. Wysocki wrote:
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
> 
I'm confused. Mika, what do you mean by saying "first device"?

thanks,
rui
> Or we can skip the children under every *platform* device created by this by
> default and mark the ones where we want the children to be enumerated as
> platform devices too in a special way if needed.
> 
> I guess we could try that (that was the Rui's original idea IIRC).
> 
> Rafael
> 


