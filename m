Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab3HTRez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 13:34:55 -0400
Received: from shrek-wifi.podlesie.net ([93.179.225.50]:35385 "EHLO
	shrek.podlesie.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab3HTRew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 13:34:52 -0400
X-Greylist: delayed 454 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Aug 2013 13:34:52 EDT
From: Krzysztof Mazur <krzysiek@podlesie.net>
To: linux-usb@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Daniel J Blueman <daniel@numascale-asia.com>,
        Krzysztof Mazur <krzysiek@podlesie.net>
Subject: [PATCH 0/2] usb: fix hub_configure() error handling
Date: Tue, 20 Aug 2013 19:24:34 +0200
Message-Id: <1377019476-7701-1-git-send-email-krzysiek@podlesie.net>
X-Mailer: git-send-email 1.8.4.rc1.409.gbd48715
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this series fixes hub_configure() error handling that causes hub->ports[i]
NULL pointer dereferences that were previously reported at:

"[PATCH] Prevent USB hub remove oops"
http://marc.info/?l=linux-kernel&m=136189072520909&w=4
https://bugzilla.redhat.com/show_bug.cgi?id=926907

This bug still exists in 3.11-rc6 and I've got an Oops during startup
caused by hub->ports[i] dereference in hub_quiesce().

The first patch implements what Alan Stern suggested in the
"[PATCH] Prevent USB hub remove oops" thread:
  "All of these problems can be fixed in hub_configure by setting
  hub->maxchild to the total number of allocated ports (or 0 if hub_ports
  can't be allocated)."
http://marc.info/?l=linux-usb&m=136189486922963&w=4

The second patch uses slightly different approach because some
users ignore hub->maxchild and use hub->descriptor->bNbrPorts.

Krzysiek

Krzysztof Mazur (2):
  usb: fix cleanup after failure in hub_configure()
  usb: fail on usb_hub_create_port_device() errors

 drivers/usb/core/hub.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

-- 
1.8.4.rc1.409.gbd48715

