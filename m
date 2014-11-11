Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbaKKVG0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 16:06:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55908 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbaKKVGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 16:06:25 -0500
Date: Wed, 12 Nov 2014 06:05:06 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Giedrius Statkevicius <giedriuswork@gmail.com>
Cc: martink@posteo.de, linux-kernel@vger.kernel.org
Subject: Re: [Bisected] Regression: cpu stuck in gvfsd-fuse, can't shutdown
Message-ID: <20141111210506.GA26119@kroah.com>
References: <5462713F.4080406@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5462713F.4080406@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 10:27:43PM +0200, Giedrius Statkevicius wrote:
> Hello,
> Since this commit:
> 
> commit 32eca22180804f71b06b63fd29b72f58be8b3c47
> Author: Martin Kepplinger <martink@posteo.de>
> Date:   Wed Oct 29 20:22:56 2014 +0100
> 
>     misc: always assign miscdevice to file->private_data in open()
>     
>     As of now, a miscdevice driver has to provide an implementation of
>     the open() file operation if it wants to have misc_open() assign a
>     pointer to struct miscdevice to file->private_data for other file
>     operations to use (given the user calls open()).
>     
>     This leads to situations where a miscdevice driver that doesn't need
>     internal operations during open() has to implement open() that only
>     returns immediately, in order to use the data in private_data in other
>     fops.
>     
>     This provides consistent behaviour for miscdevice developers and will
>     always provide the pointer in private_data. A driver's open() fop would,
>     of course, just overwrite it, when using private_data itself.
>     
>     Signed-off-by: Martin Kepplinger <martink@posteo.de>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> I've noticed that my computer freezes a lot and I'm not able to shutdown
> (it just freezes while shutdowning and I have to use SysRq+reisub) and I
> get these messages in my journal:

If you revert this patch, does things go back to "normal" for you?

thanks,

greg k-h
