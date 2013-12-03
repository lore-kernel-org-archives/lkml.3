Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999Ab3LCVKg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 16:10:36 -0500
Received: from mail-yh0-f45.google.com ([209.85.213.45]:44315 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811Ab3LCVKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 16:10:32 -0500
Date: Tue, 3 Dec 2013 16:10:28 -0500
From: Tejun Heo <tj@kernel.org>
To: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        gregkh@linuxfoundation.org
Subject: Re: sysfs: use a separate locking class for open files depending on
 mmap
Message-ID: <20131203211028.GN8277@htj.dyndns.org>
References: <20131128051223.45739660885@gitolite.kernel.org>
 <20131203184324.GA11320@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131203184324.GA11320@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Dave.

On Tue, Dec 03, 2013 at 01:43:24PM -0500, Dave Jones wrote:
>  > +	/*
>  > +	 * The following is done to give a different lockdep key to
>  > +	 * @of->mutex for files which implement mmap.  This is a rather
>  > +	 * crude way to avoid false positive lockdep warning around
>  > +	 * mm->mmap_sem - mmap nests @of->mutex under mm->mmap_sem and
>  > +	 * reading /sys/block/sda/trace/act_mask grabs sr_mutex, under
>  > +	 * which mm->mmap_sem nests, while holding @of->mutex.  As each
>  > +	 * open file has a separate mutex, it's okay as long as those don't
>  > +	 * happen on the same file.  At this point, we can't easily give
>  > +	 * each file a separate locking class.  Let's differentiate on
>  > +	 * whether the file has mmap or not for now.
>  > +	 */
>  > +	if (has_mmap)
>  > +		mutex_init(&of->mutex);
>  > +	else
>  > +		mutex_init(&of->mutex);
>  > +
>  
> Somehow I just triggered this trace again, even with this commit applied.
> The trace is pretty much identical to the old one.

Hah, ain't that weird.  That's the trace you reported on the other
mail, right?  I'll follow up on that one.

Thanks.

-- 
tejun
