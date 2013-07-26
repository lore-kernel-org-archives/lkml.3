Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932475Ab3GZWEQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 18:04:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51865 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab3GZWED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 18:04:03 -0400
Date: Fri, 26 Jul 2013 15:04:01 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Wei Yongjun <weiyj.lk@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, yongjun_wei@trendmicro.com.cn,
        wonkang@gctsemi.com, joe@perches.com
Subject: Re: [PATCH -next] staging: gdm724x: use GFP_ATOMIC under spin lock
Message-ID: <20130726220401.GA6735@kroah.com>
References: <CAPgLHd-WN2VF7vEjUn0uLd_RQYYF1qvUy1TUz4EmyPbi=8JQ4g@mail.gmail.com>
 <20130726073233.GD5585@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130726073233.GD5585@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 10:32:33AM +0300, Dan Carpenter wrote:
> On Fri, Jul 26, 2013 at 10:15:55AM +0800, Wei Yongjun wrote:
> > From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> > 
> > A spin lock is taken here so we should use GFP_ATOMIC.
> > 
> 
> Acked-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> But the locking here is really odd and pointless.  usb_submit_urb()
> returns asynchronously before the data has been sent, so there is
> almost no point in locking around it.

There's no guarantee it will return before the complete() call is made,
so the data could be sent and then received before the call returns.

Not to say that the locking doesn't seem wrong, I agree with that...

thanks,

greg k-h
