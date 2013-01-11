Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab3AKOyO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 09:54:14 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:45597 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345Ab3AKOyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 09:54:12 -0500
MIME-Version: 1.0
In-Reply-To: <20130111142703.GJ20089@twin.jikos.cz>
References: <1356014615-15073-1-git-send-email-zwu.kernel@gmail.com>
	<1356014615-15073-4-git-send-email-zwu.kernel@gmail.com>
	<20130110005139.GW20089@twin.jikos.cz>
	<CAEH94Lh-a4cqhqDYh7UbsWptTuGxOJA9JywKhiEH-kZWr52Cfw@mail.gmail.com>
	<20130111142703.GJ20089@twin.jikos.cz>
Date: Fri, 11 Jan 2013 22:54:11 +0800
Message-ID: <CAEH94LgmxkfrWXCZG__QLHYU7jGEX4HHXimKiviZjkDP044+wA@mail.gmail.com>
Subject: Re: [PATCH RESEND v1 03/16] vfs: add I/O frequency update function
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: dsterba@suse.cz
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, david@fromorbit.com, darrick.wong@oracle.com,
        andi@firstfloor.org, hch@infradead.org, linuxram@linux.vnet.ibm.com,
        wuzhy@linux.vnet.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 10:27 PM, David Sterba <dsterba@suse.cz> wrote:
> On Fri, Jan 11, 2013 at 03:38:31PM +0800, Zhi Yong Wu wrote:
>> On Thu, Jan 10, 2013 at 8:51 AM, David Sterba <dsterba@suse.cz> wrote:
>> > On Thu, Dec 20, 2012 at 10:43:22PM +0800, zwu.kernel@gmail.com wrote:
>> >> --- a/fs/hot_tracking.c
>> >> +++ b/fs/hot_tracking.c
>> >> @@ -164,6 +164,135 @@ static void hot_inode_tree_exit(struct hot_info *root)
>> >>       spin_unlock(&root->lock);
>> >>  }
>> >>
>> >> +struct hot_inode_item
>> >> +*hot_inode_item_lookup(struct hot_info *root, u64 ino)
>> >> +{
>> >> +     struct rb_node **p = &root->hot_inode_tree.map.rb_node;
>> >> +     struct rb_node *parent = NULL;
>> >> +     struct hot_comm_item *ci;
>> >> +     struct hot_inode_item *entry;
>> >> +
>> >> +     /* walk tree to find insertion point */
>> >> +     spin_lock(&root->lock);
>> >> +     while (*p) {
>> >> +             parent = *p;
>> >> +             ci = rb_entry(parent, struct hot_comm_item, rb_node);
>> >> +             entry = container_of(ci, struct hot_inode_item, hot_inode);
>> >> +             if (ino < entry->i_ino)
>> >> +                     p = &(*p)->rb_left;
>> >> +             else if (ino > entry->i_ino)
>> >> +                     p = &(*p)->rb_right;
>> >
>> > style comment: put { } around the all if/else blocks,
>> no, it will violate checkpatch.pl. If the if/else block only contains
>> one line of code, we should not put {} around them.
>
> Unless its in a if / else if / else sequence, see
> Documentation/CodingStyle chapter 3.1. This is what I've learned long
> time ago and using it intuitively. I don't know to what extent
> checkpatch sticks to that document, the code is menat to be read by
> people, so if there is one style prevailing in the subsystem (and it is
> by looking into random fs/*.c files) it's wise to keep the style
> consistent.
I checked *.c in fs/, its coding style about if/else if is consistent
with what i said.:)
e.g in direct-io.c

                if (sdio->final_block_in_bio != sdio->cur_page_block ||
                    cur_offset != bio_next_offset)
                        dio_bio_submit(dio, sdio);
                /*
                 * Submit now if the underlying fs is about to perform a
                 * metadata read
                 */
                else if (sdio->boundary)
                        dio_bio_submit(dio, sdio);

>
> david



-- 
Regards,

Zhi Yong Wu
