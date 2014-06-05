Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455AbaFEUxx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 16:53:53 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:58971 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbaFEUxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 16:53:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/2] serial: pxa: fix build with !SERIAL_PXA_CONSOLE
Date: Thu, 05 Jun 2014 22:53:47 +0200
Message-ID: <4618166.h1v6p4h6Yh@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:XGdIFc9vW2sfqB8L4JjwM/qQgLp6/6DPFmHhP62F/gN
 yujGrRYZlwwrNZ5UlYldFql7MK1a93vQjz7OFhYm1hs6vuYelI
 wLVGwl6oMzuPCfYYS2l888JIJ9Bih6egnplDINyFcs7UGy22mW
 6wlJDhA9ubHqwBqRcZDadqJE59k2+j/787K/HAouPwvwKIpMKV
 14BvOGkMM1Mb7LS82VZAE1R4b9ix5o68qMYEhyhWrHU+ioKSSA
 M9Qqs6eii4LGGXoN4ruVs81+jq5rYOqEHiFoguEkVLc6uLumxW
 5dhlEprks4cJZlYntSrFDmlpjwthTK/C9kZ1K+XDU06XqKUna0
 YnBhwEmprf+/nkZ80dKo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 7a1b0f67c197553f00fc493bb876b6f3237a3738 Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 18 Feb 2014 16:14:20 +0100
Subject: [PATCH] serial: pxa: fix build with !SERIAL_PXA_CONSOLE

When CONFIG_SERIAL_PXA_CONSOLE is disabled, the serial_pxa_get_poll_char
and serial_pxa_put_poll_char functions are not defined, and we can't
reference them.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/tty/serial/pxa.c b/drivers/tty/serial/pxa.c
index 9e7ee39..05a0323 100644
--- a/drivers/tty/serial/pxa.c
+++ b/drivers/tty/serial/pxa.c
@@ -778,7 +778,7 @@ static struct uart_ops serial_pxa_pops = {
 	.request_port	= serial_pxa_request_port,
 	.config_port	= serial_pxa_config_port,
 	.verify_port	= serial_pxa_verify_port,
-#ifdef CONFIG_CONSOLE_POLL
+#if defined(CONFIG_CONSOLE_POLL) && defined(CONFIG_SERIAL_PXA_CONSOLE)
 	.poll_get_char = serial_pxa_get_poll_char,
 	.poll_put_char = serial_pxa_put_poll_char,
 #endif

