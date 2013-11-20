Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab3KTBch (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 20:32:37 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:53877 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234Ab3KTBcd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 20:32:33 -0500
X-AuditID: cbfee68d-b7fa16d0000029b0-b8-528c1130a140
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <1384911101.26319.37.camel@kjgkr>
Subject: Re: [PATCH 5/5] f2fs: move the list_head initialization into the lock
 protection region
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 20 Nov 2013 10:31:41 +0900
In-reply-to: <528B3783.2040905@cn.fujitsu.com>
References: <528B3783.2040905@cn.fujitsu.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t8zQ10DwZ4gg9brnBbP2w8wW1xa5G6x
	Z+9JFovLu+awObB4/D84idlj94LPTB6fN8kFMEdx2aSk5mSWpRbp2yVwZXyYt5ulYJVgxZrn
	3xgbGL/xdjFyckgImEh8WHyABcIWk7hwbz1bFyMXh5DAMkaJ55vuMMEULd/wlhXEFhKYzijR
	fjgOxOYVEJT4MfkeWDOzgLrEpHmLmCFsEYnL3Z1sELa2xLKFr5khhr5ilDh/6QVjFyMHULOu
	xIRuKZAaYYEkiStPljOBhNmA6jfvN4BYpSjxdv9dsLUiAmoSz95dYgIZwyzQzShxdv0rdpAE
	i4CqxL8Py8B2cQroSZxp28kO0awrsWLba0YQm19AVOLwwu3MEL8oSexu72QHGSQhcIpdonvy
	LRaIQQIS3yYfYgE5QkJAVmLTAah6SYmDK26wTGCUnIXk5VlIXp6F5OVZSF5ewMiyilE0tSC5
	oDgpvchQrzgxt7g0L10vOT93EyMkQnt3MN4+YH2IMRlo/URmKdHkfGCE55XEGxqbGVmYmpga
	G5lbmpEmrCTOm/QwKUhIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QD4/KQzeWKsYfyd73+a2Os
	zZjk71Z3v1+/5FbA7Zm+xw6tTU3mjNT6mC209m//WZNPCdsUXCbv99hXNXWv+DO2Ty4fvrUu
	W7JF4dT0jW88uWYK7zeMefTmyT0dh31/q6xl+NRXcei0JOx8kH6N2axFwI3N4rBopap9uuwM
	xa1RPh+Saia9uPaPUYmlOCPRUIu5qDgRAHCLhNHmAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsVy+t9jQV0DwZ4ggxd3WSyetx9gtri0yN1i
	z96TLBaXd81hc2Dx+H9wErPH7gWfmTw+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8zYcuETe0GfYMW+g50sDYy3eLsYOTkkBEwklm94ywphi0lcuLeeDcQWEpjO
	KNF+OA7E5hUQlPgx+R5LFyMHB7OAvMSRS9kgYWYBdYlJ8xYxdzFyAZW/YpQ4f+kFI0gNr4Cu
	xIRuKZAaYYEkiStPljOBhNkEtCU27zeAmK4o8Xb/XbCtIgJqEs/eXWICGcMs0M0ocXb9K3aQ
	BIuAqsS/D8vAzuEU0JM407aTHaJZV2LFtteMIDa/gKjE4YXbmSHOV5LY3d7JPoFRaBaSq2ch
	XD0LydULGJlXMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgTH8jOpHYwrGywOMQpwMCrx8Eos
	6A4SYk0sK67MPcQowcGsJMK7lr0nSIg3JbGyKrUoP76oNCe1+BBjMtDhE5mlRJPzgWkmryTe
	0NjEzMjSyMzCyMTcnDRhJXHeA63WgUIC6YklqdmpqQWpRTBbmDg4pRoYLZv+fQpVUVuYZVfx
	JdFvbjfTx7V7t2ct57Ka7fT++dMOhweMOz+EndjII39Ry26y/AoFpuscK3bsYJ84YfmSThmp
	tP1fOWsYXd0lebLDQ4Iscnr33g7v4J6xYOdaTdlfMQeXZZ13ETe6Z1zvMOP40VMvo79J/ebQ
	lao8vpwttdZB3mru+zndSizFGYmGWsxFxYkATI+E1ykDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gu,

IMO, there is no reason to cover the list header by the lock.
In any flows, sbi should have the header all the time.
What is your opinion?

Thanks,

2013-11-19 (화), 18:03 +0800, Gu Zheng:
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> ---
>  fs/f2fs/checkpoint.c |   15 ++++++++++-----
>  1 files changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
> index f884589..1de70cc 100644
> --- a/fs/f2fs/checkpoint.c
> +++ b/fs/f2fs/checkpoint.c
> @@ -511,8 +511,8 @@ void add_dirty_dir_inode(struct inode *inode)
>  void remove_dirty_dir_inode(struct inode *inode)
>  {
>  	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
> -	struct list_head *head = &sbi->dir_inode_list;
> -	struct list_head *this;
> +
> +	struct list_head *this, *head;
>  
>  	if (!S_ISDIR(inode->i_mode))
>  		return;
> @@ -523,6 +523,7 @@ void remove_dirty_dir_inode(struct inode *inode)
>  		return;
>  	}
>  
> +	head = &sbi->dir_inode_list;
>  	list_for_each(this, head) {
>  		struct dir_inode_entry *entry;
>  		entry = list_entry(this, struct dir_inode_entry, list);
> @@ -544,11 +545,13 @@ void remove_dirty_dir_inode(struct inode *inode)
>  
>  struct inode *check_dirty_dir_inode(struct f2fs_sb_info *sbi, nid_t ino)
>  {
> -	struct list_head *head = &sbi->dir_inode_list;
> -	struct list_head *this;
> +
> +	struct list_head *this, *head;
>  	struct inode *inode = NULL;
>  
>  	spin_lock(&sbi->dir_inode_lock);
> +
> +	head = &sbi->dir_inode_list;
>  	list_for_each(this, head) {
>  		struct dir_inode_entry *entry;
>  		entry = list_entry(this, struct dir_inode_entry, list);
> @@ -563,11 +566,13 @@ struct inode *check_dirty_dir_inode(struct f2fs_sb_info *sbi, nid_t ino)
>  
>  void sync_dirty_dir_inodes(struct f2fs_sb_info *sbi)
>  {
> -	struct list_head *head = &sbi->dir_inode_list;
> +	struct list_head *head;
>  	struct dir_inode_entry *entry;
>  	struct inode *inode;
>  retry:
>  	spin_lock(&sbi->dir_inode_lock);
> +
> +	head = &sbi->dir_inode_list;
>  	if (list_empty(head)) {
>  		spin_unlock(&sbi->dir_inode_lock);
>  		return;

-- 
Jaegeuk Kim
Samsung

