Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab3FZVxA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 17:53:00 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:55194 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab3FZVw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 17:52:58 -0400
Date: Wed, 26 Jun 2013 14:52:56 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Vivek Gautam <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: sleeping while atomic in dwc3_gadget_start
Message-ID: <20130626215256.GC11625@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm getting the folllowing BUG message on bootup with 3.10-rc5

BUG: sleeping function called from invalid context at mm/slub.c:926
in_atomic(): 1, irqs_disabled(): 128, pid: 1, name: swapper/0
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.0-rc5-gee3e35b-09316-ge78f3b35 #643
[<c0014220>] (unwind_backtrace+0x0/0x120) from [<c001212c>] (show_stack+0x10/0x14)
[<c001212c>] (show_stack+0x10/0x14) from [<c0143750>] (kmem_cache_alloc_trace+0x3c/0x210)
[<c0143750>] (kmem_cache_alloc_trace+0x3c/0x210) from [<c00e0c60>] (request_threaded_irq+0x88/0x11c)
[<c00e0c60>] (request_threaded_irq+0x88/0x11c) from [<c03bf53c>] (dwc3_gadget_start+0x198/0x200)
[<c03bf53c>] (dwc3_gadget_start+0x198/0x200) from [<c03f7a5c>] (udc_bind_to_driver+0x70/0xd8)
[<c03f7a5c>] (udc_bind_to_driver+0x70/0xd8) from [<c03f7b50>] (usb_gadget_probe_driver+0x8c/0xb8)

and I suspect this problem was introduced in commit 8698e2acf
(usb: dwc3: gadget: introduce and use enable/disable irq
methods). Is there a fix for this problem? Can we just move the
irq request outside the spinlock?
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
