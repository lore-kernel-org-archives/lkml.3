Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302AbaC0PRN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 11:17:13 -0400
Received: from vsp-authed02.binero.net ([195.74.38.226]:55133 "EHLO
	vsp-authed-01-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754638AbaC0PRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 11:17:08 -0400
From: Andreas Larsson <andreas@gaisler.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        software@gaisler.com
Subject: [PATCH v2 0/7] usb: gadget: gr_udc: OF and ep.maxpacket_limit improvements and fix of GFP_KERNEL in atomic context
Date: Thu, 27 Mar 2014 16:15:52 +0100
Message-Id: <1395933359-7109-1-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset:
 - Adds some OF related improvements suggested by Mark
   Rutland.
 - Adds ep.maxpacket_limit to the debugfs file and adds a check if
   gr_ep_enable is called with a maxpacket value greater than
   ep.maxpacket_limit.
 - Fixes a bug where GFP_KERNEL was used in atomic context

Andreas Larsson (7):
  usb: gadget: gr_udc: Make struct platform_device variable name
    clearer and use platform_set/get_drvdata
  usb: gadget: gr_udc: Expand devicetree documentation
  usb: gadget: gr_udc: Use platform_get_irq instead of
    irq_of_parse_and_map
  usb: gadget: gr_udc: Use of_property_read_u32_index to access arrays
  usb: gadget: gr_udc: Add ep.maxpacket_limit to debugfs information
  usb: gadget: gr_udc: Return error code when trying to set
    ep.maxpacket > ep.maxpacket_limit
  usb: gadget: gr_udc: Use GFP_ATOMIC when allocating under help
    spinlock

 Documentation/devicetree/bindings/usb/gr-udc.txt |   22 +++++----
 drivers/usb/gadget/gr_udc.c                      |   53 ++++++++++++----------
 2 files changed, 42 insertions(+), 33 deletions(-)

-- 
1.7.10.4

