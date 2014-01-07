Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751354AbaAGKlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 05:41:45 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:39722 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbaAGKlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 05:41:42 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: Leilei Zhao <leilei.zhao@atmel.com>, <mark.roszko@gmail.com>,
        <mdeneen@gmail.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 0/4] tty/serial: at91: fixes dealing with port shutdown
Date: Tue, 7 Jan 2014 11:41:35 +0100
Message-ID: <cover.1389090437.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These four fixes are pretty important for our atmel_serial driver as they
deal with closing/re-opening of ports. They fix race condition and
null pointers dereference.
I added the "stable" tag to each of them (v3.12).

Even if we are late in the development cycle, can you please consider including
these patches for 3.13?

Thanks, best regards,
   Nicolas Ferre

Marek Roszko (3):
  tty/serial: at91: Handle shutdown more safely
  tty/serial: at91: fix race condition in atmel_serial_remove
  tty/serial: at91: prevent null dereference in tasklet function

Mark Deneen (1):
  tty/serial: at91: reset rx_ring when port is shutdown

 drivers/tty/serial/atmel_serial.c | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

-- 
1.8.2.2

