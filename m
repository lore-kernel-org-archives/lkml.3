Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab3EQXvf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 19:51:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55424 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139Ab3EQXve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 19:51:34 -0400
Date: Fri, 17 May 2013 16:51:33 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alexander van Heukelum <heukelum@fastmail.fm>
Subject: Re: [ 027/102] x86, vm86: fix VM86 syscalls: use SYSCALL_DEFINEx(...)
Message-ID: <20130517235133.GC20969@kroah.com>
References: <20130517213244.277411019@linuxfoundation.org>
 <20130517213247.228264908@linuxfoundation.org>
 <20130517224930.GW25399@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130517224930.GW25399@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17, 2013 at 11:49:30PM +0100, Al Viro wrote:
> On Fri, May 17, 2013 at 02:35:42PM -0700, Greg Kroah-Hartman wrote:
> > 3.9-stable review patch.  If anyone has any objections, please let me know.
> 
> This is seriously wrong.  For 3.9 you _need_ asmlinkage_protect() in that
> thing; by the time when that went into the tree, mainline already had
> it generated automatically by SYSCALL_DEFINE, so there was no point in
> that part of patch - the switch to SYSCALL_DEFINE alone did the job.
> For 3.9 it's very much needed; as the matter of fact, in 3.9 that commit
> is a no-op in the form you took.
> 
> We can grab all prereqs into 3.9-stable (there's not that much of those),
> but that would be much more intrusive than the variant adding explicit
> asmlinkage_protect() in those two syscalls.

Ok, Alexander was saying something was off here.

Can someone send me just the needed patch to get this working properly,
and I will be glad to drop this one from the 3.9.x tree.

thanks,

greg k-h
