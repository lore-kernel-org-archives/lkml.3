Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751224AbaEXIbI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 04:31:08 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:40508 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbaEXIbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 04:31:06 -0400
X-Nat-Received: from [202.181.97.72]:60411 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1400920175.1957
To: miklos@szeredi.hu, linux-security-module@vger.kernel.org
Cc: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, dhowells@redhat.com, sedat.dilek@gmail.com,
        hooanon05@yahoo.co.jp, mszeredi@suse.cz
Subject: Re: [PATCH 06/13] vfs: add whiteout support
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1400838223-30844-1-git-send-email-miklos@szeredi.hu><1400838223-30844-7-git-send-email-miklos@szeredi.hu>
In-Reply-To: <1400838223-30844-7-git-send-email-miklos@szeredi.hu>
Message-Id: <201405241729.AEI35937.HFFQJOOFLOVMSt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 24 May 2014 17:29:35 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 24052014 #7995763, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
> +int vfs_whiteout(struct inode *dir, struct dentry *dentry)
> +{
> +	int error = may_create(dir, dentry);
> +	if (error)
> +		return error;
> +
> +	if (!dir->i_op->mknod)
> +		return -EPERM;
> +
> +	return dir->i_op->mknod(dir, dentry,
> +				S_IFCHR | WHITEOUT_MODE, WHITEOUT_DEV);
> +}
> +EXPORT_SYMBOL(vfs_whiteout);

May I verify which/how security_path_*() hooks are called for vfs_whiteout() ?
(Please include linux-security-module@vger.kernel.org when making VFS changes.
TOMOYO and AppArmor don't want to be left behind again.)
