Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751105Ab3IGQQd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 12:16:33 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:44280 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab3IGQQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 12:16:30 -0400
Message-ID: <522B4FB7.9050107@gmail.com>
Date: Sat, 07 Sep 2013 18:09:27 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Vladimir Davydov <vdavydov@parallels.com>, linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 12/19] pramfs: symlink operations
References: <522AE3DB.7000209@gmail.com> <20130907144118.GA13318@ZenIV.linux.org.uk>
In-Reply-To: <20130907144118.GA13318@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 07/09/2013 16:41, Al Viro ha scritto:
> On Sat, Sep 07, 2013 at 10:29:15AM +0200, Marco Stornelli wrote:
>> +static int pram_readlink(struct dentry *dentry, char __user *buffer, int buflen)
>> +{
>> +	struct inode *inode = dentry->d_inode;
>> +	struct super_block *sb = inode->i_sb;
>> +	u64 block;
>> +	char *blockp;
>> +
>> +	block = pram_find_data_block(inode, 0);
>> +	blockp = pram_get_block(sb, block);
>> +	return vfs_readlink(dentry, buffer, buflen, blockp);
>> +}
>
>> +static void *pram_follow_link(struct dentry *dentry, struct nameidata *nd)
>> +{
>> +	struct inode *inode = dentry->d_inode;
>> +	struct super_block *sb = inode->i_sb;
>> +	off_t block;
>> +	int status;
>> +	char *blockp;
>> +
>> +	block = pram_find_data_block(inode, 0);
>> +	blockp = pram_get_block(sb, block);
>> +	status = vfs_follow_link(nd, blockp);
>> +	return ERR_PTR(status);
>> +}
>
> Just nd_set_link(nd, blockp) instead of that vfs_follow_link() and be
> done with that; that way you can use generic_readlink() instead of
> pram_readlink() *and* get lower stack footprint on traversing them.
>
>

Yep, you're right (as usual :))

Marco

