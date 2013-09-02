Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576Ab3IBAiJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 20:38:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40140 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338Ab3IBAiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 20:38:08 -0400
Date: Sun, 1 Sep 2013 17:38:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com
Subject: Re: [PATCH 2/3] extcon: Change field type of 'dev' in extcon_dev
 structure
Message-ID: <20130902003807.GA10709@kroah.com>
References: <1378081208-20274-1-git-send-email-cw00.choi@samsung.com>
 <1378081208-20274-3-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378081208-20274-3-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 09:20:07AM +0900, Chanwoo Choi wrote:
> -	edev->dev = kzalloc(sizeof(struct device), GFP_KERNEL);
> -	if (!edev->dev)
> -		return -ENOMEM;
> -	edev->dev->parent = dev;
> -	edev->dev->class = extcon_class;
> -	edev->dev->release = extcon_dev_release;
> +	edev->dev.parent = dev;
> +	edev->dev.class = extcon_class;
> +	edev->dev.release = extcon_dev_release;

You didn't change extcon_dev_release() to properly free all of the
memory you allocated here, otherwise the slab allocator will oops when
you try to call it...

thanks,

greg k-h
