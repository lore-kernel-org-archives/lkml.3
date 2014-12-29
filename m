Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301AbaL2Okz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 09:40:55 -0500
Received: from colo.foxharp.net ([166.84.7.52]:37230 "EHLO colo.foxharp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408AbaL2Okz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 09:40:55 -0500
X-Greylist: delayed 522 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Dec 2014 09:40:54 EST
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH v1] OLPC: use %*ph specifier instead of passing direct values
From: Paul Fox <pgf@laptop.org>
cc: linux-kernel@vger.kernel.org, Andres Salomon <dilinger@queued.net>,
        Andrew Morton <akpm@linux-foundation.org>
In-reply-to: <1419856010-9528-1-git-send-email-andriy.shevchenko@linux.intel.com> (sfid-20141229_072643_678691_70512A7F)
References: <1419856010-9528-1-git-send-email-andriy.shevchenko@linux.intel.com> (sfid-20141229_072643_678691_70512A7F)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <22121.1419863530.1@grass>
Date: Mon, 29 Dec 2014 09:32:10 -0500
Message-Id: <20141229143210.C9C685180445@grass.foxharp.boston.ma.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change looks okay to me.
 Acked-by: Paul Fox <pgf@laptop.org>

paul

andy wrote:
 > The %*ph specifier allows to dump small buffers in hex format. Let's use it
 > instead of passing direct values via stack.
 > 
 > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
 > ---
 >  drivers/platform/olpc/olpc-ec.c | 13 +++++--------
 >  1 file changed, 5 insertions(+), 8 deletions(-)
 > 
 > diff --git a/drivers/platform/olpc/olpc-ec.c b/drivers/platform/olpc/olpc-ec.c
 > index f911952..f99b183 100644
 > --- a/drivers/platform/olpc/olpc-ec.c
 > +++ b/drivers/platform/olpc/olpc-ec.c
 > @@ -192,18 +192,15 @@ static ssize_t ec_dbgfs_cmd_write(struct file *file, const char __user *buf,
 >  	for (i = 0; i <= ec_cmd_bytes; i++)
 >  		ec_cmd[i] = ec_cmd_int[i];
 >  
 > -	pr_debug("olpc-ec: debugfs cmd 0x%02x with %d args %02x %02x %02x %02x %02x, want %d returns\n",
 > -			ec_cmd[0], ec_cmd_bytes, ec_cmd[1], ec_cmd[2],
 > -			ec_cmd[3], ec_cmd[4], ec_cmd[5], ec_dbgfs_resp_bytes);
 > +	pr_debug("olpc-ec: debugfs cmd 0x%02x with %d args %5ph, want %d returns\n",
 > +			ec_cmd[0], ec_cmd_bytes, ec_cmd + 1,
 > +			ec_dbgfs_resp_bytes);
 >  
 >  	olpc_ec_cmd(ec_cmd[0], (ec_cmd_bytes == 0) ? NULL : &ec_cmd[1],
 >  			ec_cmd_bytes, ec_dbgfs_resp, ec_dbgfs_resp_bytes);
 >  
 > -	pr_debug("olpc-ec: response %02x %02x %02x %02x %02x %02x %02x %02x (%d bytes expected)\n",
 > -			ec_dbgfs_resp[0], ec_dbgfs_resp[1], ec_dbgfs_resp[2],
 > -			ec_dbgfs_resp[3], ec_dbgfs_resp[4], ec_dbgfs_resp[5],
 > -			ec_dbgfs_resp[6], ec_dbgfs_resp[7],
 > -			ec_dbgfs_resp_bytes);
 > +	pr_debug("olpc-ec: response %8ph (%d bytes expected)\n",
 > +			ec_dbgfs_resp, ec_dbgfs_resp_bytes);
 >  
 >  out:
 >  	mutex_unlock(&ec_dbgfs_lock);
 > -- 
 > 2.1.3

=---------------------
 paul fox, pgf@laptop.org
