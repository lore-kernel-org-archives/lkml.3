Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbaAOK3o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 05:29:44 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:49576 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbaAOK3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 05:29:41 -0500
Date: Wed, 15 Jan 2014 11:30:32 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        akpm@linux-foundation.org, dhowells@redhat.com, zab@redhat.com,
        jack@suse.cz, luto@amacapital.net, mszeredi@suse.cz
Subject: Re: [PATCH 04/11] vfs: add renameat2 syscall
Message-ID: <20140115103032.GD24171@tucsk.piliscsaba.szeredi.hu>
References: <1389219015-10980-1-git-send-email-miklos@szeredi.hu>
 <1389219015-10980-5-git-send-email-miklos@szeredi.hu>
 <201401150711.AHB52169.VMSFFLtHQFOOOJ@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201401150711.AHB52169.VMSFFLtHQFOOOJ@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 07:11:16AM +0900, Tetsuo Handa wrote:
> Miklos Szeredi wrote:
> > +
> > +	if (flags)
> > +		return -EOPNOTSUPP;
> > +
> 
> If (at least for now) only ext4 interprets renameat2() flags,
> I think adding a new member to "struct inode_operations" and
> check it like
> 
> 	if (!old_dir->i_op->swapname)
> 		return -EOPNOTSUPP;
> 
> or

This is not just about swapname, but other rename variants too (non-overwriting
rename is also included in the patchset).

> 
> 	if (!(old_dir->i_op->supported_features & flags))
> 		return -EOPNOTSUPP;

Or rather old_dir->i_sb->s_type->fs_flags.  We access it due to
FS_RENAME_DOES_D_MOVE anyway.

I like this variant, because now filesystems need to explicitly add a flag to
*enable* the functionality and not a check to disable it.

Objections?

Thanks,
Miklos
