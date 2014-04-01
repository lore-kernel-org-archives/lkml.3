Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822AbaDABqk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 21:46:40 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:14164 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbaDABqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 21:46:37 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-b7-533a1a7b0134
From: Chao Yu <chao2.yu@samsung.com>
To: "'Gu Zheng'" <guz.fnst@cn.fujitsu.com>
Cc: "'???'" <jaegeuk.kim@samsung.com>, linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <000001cf4aff$baaf99e0$300ecda0$@samsung.com>
 <53393E47.5070600@cn.fujitsu.com>
In-reply-to: <53393E47.5070600@cn.fujitsu.com>
Subject: RE: [f2fs-dev] [PATCH 2/2] f2fs: use list_for_each_entry{_safe} for
 simplyfying code
Date: Tue, 01 Apr 2014 09:45:46 +0800
Message-id: <000001cf4d4c$374e5f10$a5eb1d30$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIYgwd6/qJc/3BGWwy+3Ix5d11HRQHLB18Amlsy1aA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsVy+t9jQd1qKatggzVXjC2etx9gtri+6y+T
	xaVF7hZ79p5ksbi8aw6bA6vH/4OTmD12L/jM5NG3ZRWjx+dNcgEsUVw2Kak5mWWpRfp2CVwZ
	+y7OYi14JFrx5/4/tgbGeYJdjJwcEgImEhP2n2KFsMUkLtxbz9bFyMUhJDCdUeLlpC0sEM4P
	RomvP+8xg1SxCahILO/4zwRiiwhoSEybup8JpIhZoItRYsq230AOB1BHrMSvRi2QGk4BPYlP
	08+ygYSFBeIlDswPBgmzCKhKrN13AWwxr4ClROur7VC2oMSPyfdYQGxmAS2J9TuPM0HY8hKb
	17xlhjhUQWLH2deMECdYSfQvP8YIUSMusfHILZYJjEKzkIyahWTULCSjZiFpWcDIsopRNLUg
	uaA4KT3XUK84Mbe4NC9dLzk/dxMjOBqeSe1gXNlgcYhRgINRiYdX4qNlsBBrYllxZe4hRgkO
	ZiUR3iPvgUK8KYmVValF+fFFpTmpxYcYpTlYlMR5D7RaBwoJpCeWpGanphakFsFkmTg4pRoY
	N00ve7Lxrcj6/grR0xPb4v34jVbJnf1rkHFOfU+2Lr991+o+xhX2AYvZtq0LmBBUynVEz74u
	3erPXY/9d25EFvg91BP+dcKW8/gz86ca9q8uub0NDdtvI/lEUUpkUQvHBZa2lW4aS/f8lTJR
	PpKbwnoraLN9wf8/B0/9l7YR1Bfi/qFWkMqpxFKckWioxVxUnAgAwBbd94ICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gu,

> -----Original Message-----
> From: Gu Zheng [mailto:guz.fnst@cn.fujitsu.com]
> Sent: Monday, March 31, 2014 6:07 PM
> To: Chao Yu
> Cc: ???; linux-f2fs-devel@lists.sourceforge.net; linux-fsdevel@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [f2fs-dev] [PATCH 2/2] f2fs: use list_for_each_entry{_safe} for simplyfying code
> 
> Hi Yu,
> On 03/29/2014 11:33 AM, Chao Yu wrote:
> 
> > This patch use list_for_each_entry{_safe} instead of list_for_each{_safe} for
> > simplfying code.
> >
> > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > ---
> >  fs/f2fs/checkpoint.c |   37 ++++++++++++++-----------------------
> >  fs/f2fs/node.c       |   16 ++++++----------
> >  fs/f2fs/recovery.c   |    6 ++----
> >  fs/f2fs/segment.c    |    6 ++----
> >  4 files changed, 24 insertions(+), 41 deletions(-)
> >
> > diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
> > index d877f46..4aa521a 100644
> > --- a/fs/f2fs/checkpoint.c
> > +++ b/fs/f2fs/checkpoint.c
> > @@ -308,16 +308,15 @@ void release_orphan_inode(struct f2fs_sb_info *sbi)
> >
> >  void add_orphan_inode(struct f2fs_sb_info *sbi, nid_t ino)
> >  {
> > -	struct list_head *head, *this;
> > -	struct orphan_inode_entry *new = NULL, *orphan = NULL;
> > +	struct list_head *head;
> > +	struct orphan_inode_entry *new, *orphan;
> >
> >  	new = f2fs_kmem_cache_alloc(orphan_entry_slab, GFP_ATOMIC);
> >  	new->ino = ino;
> >
> >  	spin_lock(&sbi->orphan_inode_lock);
> >  	head = &sbi->orphan_inode_list;
> > -	list_for_each(this, head) {
> > -		orphan = list_entry(this, struct orphan_inode_entry, list);
> > +	list_for_each_entry(orphan, head, list) {
> >  		if (orphan->ino == ino) {
> >  			spin_unlock(&sbi->orphan_inode_lock);
> >  			kmem_cache_free(orphan_entry_slab, new);
> > @@ -326,14 +325,10 @@ void add_orphan_inode(struct f2fs_sb_info *sbi, nid_t ino)
> >
> >  		if (orphan->ino > ino)
> >  			break;
> > -		orphan = NULL;
> >  	}
> >
> > -	/* add new_oentry into list which is sorted by inode number */
> > -	if (orphan)
> > -		list_add(&new->list, this->prev);
> > -	else
> > -		list_add_tail(&new->list, head);
> > +	/* add new orphan entry into list which is sorted by inode number */
> > +	list_add_tail(&new->list, &orphan->list);
> 
> It seems that the logic can not be changed here, otherwise the orphan list will not be in order
> if
> the new ino is bigger than all the in-list ones.
> E.g.
> ino:5
> 1-->2-->3-->4
> ==>
> 1-->2-->3-->5-->4

As I checked, if new ino is bigger than all, it will break from list_for_each_entry because
&orphan->list is pointing to head. So list_add_tail can add the new entry before head to make
this list in order.

Thanks.

> 
> Regards,
> Gu
> 

[snip]

