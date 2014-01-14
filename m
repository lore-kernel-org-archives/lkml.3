Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562AbaANN4R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 08:56:17 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:42520 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbaANN4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 08:56:15 -0500
Date: Tue, 14 Jan 2014 16:55:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Alex Dubov <oakad@yahoo.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        driverdev-devel@linuxdriverproject.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, wei_wang@realsil.com.cn,
        rogerable@realtek.com, Chris Ball <cjb@laptop.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [PATCH 1/3] mfd: Add realtek USB card reader driver
Message-ID: <20140114135551.GN7444@mwanda>
References: <1389685656-880-1-git-send-email-rogerable@realtek.com>
 <1389685656-880-2-git-send-email-rogerable@realtek.com>
 <20140114130409.GB11820@lee--X1>
 <20140114134634.GM7444@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140114134634.GM7444@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 04:46:34PM +0300, Dan Carpenter wrote:
> [ Sorry, I am coming down with the flu today so I'm doing dorky things
>   like reviewing review comments.  I'm not sure how coherent I am.  ]
> 
> On Tue, Jan 14, 2014 at 01:04:09PM +0000, Lee Jones wrote:
>  
> > > +static void rtsx_usb_sg_timed_out(unsigned long data)
> > > +{
> > > +	struct rtsx_ucr *ucr = (struct rtsx_ucr *)data;
> > 
> > What's going to happen when your device runs 64bit?
> > 
> 
> I'm not sure I understand what you mean here.  On linux sizeof(long) is
> always the same as sizeof(void *).
> 
> 
> > > +	if (cmd_len > IOBUF_SIZE)
> > > +		return -EINVAL;
> > > +
> > > +	if (cmd_len % 4)
> > > +		cmd_len += (4 - cmd_len % 4);
> > 
> > Please document in a comment.
> 
> There is a kernel macro for this:
> 
> 	cmd_len = ALIGN(cmd_len, 4);
> 

Btw, what's the difference between ALIGN(cmd_len, 4) and
round_up(cmd_len, 4)?  Maybe round_up() is better.

regards,
dan carpenter
