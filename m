Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671AbaENOz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 10:55:58 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:42521 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754861AbaENOzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 10:55:55 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org
Cc: patches@linaro.org, linaro-kernel@lists.linaro.org,
        Daniel Thompson <daniel.thompson@linaro.org>,
        linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 0/4] serial: kgdb_nmi: Allow ttyNMIX to act as primary console
Date: Wed, 14 May 2014 15:55:31 +0100
Message-Id: <1400079335-32125-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset contains a number of fixes to make it possible to use
ttyNMIX as the primary console, providing you also have that the
additional architecture specific code to support it.

The first patch is a generic improvement to make the behaviour of
poll_put_char consistent for all UARTs. This is especially important
for kgdb_nmi, which makes unusually heavy use of poll_put_char,
although this fix also benefits other users of polled I/O.

The remaining patches are specific to kgdb_nmi and have no effect on
any other part of the kernel.

The series has been runtime tested on ARM and compile tested on
x86 and powerpc.

Daniel Thompson (4):
  serial: core: Consistent LF handling for poll_put_char
  serial: kgdb_nmi: Use container_of() to locate private data
  serial: kgdb_nmi: Switch from tasklets to real timers
  serial: kgdb_nmi: Improve console integration with KDB I/O

 drivers/tty/serial/8250/8250_core.c         |  5 ---
 drivers/tty/serial/cpm_uart/cpm_uart_core.c |  8 ++--
 drivers/tty/serial/kgdb_nmi.c               | 59 +++++++++++++----------------
 drivers/tty/serial/pch_uart.c               |  5 ---
 drivers/tty/serial/pxa.c                    |  5 ---
 drivers/tty/serial/serial_core.c            |  2 +
 drivers/tty/serial/serial_txx9.c            |  5 ---
 7 files changed, 33 insertions(+), 56 deletions(-)

-- 
1.9.0

