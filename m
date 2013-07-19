Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759646Ab3GSFxc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:53:32 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:25460 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755817Ab3GSFx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:53:29 -0400
Date: Fri, 19 Jul 2013 08:53:13 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] TTY: snyclinkmp: calculating wrong addresses
Message-ID: <20130719055313.GF9729@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a static checker fix and I don't have a way to test it.  But
from the context it looks like this is a typo where SCABUFSIZE was
intended instead of sizeof(SCABUFSIZE).  SCABUFSIZE is 1024 and
sizeof(int) is 4.  I would suspect this is a bad bug.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/tty/synclinkmp.c b/drivers/tty/synclinkmp.c
index ff17138..dc6e969 100644
--- a/drivers/tty/synclinkmp.c
+++ b/drivers/tty/synclinkmp.c
@@ -3478,7 +3478,7 @@ static int alloc_buf_list(SLMP_INFO *info)
 	for ( i = 0; i < info->rx_buf_count; i++ ) {
 		/* calculate and store physical address of this buffer entry */
 		info->rx_buf_list_ex[i].phys_entry =
-			info->buffer_list_phys + (i * sizeof(SCABUFSIZE));
+			info->buffer_list_phys + (i * SCABUFSIZE);
 
 		/* calculate and store physical address of */
 		/* next entry in cirular list of entries */
