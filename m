Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbaBKBSY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 20:18:24 -0500
Received: from mail-ig0-f182.google.com ([209.85.213.182]:65205 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbaBKBSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 20:18:20 -0500
Date: Mon, 10 Feb 2014 18:18:16 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Rajat Jain <rajatjain@juniper.net>
Cc: Rajat Jain <rajatxjain@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yhlu.kernel@gmail.com>, Guenter Roeck <groeck@juniper.net>
Subject: Re: [PATCH v4 0/8] Allow Link state changes for Hot-Plug
Message-ID: <20140211011816.GA15412@google.com>
References: <52F1A1B6.2090709@gmail.com>
 <4f93bb24b6214bfb9dbcc91b682184eb@DM2PR05MB671.namprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f93bb24b6214bfb9dbcc91b682184eb@DM2PR05MB671.namprd05.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 05, 2014 at 03:15:19AM +0000, Rajat Jain wrote:
> Hello list,
> 
> My apologies for I forgot to attach the version history information of each individual patch.
> 
> Essentially the v4 is exactly same as v3, except that it is rebased on top of 3.14-rc1.
> 
> Thanks,
> 
> Rajat
> 
> > -----Original Message-----
> > From: Rajat Jain [mailto:rajatxjain@gmail.com]
> > Sent: Tuesday, February 04, 2014 6:28 PM
> > To: Bjorn Helgaas; Rafael J. Wysocki; Kenji Kaneshige; Alex Williamson;
> > Yijing Wang; linux-pci@vger.kernel.org; linux-kernel@vger.kernel.org;
> > Yinghai Lu
> > Cc: Guenter Roeck; Rajat Jain; Rajat Jain
> > Subject: [PATCH v4 0/8] Allow Link state changes for Hot-Plug
> > 
> > Hello,
> > 
> > This patch set enables the use of PCI Express link up and link down
> > events for Hotplug or Unplug. This is the pretty much the same patchset
> > as v3, only resending after rebasing on top of 3.14-rc1.
> > 
> > (As a side effect, this patch also fixes the bug
> > https://bugzilla.kernel.org/show_bug.cgi?id=65521 )
> > 
> > I'd appreciate if you could please review and provide me with any
> > comments.
> > 
> > Thanks,
> > 
> > Rajat
> > 
> > Rajat Jain (8):
> >   pciehp: Make check_link_active() non-static
> >   pciehp: Use link change notifications for hot-plug and removal
> >   pciehp: Enable link state change notifications
> >   pciehp: Don't disable the link permanently, during removal
> >   pciehp: Don't check for adapter or latch status while disabling
> >   pciehp: Disabling the link notification across slot reset
> >   pciehp: Ensure very fast hotplug events are also processed.
> >   pciehp: Introduce hotplug_lock to serialize HP events
> > 
> >  drivers/pci/hotplug/pciehp.h      |    5 ++
> >  drivers/pci/hotplug/pciehp_core.c |    7 +-
> >  drivers/pci/hotplug/pciehp_ctrl.c |  149
> > ++++++++++++++++++++++++++++++-------
> >  drivers/pci/hotplug/pciehp_hpc.c  |   74 +++++++++---------
> >  4 files changed, 169 insertions(+), 66 deletions(-)

I applied these to pci/pciehp for v3.15, thanks!  I dropped the "ret" decl
in 8/8, which I assume was the cause of the unused variable warning.

Yinghai, if "Don't disable the link permanently, during removal" causes
trouble on your platforms, let us know so we can figure out how to deal
with it.

Bjorn
