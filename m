Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295Ab3GYEgb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 00:36:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57713 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab3GYEg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 00:36:29 -0400
Date: Wed, 24 Jul 2013 21:37:41 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Won Kang <wkang77@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        wonkang@gctsemi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] staging: gdm7240: adding LTE USB driver
Message-ID: <20130725043741.GA11906@kroah.com>
References: <1374476192-7801-1-git-send-email-wonkang@gctsemi.com>
 <1374690977-10877-1-git-send-email-wonkang@gctsemi.com>
 <20130724215340.GY5585@mwanda>
 <20130724220631.GA10541@kroah.com>
 <CABe_0=+bXAuXhG+XG4ObUO_2MYD_XWxF_wbTVrpKagmHi8_CDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABe_0=+bXAuXhG+XG4ObUO_2MYD_XWxF_wbTVrpKagmHi8_CDQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Thu, Jul 25, 2013 at 01:15:07PM +0900, Won Kang wrote:
> GDM7240 is in LE where as GDM7243 (currently under development) is in BE.

But why does this information need to be sent to userspace?

> User space applications needs to discover the endianess to properly
> encode/decode LTE control protocols. We have existing customers
> already deploying units in large volume, and want to avoid forcing
> them to change SDK APIs along with kernel updates.
> At some point, It will have to be fixed with SDK API can interoperate properly.

Ugh, really?  What special tools does userspace need to talk to this
device?  It "should" just be a network device, and a serial port, why
does the endianness of the device mean anything?

Custom ioctls aren't ok for new drivers, if at all possible.  Can't
userspace just trigger this based on the device id instead?

thanks,

greg k-h
