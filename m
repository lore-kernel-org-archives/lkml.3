Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750873Ab3LKFh6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 00:37:58 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:34357 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750759Ab3LKFh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 00:37:56 -0500
X-Sasl-enc: DVwlTHqiyfh89dmjOVswEw7zNhUGRcnGoG83SZLy6Aqy 1386740275
Date: Tue, 10 Dec 2013 21:39:31 -0800
From: Greg KH <greg@kroah.com>
To: Tejun Heo <tj@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH driver-core-next] sysfs: bail early from
 kernfs_file_mmap() to avoid spurious lockdep warning
Message-ID: <20131211053931.GA31896@kroah.com>
References: <20131209144712.57a50d7ed468ae8a4d57a0bf@canb.auug.org.au>
 <20131209082152.GA26809@kroah.com>
 <20131210145004.GA4610@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131210145004.GA4610@htj.dyndns.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 09:50:04AM -0500, Tejun Heo wrote:
> Hello,
> 
> Yeap, I was planning to send this out earlier but was completely
> passed out yesterday after the first snowboarding in over a decade. :)
> 
> The offending commit a8b14744429f isn't applicable to
> driver-core-next.  This was done this way because no matter what we
> do, conflict is inevitable and keeping things minimal is the least
> painful.  The following git branch pulls driver-core-linus into
> driver-core-next, resolves the conflict by ignoring the offending
> commit and applies this patch on top of it to implement the equivalent
> fix.
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git driver-core-fix-lockdep-class

I've pulled from this and pushed it out as my driver-next branch, thanks
for doing this (note, I --ammend the patch and added my signed-off-by,
so you can't just pull and not get a conflict.)

thanks,

greg k-h
