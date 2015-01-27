Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033AbbA0WdM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 17:33:12 -0500
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:38166
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbbA0WdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 17:33:10 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        vkuznets@redhat.com, tglx@linutronix.de
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0/8] Drivers: hv: vmbus: Enable unloading of vmbus driver
Date: Tue, 27 Jan 2015 15:46:16 -0800
Message-Id: <1422402376-5463-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Windows hosts starting with Ws2012 R2 permit re-establishing the vmbus
connection from the guest. This patch-set includes patches from Vitaly
to cleanup the VMBUS unload path so we can potentially reload the driver.

This set also includes a patch from Jake to correctly extract MMIO
information on both Gen1 and Gen 2 firmware.


Jake Oshins (1):
  drivers:hv:vmbus drivers:hv:vmbus Allow for more than one MMIO range
    for children

Vitaly Kuznetsov (7):
  Drivers: hv: vmbus: prevent cpu offlining on newer hypervisors
  Drivers: hv: vmbus: rename channel work queues
  Drivers: hv: vmbus: avoid double kfree for device_obj
  Drivers: hv: vmbus: teardown hv_vmbus_con workqueue and
    vmbus_connection pages on shutdown
  drivers: hv: vmbus: Teardown synthetic interrupt controllers on
    module unload
  clockevents: export clockevents_unbind_device instead of
    clockevents_unbind
  Drivers: hv: vmbus: Teardown clockevent devices on module unload

 drivers/hv/channel_mgmt.c       |    6 +-
 drivers/hv/connection.c         |   17 +++--
 drivers/hv/hv.c                 |   34 ++++++++-
 drivers/hv/hyperv_vmbus.h       |    3 +
 drivers/hv/vmbus_drv.c          |  150 ++++++++++++++++++++++++++++++++++-----
 drivers/video/fbdev/hyperv_fb.c |    2 +-
 include/linux/hyperv.h          |    5 +-
 kernel/time/clockevents.c       |    2 +-
 8 files changed, 188 insertions(+), 31 deletions(-)

-- 
1.7.4.1

