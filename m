Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934333Ab3CMWsP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 18:48:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52750 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609Ab3CMWsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 18:48:13 -0400
Date: Wed, 13 Mar 2013 15:48:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, apw@canonical.com, nbd@openwrt.org, neilb@suse.de,
        jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu, dhowells@redhat.com,
        sedat.dilek@googlemail.com, hooanon05@yahoo.co.jp, mszeredi@suse.cz
Subject: Re: [PATCH 4/9] vfs: introduce clone_private_mount()
Message-Id: <20130313154811.191d970b8376f80ea98195a0@linux-foundation.org>
In-Reply-To: <1363184193-1796-5-git-send-email-miklos@szeredi.hu>
References: <1363184193-1796-1-git-send-email-miklos@szeredi.hu>
	<1363184193-1796-5-git-send-email-miklos@szeredi.hu>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Mar 2013 15:16:28 +0100 Miklos Szeredi <miklos@szeredi.hu> wrote:

> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Overlayfs needs a private clone of the mount, so create a function for
> this and export to modules.
> 
> ...
>
> +struct vfsmount *clone_private_mount(struct path *path)
> +{
> +	struct mount *old_mnt = real_mount(path->mnt);
> +	struct mount *new_mnt;
> +
> +	if (IS_MNT_UNBINDABLE(old_mnt))
> +		return ERR_PTR(-EINVAL);
> +
> +	down_read(&namespace_sem);
> +	new_mnt = clone_mnt(old_mnt, path->dentry, CL_PRIVATE);
> +	up_read(&namespace_sem);
> +	if (!new_mnt)
> +		return ERR_PTR(-ENOMEM);
> +
> +	return &new_mnt->mnt;
> +}
> +EXPORT_SYMBOL_GPL(clone_private_mount);

So this one gets the _GPL?

This is a new, exported-to-modules kernel interface function.  And it
is undocumented?


