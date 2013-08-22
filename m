Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674Ab3HVMuw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 08:50:52 -0400
Received: from shrek-wifi.podlesie.net ([93.179.225.50]:54833 "EHLO
	shrek.podlesie.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338Ab3HVMty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 08:49:54 -0400
From: Krzysztof Mazur <krzysiek@podlesie.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
        Krzysztof Mazur <krzysiek@podlesie.net>
Subject: [PATCH v3 0/3] usb: fix hub_configure() error handling
Date: Thu, 22 Aug 2013 14:49:37 +0200
Message-Id: <1377175780-10611-1-git-send-email-krzysiek@podlesie.net>
X-Mailer: git-send-email 1.8.4.rc4.527.g303b16c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this series fixes hub_configure() error handling that causes hub->ports[i]
NULL pointer dereferences.


Changes in v3:

Added Acked-by from Alan Stern.

Changes in v2:

After review by Alan Stern. The new label has been placed in other place
to avoid changes in existing code. Third patch "usb: don't use bNbrPorts
after initialization" has been added.


The first version has been posted here:

https://lkml.org/lkml/2013/8/20/469

Krzysiek


Krzysztof Mazur (3):
  usb: fix cleanup after failure in hub_configure()
  usb: fail on usb_hub_create_port_device() errors
  usb: don't use bNbrPorts after initialization

 drivers/usb/core/hub.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

-- 
1.8.4.rc4.527.g303b16c

