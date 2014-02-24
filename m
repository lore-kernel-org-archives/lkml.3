Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbaBXIHO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 03:07:14 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:24780 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbaBXIHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 03:07:10 -0500
Date: Mon, 24 Feb 2014 11:06:56 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        paul.gortmaker@windriver.com, linux-kernel@vger.kernel.org,
        ufimtseva@gmail.com
Subject: Re: [PATCH] staging: ced401: remove redundant spin_unlock
Message-ID: <20140224080656.GC26722@mwanda>
References: <3750536.lQYs9UcrV9@daeseok-laptop.cloud.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3750536.lQYs9UcrV9@daeseok-laptop.cloud.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 09:51:35AM +0900, Daeseok Youn wrote:
> >From 5e737e8211cd1f83488e484c088befc5feb755a9 Mon Sep 17 00:00:00 2001
> From: Daeseok Youn <daeseok.youn@gmail.com>
> Date: Mon, 24 Feb 2014 09:17:41 +0900
> Subject: [PATCH] staging: ced401: remove redundant spin_unlock

Don't send this header.  We get everything from the email header.

> 
> sparse says:
> drivers/staging/ced1401/usb1401.c:1080:28: warning:
>  context imbalance in 'Handle1401Esc' - unexpected unlock
> 

Your fix is correct, but the changelog is not good.  These messages in
Sparse are wrong over 80% of the time.  So when I see one in a commit
message I assume it is wrong.  Add some more explanation to say why you
removed the spin_unlock.

Also "redundant" means "unnecessary" but sort of implies that it is
harmless.  Say something like: "staging: ced401: fix double unlock bug".

regards,
dan carpenter

