Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488Ab3L0RkY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 12:40:24 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:59806 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923Ab3L0RkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 12:40:23 -0500
Date: Fri, 27 Dec 2013 12:40:22 -0500 (EST)
Message-Id: <20131227.124022.439150072696415687.davem@davemloft.net>
To: levex@linux.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 19/38] net: atm: add missing put_device call
From: David Miller <davem@davemloft.net>
In-Reply-To: <1387465429-3568-20-git-send-email-levex@linux.com>
References: <1387465429-3568-2-git-send-email-levex@linux.com>
	<1387465429-3568-20-git-send-email-levex@linux.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 27 Dec 2013 09:40:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Levente Kurusa <levex@linux.com>
Date: Thu, 19 Dec 2013 16:03:30 +0100

> This is required so that we give up the last reference to the device.
> 
> Signed-off-by: Levente Kurusa <levex@linux.com>
 ...
> @@ -154,8 +154,10 @@ int atm_register_sysfs(struct atm_dev *adev, struct device *parent)
>  
>  	dev_set_name(cdev, "%s%d", adev->type, adev->number);
>  	err = device_register(cdev);
> -	if (err < 0)
> +	if (err < 0) {
> +		put_device(cdev);
>  		return err;
> +	}

This doesn't make any sense.

Nothing has a reference to 'cdev'.  Yes, 'adev' has a reference,
acquired by the caller of this function, but that's not what we're
working with here.
