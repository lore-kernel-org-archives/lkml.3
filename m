Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757844Ab3KHRiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 12:38:17 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:24243 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757436Ab3KHRiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 12:38:15 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian.Campbell@citrix.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, JBeulich@suse.com,
        david.vrabel@citrix.com, boris.ostrovsky@oracle.com
Subject: [PATCH] Fixes to Linux v3.13 - bugs.xenproject.org ones. (v1).
Date: Fri,  8 Nov 2013 12:38:02 -0500
Message-Id: <1383932286-25080-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

Two of these:
 [PATCH 2/4] xen/manage: Poweroff forcefully if user-space is not yet
 [PATCH 4/4] xen/xenbus: Avoid synchronous wait on XenBus stalling

fix the bugs.xenproject.org outstanding bugs.

The other ones are that were discovered on xen-devel and discussed.
They should go in v3.13 and as the merge window is next week I am
hoping they can be squeezed in then.


 drivers/xen/manage.c            | 64 ++++++++++++++++++++++++++++++++++-------
 drivers/xen/pci.c               | 47 ++++++++++++++++++++++++++++++
 drivers/xen/xenbus/xenbus_xs.c  | 24 ++++++++++++++--
 include/xen/interface/physdev.h | 11 +++++++
 
Konrad Rzeszutek Wilk (4):
      xen/mcfg: Call PHYSDEVOP_pci_mmcfg_reserved for MCFG areas.
      xen/manage: Poweroff forcefully if user-space is not yet up.
      xen/manage: Guard against user-space initiated poweroff and XenBus.
      xen/xenbus: Avoid synchronous wait on XenBus stalling shutdown/restart.

