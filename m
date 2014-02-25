Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115AbaBYAm0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 19:42:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52525 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbaBYAmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 19:42:24 -0500
Date: Mon, 24 Feb 2014 16:43:57 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: devel@driverdev.osuosl.org, paul.gortmaker@windriver.com,
        dan.carpenter@oracle.com, linux-kernel@vger.kernel.org,
        ufimtseva@gmail.com
Subject: Re: [PATCH v2] staging: ced401: fix double unlock bug
Message-ID: <20140225004357.GA28255@kroah.com>
References: <6036697.Bsd6uoTeJ1@daeseok-laptop.cloud.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6036697.Bsd6uoTeJ1@daeseok-laptop.cloud.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
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
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>

This patch doesn't apply to my tree, can you please redo it against
linux-next and resend it so that I can apply it?

thanks,

greg k-h
