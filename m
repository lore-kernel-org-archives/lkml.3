Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab3JZNaC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 09:30:02 -0400
Received: from shrek-wifi.podlesie.net ([93.179.225.50]:39419 "EHLO
	shrek.podlesie.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab3JZNaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 09:30:00 -0400
Date: Sat, 26 Oct 2013 15:29:56 +0200
From: Krzysztof Mazur <krzysiek@podlesie.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: usbatm: printk_ratelimit() always called in the atm_rldbg()
Message-ID: <20131026132955.GA9251@shrek.podlesie.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

commit 2d6401cf4ca3861692a4779745e0049cac769d10
("USB: usbatm: move the atm_dbg() call to use dynamic debug")
changed the atm_rldbg() to:

#define atm_rldbg(instance, format, arg...)		\
	if (printk_ratelimit())				\
		atm_dbg(instance , format , ## arg)

and now printk_ratelimit() is always called even when debugging is
disabled and a lot of "callbacks suppressed" messages are printed
by the printk_ratelimit():

[...]
usbatm_rx_process: 4977 callbacks suppressed
usbatm_extract_one_cell: 2920 callbacks suppressed
[...]


I'm not sure how to fix that, maybe we need dynamic_pr_debug_ratelimit()?

Krzysiek
