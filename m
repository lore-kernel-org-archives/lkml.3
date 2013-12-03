Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab3LCWb6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 17:31:58 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:37796 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309Ab3LCWb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 17:31:56 -0500
Message-ID: <529E5BD8.5090709@gmail.com>
Date: Tue, 03 Dec 2013 14:31:52 -0800
From: Rajat Jain <rajatjain.linux@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Paul Bolle <pebolle@tiscali.nl>
CC: Rajat Jain <rajatjain@juniper.net>, Rajat Jain <rajatxjain@gmail.com>,
        Rajat Jain <rajatjain.linux@gmail.com>,
        Guenter Roeck <groeck@juniper.net>, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v2 0/4] Allow Link state changes for Hot-Plug
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I had sent out this patchset as an "RFC" a few weeks back. It was briefly
discussed last week ( http://marc.info/?t=138513966800006&r=1&w=2 ). I was
wondering if you got a chance to look at this, and would appreciate it a 
lot if this could be reviewed for inclusion in the tree.

In v2, I have dropped the use of module parameter as suggested by Bjorn.

This patch set enables the use of PCI Express link up and link down events
for Hotplug or Unplug. The requirement of such a feature was originally
discussed here:

http://www.spinics.net/lists/linux-pci/msg05783.html
http://www.spinics.net/lists/hotplug/msg05801.html

Patch [1/4]: makes a function non-static for use by patch 2.
Patch [2/4]: Contains the bulk logic to allow link events to be used
             for hotplug and removal.
Patch [3/4]: Makes the pciehp_power_thread() lock free by making it
             look at a work info->req instead of slot->state.
Patch [4/4]: Introduce slot->hotplug_lock to serialize the hotplug
             operations.

(As a side effect, this patch also fixes the bug 
https://bugzilla.kernel.org/show_bug.cgi?id=65521 )

I'd appreciate if you could please review and provide me with any comments.

Thanks,

Rajat

Rajat Jain (4):
  pciehp: Make check_link_active() non-static
  pciehp: Use link change notifications for hot-plug and removal
  pciehp: Ensure very fast hotplug events are also processed.
  pciehp: Introduce hotplug_lock to serialize HP events

 drivers/pci/hotplug/pciehp.h      |    5 ++
 drivers/pci/hotplug/pciehp_core.c |    7 +-
 drivers/pci/hotplug/pciehp_ctrl.c |  179 ++++++++++++++++++++++++++++++++-----
 drivers/pci/hotplug/pciehp_hpc.c  |   63 +++++++------
 4 files changed, 200 insertions(+), 54 deletions(-)

-- 
1.7.9.5

