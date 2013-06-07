Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367Ab3FGQei (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 12:34:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754584Ab3FGQeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 12:34:37 -0400
Subject: [PATCH v2 0/2] pci: ACS check fixes
To: bhelgaas@google.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-pci@vger.kernel.org, ddutile@redhat.com,
        linux-kernel@vger.kernel.org
Date: Fri, 07 Jun 2013 10:34:35 -0600
Message-ID: <20130607162732.7733.17758.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After some further discussion, Don has come around to agreeing that
we cannot assume anything about devices which do not include an ACS
capability.  Patch 1 of this series is therefore the same as sent
before.  We have figured out though that some vendors are indicating
that they don't support peer-to-peer by providing an ACS capability
that is zero'd (ie. no capabilities).  This makes sense as ACS is
largely for allowing control of peer-to-peer features and almost all
of the individual capabilities are optional for multifunction
devices that do not support peer-to-peer.  This also simplifies our
flags filtering.  I'm hoping we'll soon have some quirks for devices
that do not support peer-to-peer, but also do not provide an ACS
capability.  Thanks,

Alex

---

Alex Williamson (2):
      pci: Fix flaw in pci_acs_enabled()
      pci: Differentiate ACS controllable from enabled


 drivers/pci/pci.c |   68 +++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 52 insertions(+), 16 deletions(-)
