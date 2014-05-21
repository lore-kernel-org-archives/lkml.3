Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbaEUOnO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 10:43:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:14757 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076AbaEUOnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 10:43:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,880,1392192000"; 
   d="scan'208";a="535484422"
Message-ID: <1400683387.13930.26.camel@rzhang1-toshiba>
Subject: Re: [PATCH V6 09/11] ACPI: introduce flag .is_master_device
From: Zhang Rui <rui.zhang@intel.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, matthew.garrett@nebula.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com
Date: Wed, 21 May 2014 22:43:07 +0800
In-Reply-To: <20140521085207.GR1651@lahna.fi.intel.com>
References: <1400136256-2218-1-git-send-email-rui.zhang@intel.com>
	 <1400136256-2218-10-git-send-email-rui.zhang@intel.com>
	 <20140521085207.GR1651@lahna.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 三, 2014-05-21 at 11:52 +0300, Mika Westerberg wrote:
> On Thu, May 15, 2014 at 02:44:14PM +0800, Zhang Rui wrote:
> > For some ACPI device objects, they represent master devices,
> > and their children devices are enumerated by bus controller drivers
> > for the buses they are on.
> > 
> > In this case, we do not want to enumerate their children devices to
> > platform bus explicitly in acpi scan code.
> > 
> > Thus a new flag .is_master_device is introduced in this patch.
> > 
> > For devices with this flag set, we will not do default enumeration
> > for their children.
> 
> Is there any particular reason we would like to enumerate everything
> below the first device by default?

we do not enumerate everything below the first device by default, we
just enumerate all the devices with _HID.
But if a device has _HID and it is enumerated by its parents to a
separate bus, we need this flag set for its parent.

thanks,
rui

