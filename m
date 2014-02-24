Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495AbaBXKcJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 05:32:09 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:22661 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbaBXKcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 05:32:05 -0500
Date: Mon, 24 Feb 2014 13:31:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: gregkh@linuxfoundation.org, ufimtseva@gmail.com,
        paul.gortmaker@windriver.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: ced401: fix double unlock bug
Message-ID: <20140224103151.GO26776@mwanda>
References: <6036697.Bsd6uoTeJ1@daeseok-laptop.cloud.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6036697.Bsd6uoTeJ1@daeseok-laptop.cloud.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 07:23:15PM +0900, Daeseok Youn wrote:
> 
> After spin_lock() is called, all of if-else conditions in this brace
> should reach the end of else and spin_unlock() must be called.
> So It doesn't need to call spin_unlock() without a return statement
> for handling an error.
> 
> Also sparse says:
> drivers/staging/ced1401/usb1401.c:1080:28: warning:
>  context imbalance in 'Handle1401Esc' - unexpected unlock
> 

Thank you.

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

