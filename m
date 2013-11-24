Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab3KXO23 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 09:28:29 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:52832 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380Ab3KXO21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 09:28:27 -0500
Date: Sun, 24 Nov 2013 09:28:22 -0500
From: Tejun Heo <tj@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: gregkh@linuxfoundation.org, kay@vrfy.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, bhelgaas@google.com
Subject: Re: [PATCHSET driver-core-next] sysfs: separate out kernfs, take #3
Message-ID: <20131124142822.GA17243@htj.dyndns.org>
References: <1385245346-856-1-git-send-email-tj@kernel.org>
 <20131124091602.GA1454@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131124091602.GA1454@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, Nov 24, 2013 at 01:16:02AM -0800, Christoph Hellwig wrote:
> It would be highly useful if you could explain us what kernfs is
> supposed to do and why we're cheerfully waiting for it.  Also given

Oops, sorry about that.  It was explained in earlier series but I
probably should carry on a simplified explanation on later ones too.
It's just separating out the core features of sysfs into a separate
filesystem so that it can be used by non-kobject based users too.  So,
kernfs implements the core pseudo file functionality and sysfs becomes
kobject-wrapping layer on top of it.  I'm gonna convert cgroup to use
kernfs and Greg seems to have some plans for debugfs, IIUC.

> that you touch VFS core files please Cc linux-fsdevel for those and
> explain them in detail.

Does it?  Ah, okay, fs/Makefile and fs/namespace.c.  The former is
just adding kernfs/ directory and the latter is splitting out
kernfs_init() from sysfs_init() call.  Both are trivial.  Will cc
linux-fsdevel on those patches.

Thanks.

-- 
tejun
