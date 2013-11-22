Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab3KVIZe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 03:25:34 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:21091 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab3KVIZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 03:25:33 -0500
Date: Fri, 22 Nov 2013 11:25:25 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andreas Platschek <andi.platschek@gmail.com>
Cc: gregkh@linuxfoundation.org, jslaby@suse.cz, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] tty: replace mutex_lock() with tty_write_lock()
Message-ID: <20131122082525.GA5302@mwanda>
References: <1385061132-7254-1-git-send-email-andi.platschek@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385061132-7254-1-git-send-email-andi.platschek@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 08:12:12PM +0100, Andreas Platschek wrote:
> Use tty_write_lock()/tty_write_unlock() consistently.
> 
> This takes care of the following sparse warning:
> drivers/tty/tty_io.c:1169:17: warning: context imbalance in 'tty_write_message' - unexpected unlock
> 

I don't think we can do this.  mutex_lock() always succeeds and
tty_write_lock() can fail.

I think we just have to live with the error message.

regards,
dan carpenter

