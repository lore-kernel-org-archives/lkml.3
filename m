Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab3AKGwy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 01:52:54 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:37307 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab3AKGwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 01:52:53 -0500
Date: Fri, 11 Jan 2013 09:52:44 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Danny Kukawka <danny.kukawka@bisect.de>, Jesper Juhl <jj@chaosbits.net>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] dac960: return success instead of -ENOTTY
Message-ID: <20130111065244.GD13207@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a missing break statement here.  This used to return directly
but we re-worked it in 2008 to add locking as part of the BKL push down.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/block/DAC960.c b/drivers/block/DAC960.c
index 9a13e88..0d3ffc5 100644
--- a/drivers/block/DAC960.c
+++ b/drivers/block/DAC960.c
@@ -7054,6 +7054,7 @@ static long DAC960_gam_ioctl(struct file *file, unsigned int Request,
 	else
 		ErrorCode =  0;
       }
+      break;
       default:
 	ErrorCode = -ENOTTY;
     }
