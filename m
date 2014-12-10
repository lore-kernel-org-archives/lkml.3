Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769AbaLJOtY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 09:49:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52364 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756563AbaLJOtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 09:49:23 -0500
Date: Wed, 10 Dec 2014 09:49:21 -0500
From: Greg KH <gregkh@linuxfoundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Shalin Mehta <shalinmehta85@gmail.com>, devel@driverdev.osuosl.org,
        andreas.dilger@intel.com, gdonald@gmail.com, peterz@infradead.org,
        bergwolf@gmail.com, linux-kernel@vger.kernel.org,
        majordomo@vger.kernel.org, tranmanphong@gmail.com,
        HPDD-discuss@ml01.01.org, massa.nomura@gmail.com
Subject: Re: [PATCH] staging: lustre: Fix the warning messages about casting
 without __user macro
Message-ID: <20141210144921.GC17184@kroah.com>
References: <1418194573-1271-1-git-send-email-shalinmehta85@gmail.com>
 <20141210070957.GN22149@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141210070957.GN22149@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 07:09:59AM +0000, Al Viro wrote:
> On Tue, Dec 09, 2014 at 10:56:12PM -0800, Shalin Mehta wrote:
> > From: Shalin Mehta <shalinmehta85@gmail.com>
> > 
> > This issue is showed up while compiling with sparse. The iov_base in struct iovec struct explicitly declares that the assigned value should be user space pointer with __user macro. Where as here, the __user macro isn't used while casting.
> 
> ... and pointers are not user space ones at all.  Which is to say, quit
> messing with casts; it's not struct iovec.  Proper fix is to replace
> it here (and in almost all places throughout drivers/staging/lustre) with
> struct kvec.  And yes, such a patch had been sent.  Still not applied,
> AFAICS...

Yeah, it's in the merge window and I'll pick new staging patches back up
when 3.19-rc1 is released.

thanks,

greg k-h
