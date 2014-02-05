Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284AbaBEC2M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 21:28:12 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:61663 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbaBEC2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 21:28:09 -0500
Message-ID: <52F1A1B6.2090709@gmail.com>
Date: Tue, 04 Feb 2014 18:28:06 -0800
From: Rajat Jain <rajatxjain@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
CC: Guenter Roeck <groeck@juniper.net>, Rajat Jain <rajatjain@juniper.net>,
        Rajat Jain <rajatxjain@gmail.com>
Subject: [PATCH v4 0/8] Allow Link state changes for Hot-Plug
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch set enables the use of PCI Express link up and link down events
for Hotplug or Unplug. This is the pretty much the same patchset as v3, only
resending after rebasing on top of 3.14-rc1.

(As a side effect, this patch also fixes the bug 
https://bugzilla.kernel.org/show_bug.cgi?id=65521 )

I'd appreciate if you could please review and provide me with any comments.

Thanks,

Rajat

Rajat Jain (8):
  pciehp: Make check_link_active() non-static
  pciehp: Use link change notifications for hot-plug and removal
  pciehp: Enable link state change notifications
  pciehp: Don't disable the link permanently, during removal
  pciehp: Don't check for adapter or latch status while disabling
  pciehp: Disabling the link notification across slot reset
  pciehp: Ensure very fast hotplug events are also processed.
  pciehp: Introduce hotplug_lock to serialize HP events

 drivers/pci/hotplug/pciehp.h      |    5 ++
 drivers/pci/hotplug/pciehp_core.c |    7 +-
 drivers/pci/hotplug/pciehp_ctrl.c |  149 ++++++++++++++++++++++++++++++-------
 drivers/pci/hotplug/pciehp_hpc.c  |   74 +++++++++---------
 4 files changed, 169 insertions(+), 66 deletions(-)

-- 
1.7.9.5

