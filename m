Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbaBZX1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 18:27:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53377 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbaBZX1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 18:27:23 -0500
Date: Wed, 26 Feb 2014 15:28:59 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: The sheer number of sparse warnings in the kernel
Message-ID: <20140226232859.GA9213@kroah.com>
References: <530E6F76.1070605@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530E6F76.1070605@zytor.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 02:49:26PM -0800, H. Peter Anvin wrote:
> The number of sparse errors in the current kernel is staggering, and it
> makes sparse a lot less valuable of a tool that it otherwise could be.
> On a build of x86-64 allyesconfig I'm getting 20,676 sparse messages.
> Out of those, 12,358 come from linux/err.h.  Given that the latter
> basically spams *everything*, I can only conclude that almost noone uses
> sparse unless they have a filter script.

What errors are you seeing from err.h?  I don't see those when building
different subdirectories with sparse (which is how I normally use it.)

And what version of sparse are you running:
	$ sparse --version
	v0.4.5-rc1-407-g345e8943fc36

> So a lot of these are certainly nuisance problems, like the
> <linux/err.h> stuff which has to do with the handling of error values,
> but some of these look like real bugs.
> 
> What do we need to do to actually make our tools be able to do work for
> us?  Newbie projects to clean up?  Trying to get the larger Linux
> companies to put resources on it?

It's not the easiest "newbie" project as usually the first reflex to
"just cast it away" is wrong for a lot of sparse warnings.  I know this
from people trying to fix up the sparse warnings in drivers/staging/

thanks,

greg k-h
