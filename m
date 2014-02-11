Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287AbaBKAA2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 19:00:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59920 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbaBKAA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 19:00:27 -0500
Date: Mon, 10 Feb 2014 16:01:41 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH driver-core-next] kernfs: fix hash calculation in
 kernfs_rename_ns()
Message-ID: <20140211000141.GA30793@kroah.com>
References: <20140210225709.GH25350@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140210225709.GH25350@mtj.dyndns.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 05:57:09PM -0500, Tejun Heo wrote:
> 3eef34ad7dc3 ("kernfs: implement kernfs_get_parent(),
> kernfs_name/path() and friends") restructured kernfs_rename_ns() such
> that new name assignment happens under kernfs_rename_lock;
> unfortunately, it mistakenly passed NULL to kernfs_name_hash() to
> calculate the new hash if the name hasn't changed, which can lead to
> oops.
> 
> Fix it by using kn->name and kn->ns when calculating the new hash.

Now applied, thanks.

Also, can you look into the merge of 3.14-rc2 into the driver-core-next
branch?  There are some conflicts in the kernfs code due to the lockdep
changes that I couldn't easily verify I got right, so I didn't do the
merge.  Could you give me a diff of the merge for me to work off of?

thanks,

greg k-h
