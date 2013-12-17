Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab3LQUEx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 15:04:53 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:53044 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab3LQUEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 15:04:51 -0500
Message-ID: <52B0AE5E.8040806@gmail.com>
Date: Tue, 17 Dec 2013 12:04:46 -0800
From: Rajat Jain <rajatjain.linux@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
CC: Guenter Roeck <groeck@juniper.net>, Rajat Jain <rajatjain@juniper.net>,
        Rajat Jain <rajatxjain@gmail.com>
Subject: [PATCH v3 0/8] Allow Link state changes for Hot-Plug
Content-Type: multipart/mixed;
 boundary="------------020703040102090302050002"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020703040102090302050002
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello,

This patch set enables the use of PCI Express link up and link down events
for Hotplug or Unplug. Resending the patch after taking care of review
comments, splitting patch into multiple smaller patches, and incorporating
the conclusions drawn from the discussion here:

http://marc.info/?t=138611014300001&r=1&w=2

Due to splitting of the patch, 4 new patches are added to the patchset,
although the content is almost the same. 

Patch v2 [1/4] = Patch v3 [1/8]

Patch v2 [2/8] = Patch v3 [2/8] +
                 Patch v3 [3/8] +
                 Patch v3 [4/8] +
                 Patch v3 [5/8] +
                 Patch v3 [6/8]

Patch v2 [3/4] = Patch v3 [7/8]

Patch v2 [4/4] = Patch v3 [8/8]

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
 drivers/pci/hotplug/pciehp_ctrl.c |  152 ++++++++++++++++++++++++++++++-------
 drivers/pci/hotplug/pciehp_hpc.c  |   73 +++++++++---------
 4 files changed, 171 insertions(+), 66 deletions(-)

-- 
1.7.9.5


--------------020703040102090302050002
Content-Type: text/plain; charset=UTF-8;
 name="Attached Message Part"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="Attached Message Part"


--------------020703040102090302050002--
