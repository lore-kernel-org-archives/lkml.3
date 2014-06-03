Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934186AbaFCVXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 17:23:18 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:37660 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932651AbaFCVXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 17:23:17 -0400
Date: Wed, 4 Jun 2014 02:53:09 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH 0/2] Fix double clk_diable and use _devm functions
Message-ID: <cover.1401828519.git.himangi774@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first patch fixed the bug of calling clk_disable when the clk is
not enabled and the second patch uses devm function and removes the
corresponding free and error handling code and does away with all
labels in the probe function.

Himangi Saraogi (2):
  usb: gadget: mv_u3d_core: Correct clk_disable twice
  usb: gadget: mv_u3d_core: use devm_ functions

 drivers/usb/gadget/mv_u3d_core.c | 131 ++++++++++-----------------------------
 1 file changed, 34 insertions(+), 97 deletions(-)

-- 
1.9.1

