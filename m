Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbaAIKz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 05:55:29 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:26757 "EHLO
	vsp-authed-04-02.binero.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751098AbaAIKzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 05:55:22 -0500
From: Andreas Larsson <andreas@gaisler.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Rutland <mark.rutland@arm.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        software@gaisler.com
Subject: [PATCH 0/6] usb: gadget: gr_udc: OF and ep.maxpacket_limit related improvements
Date: Thu,  9 Jan 2014 11:54:12 +0100
Message-Id: <1389264858-32664-1-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds some OF related improvements suggested by Mark
Rutland.

This patchset also adds ep.maxpacket_limit to the debugfs file and adds
a check if gr_ep_enable is called with a maxpacket value greater than
ep.maxpacket_limit.

Andreas Larsson (6):
  usb: gadget: gr_udc: Make struct platform_device variable name
    clearer
  usb: gadget: gr_udc: Expand devicetree documentation
  usb: gadget: gr_udc: Use platform_get_irq instead of
    irq_of_parse_and_map
  usb: gadget: gr_udc: Use of_property_read_u32_index to access arrays
  usb: gadget: gr_udc: Add ep.maxpacket_limit to debugfs information
  usb: gadget: gr_udc: Return error code when trying to set
    ep.maxpacket > ep.maxpacket_limit

 Documentation/devicetree/bindings/usb/gr-udc.txt |   22 ++++++----
 drivers/usb/gadget/gr_udc.c                      |   49 ++++++++++++----------
 2 files changed, 40 insertions(+), 31 deletions(-)

-- 
1.7.10.4

