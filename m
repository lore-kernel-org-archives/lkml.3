Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab3KQD3s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 22:29:48 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:62348 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595Ab3KQD3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 22:29:42 -0500
Date: Sun, 17 Nov 2013 12:29:37 +0900
From: Tejun Heo <tj@kernel.org>
To: Dave Jones <davej@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] sysfs: use a separate locking class for open files
 depending on mmap
Message-ID: <20131117032937.GB9302@mtj.dyndns.org>
References: <20131113184538.GA7269@redhat.com>
 <20131113201043.GE13318@ZenIV.linux.org.uk>
 <20131114054116.GC29031@mtj.dyndns.org>
 <20131115011916.GA19453@redhat.com>
 <20131117021736.GA9302@mtj.dyndns.org>
 <20131117032119.GA26529@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131117032119.GA26529@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 16, 2013 at 10:21:19PM -0500, Dave Jones wrote:
> On Sun, Nov 17, 2013 at 11:17:36AM +0900, Tejun Heo wrote:
> 
>  
>  > +	if (has_mmap)
>  > +		mutex_init(&of->mutex);
>  > +	else
>  > +		mutex_init(&of->mutex);
> 
> ummm...

Supposed to look that way.  It'll give two separate static lock class
keys to of->mutex.  Yeah, looks weird.  Any better ideas?

Thanks.

-- 
tejun
