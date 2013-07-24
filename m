Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab3GXWGf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 18:06:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55429 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab3GXWGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 18:06:32 -0400
Date: Wed, 24 Jul 2013 15:06:31 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Won Kang <wkang77@gmail.com>, devel@driverdev.osuosl.org,
        wonkang@gctsemi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] staging: gdm7240: adding LTE USB driver
Message-ID: <20130724220631.GA10541@kroah.com>
References: <1374476192-7801-1-git-send-email-wonkang@gctsemi.com>
 <1374690977-10877-1-git-send-email-wonkang@gctsemi.com>
 <20130724215340.GY5585@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130724215340.GY5585@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 12:53:40AM +0300, Dan Carpenter wrote:
> > +static int gdm_lte_ioctl_get_data(struct wm_req_t *req, struct net_device *dev)
> > +{
> > +	u16 id = req->data_id;
> > +
> > +	switch (id) {
> > +	case GET_ENDIAN_INFO:
> > +		/* required for the user space application to find out device endian */
> > +		get_dev_endian(&req->data, dev);
> > +		break;
> > +	default:
> > +		printk(KERN_ERR "glte: ioctl - unknown type %d\n", id);
> > +		break;
> > +	}
> > +	return 0;
> > +}
> 
> This should be a sysfs file not an ioctl.  What would break if we
> fixed this right now (as opposed to waiting until we can't change
> the API?).
> 
> Otherwise if we can't change this, then it should return an error
> code instead of printing a message.

It should just be removed, why would you care about the endian-ness of
the device at all?

thanks,

greg k-h
