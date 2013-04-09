Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460Ab3DIFUo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 01:20:44 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:37732 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab3DIFUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 01:20:43 -0400
Date: Tue, 9 Apr 2013 08:18:38 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jiri Slaby <jirislaby@gmail.com>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] tty: mxser: forever loops on error
Message-ID: <20130409051838.GB1516@longonot.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were a couple signedness bugs decrementing "i" which would lead to
a forever loops.

I've made a couple other variables signed as well because they are all
related array offsets and it would be weird if they weren't the same
type.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/tty/mxser.c b/drivers/tty/mxser.c
index d996038..a095859 100644
--- a/drivers/tty/mxser.c
+++ b/drivers/tty/mxser.c
@@ -2556,9 +2556,9 @@ static int mxser_probe(struct pci_dev *pdev,
 {
 #ifdef CONFIG_PCI
 	struct mxser_board *brd;
-	unsigned int i, j;
 	unsigned long ioaddress;
 	struct device *tty_dev;
+	int i, j;
 	int retval = -EINVAL;
 
 	for (i = 0; i < MXSER_BOARDS; i++)
@@ -2700,7 +2700,7 @@ static int __init mxser_module_init(void)
 {
 	struct mxser_board *brd;
 	struct device *tty_dev;
-	unsigned int b, i, m;
+	int b, i, m;
 	int retval;
 
 	mxvar_sdriver = alloc_tty_driver(MXSER_PORTS + 1);
