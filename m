Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbaATJHq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 04:07:46 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:52161 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbaATJHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 04:07:05 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: jslaby@suse.cz, gregkh@linuxfoundation.org, linux@arm.linux.org.uk,
        ben.dooks@codethink.co.uk, broonie@kernel.org
Subject: [PATCH 0/2] serial: Move uart_register_driver call to device probe
Date: Mon, 20 Jan 2014 14:32:33 +0530
Message-Id: <1390208555-27770-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In a multiplatform scenario, it is possible that multiple serial
drivers are part of the kernel. Currently the driver registration fails
if multiple serial drivers with same default major/minor numbers are
included in the kernel. A typical case is observed with amba-pl011 and
samsung-uart drivers.

This is the 3rd iteration to fix above problem.

Iteration 1:
[PATCH] serial: samsung: Remove hard-coded major/minor numbers
https://lkml.org/lkml/2013/12/27/2

Iteration 2:
[PATCH] tty: Fallback to use dynamic major number
https://lkml.org/lkml/2014/1/16/2

Both these approaches were rejected because they were breaking userspace
interface.

Iteration 3:
uart_register_driver call binds the driver to a specific device
node through tty_driver_register call. This is moved to device probe call.

Tushar Behera (2):
  serial: samsung: Move uart_register_driver call to device probe
  serial: pl011: Move uart_register_driver call to device probe

 drivers/tty/serial/amba-pl011.c |   21 +++++++++++---------
 drivers/tty/serial/samsung.c    |   40 +++++++++++----------------------------
 2 files changed, 23 insertions(+), 38 deletions(-)

-- 
1.7.9.5

