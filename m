Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab3ENC3W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 22:29:22 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:50332 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756148Ab3ENC2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 22:28:51 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 0/7] PCI: fix pci dev add and remove sequence
Date: Mon, 13 May 2013 19:28:19 -0700
Message-Id: <1368498506-25857-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patchset is started while we try to address double remove pci
devices via sysfs that is found by Gu.

main point is from Bjorn that add reference for bus, and he also
pointed out that release should be done in pci_release_device.

After reviewing the add and remove path, found more problem that
need to be addressed, like
1. proc attach/detach is not balanced
2. stop_and_remove device is not multiple calling safe.

Also found sriov VFs add path has problem, it call pci_bus_add_device
to early, and it will make VF's driver get probed before PF's driver
probing is done. That will also have nested lock problem.

Please consider those patches to be 3.10 materials.

Thanks

Yinghai

  PCI: move back pci_proc_attach_devices calling
  PCI: move resources and bus_list releasing to pci_release_dev
  PCI: Detach driver in pci_stop_device
  PCI: Fix racing for pci device removing via sysfs
  PCI, ACPI: Don't glue ACPI dev with pci VFs
  PCI: Make sure VF's driver get attached after PF's
  PCI: use pf as dma_dev for vf that does not have func0 sibling
