Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762838Ab3JQVIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 17:08:35 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:56306 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759409Ab3JQVIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 17:08:32 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH 00/10] tty: xuartps: Update
Date: Thu, 17 Oct 2013 14:08:03 -0700
Message-Id: <1382044093-29905-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a series of patches to update the xuartps driver. Most of these
are contributions to our vendor tree that I ported on top of the current
mainline tree.

The highlights are:
 - support magic-sysrq and kgdb by Vlad
 - a fix for a deadlock condition by Lars
 - support for suspend/resume
 - dynamic adjustment on input clock changes

	Sören

Lars-Peter Clausen (1):
  tty: xuartps: Force enable the UART in xuartps_console_write

Soren Brinkmann (6):
  tty: xuartps: Use devm_clk_get()
  tty: xuartps: Use devm_kzalloc
  tty: xuartps: Updating set_baud_rate()
  tty: xuartps: Dynamically adjust to input frequency changes
  tty: xuartps: Implement suspend/resume callbacks
  tty: xuartps: Update copyright information

Suneel (1):
  tty: xuartps: support 64 byte FIFO size

Vlad Lungu (2):
  tty: xuartps: Implement BREAK detection, add SYSRQ support
  tty: xuartps: Add polled mode support for xuartps

 drivers/tty/serial/xilinx_uartps.c | 543 ++++++++++++++++++++++++++++++++-----
 1 file changed, 469 insertions(+), 74 deletions(-)

-- 
1.8.4.1

