Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbaCCIFo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 03:05:44 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:38892 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbaCCIFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 03:05:42 -0500
Date: Mon, 3 Mar 2014 11:05:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Surendra Patil <surendra.tux@gmail.com>
Cc: rupesh.gujare@atmel.com, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Drivers:staging:ozwpan Replaced wrapper functions with
 actual spin lock function calls
Message-ID: <20140303080527.GH26722@mwanda>
References: <1393729160-23931-1-git-send-email-surendra.tux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393729160-23931-1-git-send-email-surendra.tux@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a bug.

On Sat, Mar 01, 2014 at 06:59:20PM -0800, Surendra Patil wrote:
> Replaced all the spin lock/unlock wrappers from oz_polling_lock_bh()
> and oz_polllin_unlock_bh() with spin_lock_bh(&g_polling_lock) and
> spin_unlock_bh(&g_polling_lock).Completely erased the wrappers defination
> and declaration.
> Module builded successfully with sparse without warnings.
> 
> Signed-off-by: Surendra Patil <surendra.tux@gmail.com>
> ---
>  drivers/staging/ozwpan/ozpd.c    | 29 +++++++++++++++--------------
>  drivers/staging/ozwpan/ozproto.c |  9 ---------
>  drivers/staging/ozwpan/ozproto.h |  2 --
>  3 files changed, 15 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/staging/ozwpan/ozpd.c b/drivers/staging/ozwpan/ozpd.c
> index 7436950..66c3a2c 100644
> --- a/drivers/staging/ozwpan/ozpd.c
> +++ b/drivers/staging/ozwpan/ozpd.c
> @@ -22,6 +22,7 @@
>  
>  #define OZ_MAX_TX_POOL_SIZE	6
>  
> +static DEFINE_SPINLOCK(g_polling_lock);

This doesn't work.  Now you have two lock variables which just happen to
have the same name.

You need to make the original g_polling_lock not static and add a
declaration to the header file.

regards,
dan carpenter

