Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821AbaJERBc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 13:01:32 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:39739 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751711AbaJERB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 13:01:29 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgkOAJ14MVRbsHoL/2dsb2JhbABegw65GwUBAQEBAQEFAQVummeBABcBe4RgI4EaiHkBsEuOX4YgiiUdhDUFhiuXE4xSiS6DZTuCeQEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fabian Frederick <fabf@skynet.be>, linux-serial@vger.kernel.org,
        sparclinux@vger.kernel.org
Subject: [PATCH 00/13 linux-next] drivers/tty: use container_of where possible
Date: Sun,  5 Oct 2014 19:01:01 +0200
Message-Id: <1412528475-1449-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Small patchset using container_of instead of casting on first structure member address.
All patches (cross)compiled but untested.


Fabian Frederick (13):
  serial: use container_of to resolve uart_sio_port from uart_port
  serial: sa1100: use container_of to resolve sa1100_port from uart_port
  serial: use container_of to resolve uart_ip22zilog_port from uart_port
  serial: mpsc: use container_of to resolve mpsc_port_info from
    uart_port
  serial: cpm_uart: use container_of to resolve uart_cpm_port from
    uart_port
  TTY: jsm: use container_of to resolve jsm_channel from uart_port
  tty: use container_of to resolve uart_pmac_port from uart_port
  serial: sunsu: use container_of to resolve uart_sunsu_port from
    uart_port
  serial: sunsab: use container_of to resolve uart_sunsu_port from
    uart_port
  serial: amba-pl010: use container_of to resolve uart_amba_port from
    uart_port
  serial: pnx8xxx:  use container_of to resolve pnx8xxx_port from
    uart_port
  serial: use container_of to resolve uart_sunzilog_port from uart_port
  tty: ar933x_uart: use container_of to resolve ar933x_uart_port from
    uart_port

 drivers/tty/serial/amba-pl010.c             | 36 ++++++++++++++--------
 drivers/tty/serial/ar933x_uart.c            | 30 ++++++++++++------
 drivers/tty/serial/cpm_uart/cpm_uart_core.c | 48 +++++++++++++++++++----------
 drivers/tty/serial/ip22zilog.c              | 18 +++++++----
 drivers/tty/serial/jsm/jsm_tty.c            | 30 ++++++++++++------
 drivers/tty/serial/m32r_sio.c               | 42 ++++++++++++++++---------
 drivers/tty/serial/mpsc.c                   | 39 +++++++++++++++--------
 drivers/tty/serial/pmac_zilog.c             |  9 ++++--
 drivers/tty/serial/pnx8xxx_uart.c           | 48 +++++++++++++++++++----------
 drivers/tty/serial/sa1100.c                 | 45 ++++++++++++++++++---------
 drivers/tty/serial/sunsab.c                 | 36 ++++++++++++++--------
 drivers/tty/serial/sunsu.c                  | 39 +++++++++++++++--------
 drivers/tty/serial/sunzilog.c               | 24 ++++++++++-----
 13 files changed, 296 insertions(+), 148 deletions(-)

-- 
1.9.1

