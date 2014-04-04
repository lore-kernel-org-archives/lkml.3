Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334AbaDDSxz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 14:53:55 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:28517 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107AbaDDSxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 14:53:51 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Bug-fixes for 3.15 related to 'xl shutdown' and hanging the initial domain reboot.
Date: Fri,  4 Apr 2014 14:53:39 -0400
Message-Id: <1396637621-30113-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.5.3
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

These patches were posted way back in Novemeber for issues discovered with Xen 4.4.
I posted the patches and then dropped them to focus on PVH. Now dusting off
my patch queue.

The 
 [PATCH 1/2] xen/xenbus: Avoid synchronous wait on XenBus stalling

fixes an issue were initial domain would hang if it had guest running.
Usually the toolstack is in charge of such things but in case that had died
- well we still want to reboot but we couldn't because we were stuck waiting
for a reply that we would never get.

The
 [PATCH 2/2] xen/manage: Poweroff forcefully if user-space is not yet

fixes a bit of how Linux handles the 'xl shutdown' command. In theory if
the first 'xl shutdown' didn't do it - send another, and then another.

Except that the kernel would gate on the first and ignore the rest. Even
if it failed to shutdown. This mean the user had to destroy the guest.
This patch fixes that and also makes the shutdown work when we are in the
booting stage.

Please pull these in stable/for-linus-3.15 after rc1. Thanks!

 drivers/xen/manage.c           | 32 ++++++++++++++++++++++++++++--
 drivers/xen/xenbus/xenbus_xs.c | 44 +++++++++++++++++++++++++++++++++++++++---
 2 files changed, 71 insertions(+), 5 deletions(-)

Konrad Rzeszutek Wilk (2):
      xen/xenbus: Avoid synchronous wait on XenBus stalling shutdown/restart.
      xen/manage: Poweroff forcefully if user-space is not yet up.

