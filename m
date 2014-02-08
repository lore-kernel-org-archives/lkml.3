Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbaBHS0V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 13:26:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40682 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbaBHS0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 13:26:21 -0500
Date: Sat, 8 Feb 2014 10:28:15 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: falcon@meizu.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] async: Allow to group the asynced device probings
Message-ID: <20140208182815.GC10892@kroah.com>
References: <1391857539-27782-1-git-send-email-falcon@meizu.com>
 <1391857539-27782-2-git-send-email-falcon@meizu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391857539-27782-2-git-send-email-falcon@meizu.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 08, 2014 at 07:05:39PM +0800, falcon@meizu.com wrote:
> From: Wu Zhangjin <falcon@meizu.com>
> 
> [*Note*: NOT applicable, only for comments.]
> 
> This allows to schedule a group of probings in order.
> 
> Usage:
> 
> If the probing of driver2 depends on the probing of driver1, we can put them
> into a group, here put them into a group named domain 1, they will be probed in
> the linking order.
> 
> ...
> 
> static struct platform_driver first_driver = {
>  	.probe = first_driver_probe,
>  	.driver		= {
>  		.name	= "first driver",
> +		.async_probe = 1,
> +		.async_domain = 1,
>  	},
>  };
> 
> ...
> 
> static struct platform_driver second_driver = {
>  	.probe = second_driver_probe,
>  	.driver		= {
>  		.name	= "second_driver",
> +		.async_probe = 1,
> +		.async_domain = 1,
>  	},
>  };
> 
> ...
> 
> With this feature, it is possible to async different class of drivers, for
> example, put all sound drivers into domain 2, put all display/video drivers
> into domain 3, and sensors domain 4, network drivers domain 5 and so forth.

That sounds like a recipie for massive confusion.

Again, what problem is this trying to solve?

greg k-h
