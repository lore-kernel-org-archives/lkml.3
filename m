Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab3KSWj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 17:39:57 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:49424 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610Ab3KSWjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 17:39:54 -0500
Message-ID: <528BE8B6.9080007@gmail.com>
Date: Tue, 19 Nov 2013 14:39:50 -0800
From: Rajat Jain <rajatjain.linux@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Linux-PCI <linux-pci@vger.kernel.org>,
        Linux-hotplug <linux-hotplug@vger.kernel.org>,
        linux-kernel@vger.kernel.org
CC: Bjorn Helgaas <bhelgaas@google.com>, Guenter Roeck <linux@roeck-us.net>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Paul Bolle <pebolle@tiscali.nl>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Rajat Jain <rajatjain.linux@gmail.com>,
        Rajat Jain <rajatjain@juniper.net>, Guenter Roeck <groeck@juniper.net>
Subject: [RFC PATCH 0/4] Allow Link state changes for Hot-Plug
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

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

I'd appreciate if you could please review and provide me with any comments.

Thanks,

Rajat

Rajat Jain (4):
  pciehp: Make check_link_active() non-static
  pciehp: Use link state change notifications for hot-plug and removal
  pciehp: Ensure all hotplug events are processed, even very fast ones.
  pciehp: Introduce hotplug_lock to serialize HP events on each slot

 drivers/pci/hotplug/pciehp.h      |    6 ++
 drivers/pci/hotplug/pciehp_core.c |   10 +-
 drivers/pci/hotplug/pciehp_ctrl.c |  181 ++++++++++++++++++++++++++++++++++---
 drivers/pci/hotplug/pciehp_hpc.c  |   63 +++++++++----
 4 files changed, 229 insertions(+), 31 deletions(-)

-- 
1.7.9.5

