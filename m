Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288Ab3J0PwW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 11:52:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41031 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420Ab3J0PwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 11:52:21 -0400
Date: Sun, 27 Oct 2013 08:54:08 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Steven Newbury <steve@snewbury.org.uk>
Cc: linux-kernel@vger.kernel.org, Naren Sankar <nsankar@broadcom.com>,
        Jarod Wilson <jarod@wilsonet.com>, Scott Davilla <davilla@4pi.com>,
        Manu Abraham <abraham.manu@gmail.com>
Subject: Re: [PATCH] staging: Merge Crystal HD driver with linuxtv.org
Message-ID: <20131027155408.GA22705@kroah.com>
References: <1382891243.2598.10.camel@artifact>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382891243.2598.10.camel@artifact>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 27, 2013 at 04:27:23PM +0000, Steven Newbury wrote:
> The in-kernel staging version and upstream diverged in Jan 2010,
> whilst the in-kernel version has been kept up to date with kernel
> changes, both have recieved some clean ups and bug fixes, upstream
> has also added support for new cards, particularly BCM70015 which
> is now a much more common device than the original BCM70012 and
> is currently available for purchase.
> 
> In addition to the changes below, I've applied all the relevant
> modifications applied to the in-kernel version to the new code
> introduced from upstream, in particular the removal of typedefs and
> unified header handling.
> 
> Quite a lot of the code churn relates to upstream commit
> 317dbd6dda65b4177627d6417b762c287cefa0e7 (crystalhd: nuke BCMLOG
> macros, use std dev_foo ones), I considered stripping these changes
> out and making them a separate patch but decided to stay as close as
> possible to the state of the current linuxtv.org codebase.
> 
> Unfortunately, AFAIK, it's not possible to simply merge the upstream
> git history since the upstream code isn't in a kernel tree structure,
> and isn't even in a simple directory, but includes a script to
> convert the external module into a staging tree driver which I used
> to create a reference tree.  I had to then manually merge both
> versions and fix code conflicts.
> 
> It does now successfully detect and initialise a BCM70015 bought
> last week from Amazon.  It is currently untested on the original
> BCM70012.
> 
> Signed-off-by: Steven Newbury <steve@snewbury.org.uk>

Any reason why you didn't send this to me, the staging tree maintainer?

And I can't take a giant patch like this, it's a mess.  Why not send me
a series of patches that sync things up, like you detail in the odd
changelog entries you show below?

And these patches do a lot of new work to the driver, I'd rather see it
get fixed up properly and moved out of staging first, before adding new
support to it, otherwise why is it in staging at all?

thanks,

greg k-h
