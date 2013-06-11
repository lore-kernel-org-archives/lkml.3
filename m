Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab3FKQBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 12:01:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808Ab3FKQBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 12:01:41 -0400
Subject: [PATCH 0/3] vfio: fixup notifiers and avoid possible deadlock
To: alex.williamson@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date: Tue, 11 Jun 2013 10:01:37 -0600
Message-ID: <20130611155848.9995.41709.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup a couple of the notifier paths to remove bogus WARN_ON calls.
One is pretty easy to hit and neither really signifies a problems.
Fix remove path to avoid potential deadlock with other device_lock
holders.  Thanks,

Alex

---

Alex Williamson (3):
      vfio: Don't overreact to DEL_DEVICE
      vfio: Ignore sprurious notifies
      vfio-pci: Avoid deadlock on remove


 drivers/vfio/pci/vfio_pci.c |   23 +++++++++++++++++++++--
 drivers/vfio/vfio.c         |   37 ++++++++++---------------------------
 2 files changed, 31 insertions(+), 29 deletions(-)
