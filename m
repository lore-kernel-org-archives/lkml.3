Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbaBHSZg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 13:25:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40678 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbaBHSZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 13:25:35 -0500
Date: Sat, 8 Feb 2014 10:27:29 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: falcon@meizu.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] async: async device driver probing
Message-ID: <20140208182729.GB10892@kroah.com>
References: <1391857539-27782-1-git-send-email-falcon@meizu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391857539-27782-1-git-send-email-falcon@meizu.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 08, 2014 at 07:05:38PM +0800, falcon@meizu.com wrote:
> From: Wu Zhangjin <wuzhangjin@gmail.com>
> 
> [*Note*: NOT applicable, only for comments.]
> 
> To async the slow driver probing function of some devices, the device probing
> support is modified to support async scheduling.
> 
> In order to async your driver probing function, please mask the async_probe
> flag to 1, and to make sure one asynced probing is executed before an specified
> point, please call async_synchronize_full() in that point..
> 
> Usage:
> 
> 	static struct i2c_driver test_driver = {
> 		.driver = {
> 			.name   = TEST_DEV_NAME,
> 			.owner  = THIS_MODULE,
> 	+               .async_probe = 1,
> 		},

Why is this needed, we have defered probing and the container stuff, so
what problem is this solving?

greg k-h
