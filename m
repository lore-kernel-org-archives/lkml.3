Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab3JUXlN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 19:41:13 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:47205 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab3JUXlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 19:41:10 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH 0/3] tty: xuartps: Fix build
Date: Mon, 21 Oct 2013 16:40:58 -0700
Message-Id: <1382398861-21542-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should fix the issues in the x86 build of the xuartps driver. The
issues are:
 - [tty:tty-next 72/75] drivers/tty/serial/xilinx_uartps.c:436:7: error:
   'PRE_RATE_CHANGE' undeclared
 - [tty:tty-next 73/75] drivers/tty/serial/xilinx_uartps.c:1227:21:
   error: 'xuartps_uart_driver' undeclared

Additionally I found some build warnings while fixing those issues.

There are some additional comments regarding patches 1 and 3 in their
respective email.
This series is based on the tty-next tree.

	Thanks,
	Sören

Soren Brinkmann (3):
  tty: xuartps: Fix "may be used uninitialized" build warning
  tty: xuartps: Fix build error due to missing forward declaration
  tty: xuartps: Fix build error when COMMON_CLK is not set

 drivers/tty/serial/xilinx_uartps.c | 38 +++++++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 15 deletions(-)

-- 
1.8.4.1

