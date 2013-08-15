Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759310Ab3HOR74 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 13:59:56 -0400
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:43279 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753467Ab3HOR7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 13:59:55 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: joro@8bytes.org, alex.williamson@redhat.com, Varun.Sethi@freescale.com,
        aik@ozlabs.ru, joe@perches.com, rostedt@goodmis.org,
        fweisbec@gmail.com, mingo@redhat.com, tony@atomide.com,
        ohad@wizery.com, andreas.herrmann@calxeda.com, will.deacon@arm.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, shuahkhan@gmail.com
Subject: [PATCH 0/7] iommu: Add event tracing feature to iommu 
Date: Thu, 15 Aug 2013 11:59:22 -0600
Message-Id: <cover.1376587770.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds tracing feature to iommu driver to report various
iommu events. Classes iommu_group, iommu_device, and iommu_map_unmap
are defined.

iommu_group class events can be enabled to trigger when devices get added
to and removed from an iommu group. Trace information includes iommu group
id and device name.

iommu:add_device_to_group
iommu:remove_device_from_group

iommu_device class events can be enabled to trigger when devices are attached
to and detached from a domain. Trace information includes device name.

iommu:attach_device_to_domain
iommu:detach_device_from_domain

iommu_map_unmap class events can be enabled to trigger when iommu map and
unmap iommu ops complete. Trace information includes iova, physical address
(map event only), and size.

iommu:map
iommu:unmap

In addition to defining the new traces, iommu driver is changed to call trace
events.

Changes since the last patch set:
- Addressed feedback: removed iommu_amd_event class.
- Generated patch with the new trace event defines.
- Generated individual patches for each trace event call in iommu driver

Shuah Khan (7):
  iommu: Add event tracing feature to iommu
  iommu: Change iommu driver to call add_device_to_group trace event
  iommu: Change iommu driver to call remove_device_to_group trace event
  iommu: Change iommu driver to call attach_device_to_domain trace
    event
  iommu: Change iommu driver to call detach_device_to_domain trace
    event
  iommu: Change iommu driver to call map trace event
  iommu: Change iommu driver to call unmap trace event

 drivers/iommu/Makefile       |    1 +
 drivers/iommu/iommu-traces.c |   24 ++++++++
 drivers/iommu/iommu.c        |   15 ++++-
 include/trace/events/iommu.h |  129 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 168 insertions(+), 1 deletion(-)
 create mode 100644 drivers/iommu/iommu-traces.c
 create mode 100644 include/trace/events/iommu.h

-- 
1.7.10.4

