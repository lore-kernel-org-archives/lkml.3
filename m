Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab3GXVyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 17:54:09 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:37775 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab3GXVyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 17:54:07 -0400
Date: Thu, 25 Jul 2013 00:53:40 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Won Kang <wkang77@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, wonkang@gctsemi.com
Subject: Re: [PATCH v2 1/2] staging: gdm7240: adding LTE USB driver
Message-ID: <20130724215340.GY5585@mwanda>
References: <1374476192-7801-1-git-send-email-wonkang@gctsemi.com>
 <1374690977-10877-1-git-send-email-wonkang@gctsemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374690977-10877-1-git-send-email-wonkang@gctsemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static int gdm_lte_ioctl_get_data(struct wm_req_t *req, struct net_device *dev)
> +{
> +	u16 id = req->data_id;
> +
> +	switch (id) {
> +	case GET_ENDIAN_INFO:
> +		/* required for the user space application to find out device endian */
> +		get_dev_endian(&req->data, dev);
> +		break;
> +	default:
> +		printk(KERN_ERR "glte: ioctl - unknown type %d\n", id);
> +		break;
> +	}
> +	return 0;
> +}

This should be a sysfs file not an ioctl.  What would break if we
fixed this right now (as opposed to waiting until we can't change
the API?).

Otherwise if we can't change this, then it should return an error
code instead of printing a message.

regards,
dan carpenter

