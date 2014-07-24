Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759494AbaGXPS0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 11:18:26 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:37771 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759251AbaGXPSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 11:18:24 -0400
From: Rob Jones <rob.jones@codethink.co.uk>
To: gregkh@linuxfoundation.org
Cc: rdunlap@infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kernel@lists.codethink.co.uk,
        ian.molton@codethink.co.uk, ben.dooks@codethink.co.uk,
        rob.jones@codethink.co.uk
Subject: [PATCH 0/1] A debugfs file system for managed resources (devres)
Date: Thu, 24 Jul 2014 16:18:00 +0100
Message-Id: <1406215081-15113-1-git-send-email-rob.jones@codethink.co.uk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A fairly low overhead debug tool that may be useful to anyone developing
a device driver that uses managed resources.

It allows limited inspection from userspace of managed resources currently
allocated to devices.

When building the kernel, setting flag DEVRES_DEBUGFS adds debug code that
causes a directory to be created in the debugfs file system which will
contain a file for each device that uses managed resources. When read,
this file returns some basic debug information about all the managed
resources currently allocated to that device.

It is possible to trivially identify resources such as GPIOs, IRQs and
memory allocated using devm_kmalloc() without the use of intrusive debug
tools.

Rob Jones (1):
  Managed Devices devres_debugfs file system

 Documentation/driver-model/devres-debugfs.txt |  140 +++++++++
 drivers/base/Kconfig                          |   18 ++
 drivers/base/devres.c                         |  387 +++++++++++++++++++++++++
 3 files changed, 545 insertions(+)
 create mode 100644 Documentation/driver-model/devres-debugfs.txt

-- 
1.7.10.4

