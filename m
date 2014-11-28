Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804AbaK1NvN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 08:51:13 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:48940 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbaK1NvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 08:51:08 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Peter Chen <peter.chen@freescale.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 00/17] net2280: Code cleanout, improve debug and remove broken param
Date: Fri, 28 Nov 2014 14:50:45 +0100
Message-Id: <1417182662-7405-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches removes broken parameter use_dma_chaining, and the
unneeded full_speed,use_dma and use_msi.

Then does some code cleanout by removing duplicated and dead code.

Finally it removes the unconditional removed debug messages, since
they can be enabled by the user via dynamic printk.

Due to the fact that I am implementing the scather gatter on the top of
this tree I would like to get this merged/reviewed before continuing.

Ricardo Ribalda Delgado (17):
  net2280: Remove obsolete module param use_dma_chaining
  net2280: remove full_speed module parameter
  net2280: Remove module parameter use_msi
  net2280: Remove use_dma module parameter
  net2280: Remove dma_started field
  net2280: Remove restart_dma inline function definition
  net2280: Code cleanout remove ep_stdrsp function
  net2280: Remove field is_halt
  net2280: Remove function ep_stall
  net2280: Merge abort_dma for 228x and 338x
  net2280: Clean function net2280_queue
  net2280: Improve patching of defect 7374
  net2280: Remove function resume_dma
  net2280: Declare allow_status_338x as inline
  net2280: Simplify scan_dma_completions
  net2280: Move ASSERT_OUT_NAKING into out_flush
  net2280: Re-enable dynamic debug messages

 drivers/usb/gadget/udc/net2280.c | 525 ++++++++++-----------------------------
 drivers/usb/gadget/udc/net2280.h |  23 +-
 2 files changed, 129 insertions(+), 419 deletions(-)

-- 
2.1.3

