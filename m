Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab3AKO1N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 09:27:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35597 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409Ab3AKO1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 09:27:12 -0500
Date: Fri, 11 Jan 2013 15:27:03 +0100
From: David Sterba <dsterba@suse.cz>
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: dsterba@suse.cz, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        david@fromorbit.com, darrick.wong@oracle.com, andi@firstfloor.org,
        hch@infradead.org, linuxram@linux.vnet.ibm.com,
        wuzhy@linux.vnet.ibm.com
Subject: Re: [PATCH RESEND v1 03/16] vfs: add I/O frequency update function
Message-ID: <20130111142703.GJ20089@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1356014615-15073-1-git-send-email-zwu.kernel@gmail.com>
 <1356014615-15073-4-git-send-email-zwu.kernel@gmail.com>
 <20130110005139.GW20089@twin.jikos.cz>
 <CAEH94Lh-a4cqhqDYh7UbsWptTuGxOJA9JywKhiEH-kZWr52Cfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEH94Lh-a4cqhqDYh7UbsWptTuGxOJA9JywKhiEH-kZWr52Cfw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 03:38:31PM +0800, Zhi Yong Wu wrote:
> On Thu, Jan 10, 2013 at 8:51 AM, David Sterba <dsterba@suse.cz> wrote:
> > On Thu, Dec 20, 2012 at 10:43:22PM +0800, zwu.kernel@gmail.com wrote:
> >> --- a/fs/hot_tracking.c
> >> +++ b/fs/hot_tracking.c
> >> @@ -164,6 +164,135 @@ static void hot_inode_tree_exit(struct hot_info *root)
> >>       spin_unlock(&root->lock);
> >>  }
> >>
> >> +struct hot_inode_item
> >> +*hot_inode_item_lookup(struct hot_info *root, u64 ino)
> >> +{
> >> +     struct rb_node **p = &root->hot_inode_tree.map.rb_node;
> >> +     struct rb_node *parent = NULL;
> >> +     struct hot_comm_item *ci;
> >> +     struct hot_inode_item *entry;
> >> +
> >> +     /* walk tree to find insertion point */
> >> +     spin_lock(&root->lock);
> >> +     while (*p) {
> >> +             parent = *p;
> >> +             ci = rb_entry(parent, struct hot_comm_item, rb_node);
> >> +             entry = container_of(ci, struct hot_inode_item, hot_inode);
> >> +             if (ino < entry->i_ino)
> >> +                     p = &(*p)->rb_left;
> >> +             else if (ino > entry->i_ino)
> >> +                     p = &(*p)->rb_right;
> >
> > style comment: put { } around the all if/else blocks,
> no, it will violate checkpatch.pl. If the if/else block only contains
> one line of code, we should not put {} around them.

Unless its in a if / else if / else sequence, see
Documentation/CodingStyle chapter 3.1. This is what I've learned long
time ago and using it intuitively. I don't know to what extent
checkpatch sticks to that document, the code is menat to be read by
people, so if there is one style prevailing in the subsystem (and it is
by looking into random fs/*.c files) it's wise to keep the style
consistent.

david
