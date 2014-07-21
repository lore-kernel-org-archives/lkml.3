Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932878AbaGUPjH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 11:39:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37752 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932322AbaGUPjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 11:39:05 -0400
Date: Mon, 21 Jul 2014 08:38:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: pp <mnipxh@gmail.com>
Cc: jslaby@suse.cz, linux-kernel@vger.kernel.org, yanmin_zhang@linux.intel.com,
        xinhuix.pan@intel.com
Subject: Re: [PATCH] tty/tty_io.c: make a check before reuse cdev
Message-ID: <20140721153840.GA6802@kroah.com>
References: <53CD0BD4.4050007@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53CD0BD4.4050007@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 08:47:16PM +0800, pp wrote:
> As reuse the cdev may cause panic. After we unregister the tty device, we may use tty_hangup() o
> other similar function to send a signal(SIGHUP) to process which has opend our device. But that
> not succeed if the process couldn't get the signal. for example, a process forked
> but his parent quited never get SIGHUP.
> 
> Here is our scence.
> tty driver register its device and init the cdevs, then process "A" open one cdev.
> tty driver unregister its device and cdev_del the cdevs, call tty_hangup to (S)send signal SIGHUP to process A.
> But that step(S) fails.

How can that fail?  What driver does this fail for?

> tty driver register its device and (D)init the cdevs again.

What driver does this with an "old" device, it should have created a new
one, otherwise, as you have pointed out, it's a bug.

thanks,

greg k-h
