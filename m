Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab3KUAXK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 19:23:10 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:40012 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975Ab3KUAXF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 19:23:05 -0500
X-AuditID: cbfee690-b7f3d6d000001c4a-48-528d52661c04
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <1384993332.26319.39.camel@kjgkr>
Subject: Re: [PATCH 5/5] f2fs: move the list_head initialization into the lock
 protection region
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Thu, 21 Nov 2013 09:22:12 +0900
In-reply-to: <528C8559.6040909@cn.fujitsu.com>
References: <528B3783.2040905@cn.fujitsu.com> <1384911101.26319.37.camel@kjgkr>
 <528C8559.6040909@cn.fujitsu.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t8zfd20oN4ggz8fTC2etx9gtri0yN1i
	z96TLBaXd81hc2Dx+H9wErPH7gWfmTw+b5ILYI7isklJzcksSy3St0vgyjjf0s5eMFGiYuXl
	54wNjI3CXYycHBICJhJH50xkgrDFJC7cW8/WxcjFISSwjFFi16LNjDBFUy/PZ4VITGeU2PDr
	MxtIgldAUOLH5HssIDazgLrEpHmLmCFsEYml/9qgbG2JZQtfM0M0v2KUmPcGZBJIs67EzPln
	wFYLCyRJXHmyHMjm4GADati83wAkLCSgKPF2/12wchEBNYln7y4xgcxhFuhmlDi7/hU7SIJF
	QFXi16Q5YEWcAnoSXw5dZIRoLpbYt+E02Hx+AVGJwwu3M0N8oySxu72THWSQhMApdommn7NZ
	IQYJSHybfIgF5AgJAVmJTQeg6iUlDq64wTKBUXIWkp9nIfl5FpKfZyH5eQEjyypG0dSC5ILi
	pPQiE73ixNzi0rx0veT83E2MkCidsIPx3gHrQ4zJQOsnMkuJJucDozyvJN7Q2MzIwtTE1NjI
	3NKMNGElcV61R0lBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhi9jnmrh9/iWd7W7l3k/fii
	yVSOsLid0Vsn+SWqSy24uoZNVI45clZxTslud46N5x9lzN8gu/7gMo3aZ53zul8tDAwQa02W
	d3p2d9PFew0bpQ5ISStVbmy3/X7Q42/+tVwXfiHjT9Y+rZduf7L+eTv7wodtU3XlHhkn31B4
	WVTnNkNzh+/BBapKLMUZiYZazEXFiQDJT5lI6AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsVy+t9jQd20oN4gg0/LDC2etx9gtri0yN1i
	z96TLBaXd81hc2Dx+H9wErPH7gWfmTw+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8xYc3ESU8F78Yrzp/wbGO8LdTFyckgImEhMvTyfFcIWk7hwbz1bFyMXh5DA
	dEaJDb8+s4EkeAUEJX5MvsfSxcjBwSwgL3HkUjZImFlAXWLSvEXMEPWvGCXmvYEYxCugKzFz
	/hkmEFtYIEniypPlTCC9bALaEpv3G4CEhQQUJd7uvwtWLiKgJvHs3SUmkDnMAt2MEmfXv2IH
	SbAIqEr8mjQHrIhTQE/iy6GLjBDNxRL7NpwGm88vICpxeOF2ZogHlCR2t3eyT2AUmoXk7FkI
	Z89CcvYCRuZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMHR/Ex6B+OqBotDjAIcjEo8vA+e
	9gQJsSaWFVfmHmKU4GBWEuGNse4NEuJNSaysSi3Kjy8qzUktPsSYDHT4RGYp0eR8YKLJK4k3
	NDYxM7I0MrMwMjE3J01YSZz3YKt1oJBAemJJanZqakFqEcwWJg5OqQbG9LuzunksN9+Kv3+D
	42Ezf/5kJr4nRnMX1uodLH66WEz7x9XX/1Mn7l5/cq+EerRzC1P+LW9nNjnth+yRG441zVH/
	cVJl5bauheedJNUN1NNWh3++JslxbEX7bIdoljOOM6T+qsW+v6QhfD3yCsszLcd+26/9Efz/
	XbbeyFZSXlyUfk41t9RHiaU4I9FQi7moOBEAyatLrCoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, got it.
Thanks, :)

2013-11-20 (수), 17:48 +0800, Gu Zheng:
> Hi Kim,
> On 11/20/2013 09:31 AM, Jaegeuk Kim wrote:
> 
> > Hi Gu,
> > 
> > IMO, there is no reason to cover the list header by the lock.
> > In any flows, sbi should have the header all the time.
> 
> Yes, you're right.
> 
> > What is your opinion?
> 
> Moving the list_head initialization into the lock protection region, so
> that we can ignore the list change during the gap(initialization<-->use).
> And on the other side, it can keep the code style uniform for better
> maintenance.
> 
> Regards,
> Gu
> 
> > 
> > Thanks,
> > 
> > 2013-11-19 (화), 18:03 +0800, Gu Zheng:
> >> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> >> ---
> >>  fs/f2fs/checkpoint.c |   15 ++++++++++-----
> >>  1 files changed, 10 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
> >> index f884589..1de70cc 100644
> >> --- a/fs/f2fs/checkpoint.c
> >> +++ b/fs/f2fs/checkpoint.c
> >> @@ -511,8 +511,8 @@ void add_dirty_dir_inode(struct inode *inode)
> >>  void remove_dirty_dir_inode(struct inode *inode)
> >>  {
> >>  	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
> >> -	struct list_head *head = &sbi->dir_inode_list;
> >> -	struct list_head *this;
> >> +
> >> +	struct list_head *this, *head;
> >>  
> >>  	if (!S_ISDIR(inode->i_mode))
> >>  		return;
> >> @@ -523,6 +523,7 @@ void remove_dirty_dir_inode(struct inode *inode)
> >>  		return;
> >>  	}
> >>  
> >> +	head = &sbi->dir_inode_list;
> >>  	list_for_each(this, head) {
> >>  		struct dir_inode_entry *entry;
> >>  		entry = list_entry(this, struct dir_inode_entry, list);
> >> @@ -544,11 +545,13 @@ void remove_dirty_dir_inode(struct inode *inode)
> >>  
> >>  struct inode *check_dirty_dir_inode(struct f2fs_sb_info *sbi, nid_t ino)
> >>  {
> >> -	struct list_head *head = &sbi->dir_inode_list;
> >> -	struct list_head *this;
> >> +
> >> +	struct list_head *this, *head;
> >>  	struct inode *inode = NULL;
> >>  
> >>  	spin_lock(&sbi->dir_inode_lock);
> >> +
> >> +	head = &sbi->dir_inode_list;
> >>  	list_for_each(this, head) {
> >>  		struct dir_inode_entry *entry;
> >>  		entry = list_entry(this, struct dir_inode_entry, list);
> >> @@ -563,11 +566,13 @@ struct inode *check_dirty_dir_inode(struct f2fs_sb_info *sbi, nid_t ino)
> >>  
> >>  void sync_dirty_dir_inodes(struct f2fs_sb_info *sbi)
> >>  {
> >> -	struct list_head *head = &sbi->dir_inode_list;
> >> +	struct list_head *head;
> >>  	struct dir_inode_entry *entry;
> >>  	struct inode *inode;
> >>  retry:
> >>  	spin_lock(&sbi->dir_inode_lock);
> >> +
> >> +	head = &sbi->dir_inode_list;
> >>  	if (list_empty(head)) {
> >>  		spin_unlock(&sbi->dir_inode_lock);
> >>  		return;
> > 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Jaegeuk Kim
Samsung

