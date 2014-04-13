Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbaDMXf2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 19:35:28 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:52649 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbaDMXf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 19:35:26 -0400
X-Google-Original-From: Conrad Meyer <cse.cem@gmail.com>
Date: Sun, 13 Apr 2014 19:35:23 -0400
From: Conrad Meyer <cemeyer@uw.edu>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] fs: FAT: Add support for DOS 1.x formatted volumes
Message-ID: <20140413193523.02dceabe@m>
In-Reply-To: <87vbucvpus.fsf@devron.myhome.or.jp>
References: <1397398200-6510-1-git-send-email-cse.cem@gmail.com>
	<87vbucvpus.fsf@devron.myhome.or.jp>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2014 07:14:51 +0900
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> wrote:

> Conrad Meyer <cse.cem@gmail.com> writes:
> 
> > +	sbi->sec_per_clus = fdefaults->sec_per_clus;
> > +	sbi->cluster_size = sb->s_blocksize *
> > sbi->sec_per_clus;
> > +	sbi->cluster_bits = ffs(sbi->cluster_size) - 1;
> > +	sbi->fats = 2;
> > +	sbi->fat_start = 1;
> > +	sbi->fat_length = fdefaults->fat_length;
> > +
> > +	sbi->dir_per_block = sb->s_blocksize /
> > sizeof(struct msdos_dir_entry);
> > +	sbi->dir_per_block_bits =
> > ffs(sbi->dir_per_block) - 1;
> > +	sbi->dir_start = sbi->fat_start + sbi->fats *
> > sbi->fat_length;
> > +	sbi->dir_entries = fdefaults->dir_entries;
> > +
> > +	rootdir_sectors = sbi->dir_entries
> > +		* sizeof(struct msdos_dir_entry) /
> > sb->s_blocksize;
> > +	sbi->data_start = sbi->dir_start +
> > rootdir_sectors;
> > +	total_sectors = fdefaults->nr_sectors;
> > +	total_clusters = (total_sectors -
> > sbi->data_start) / sbi->sec_per_clus;
> > +	sbi->fat_bits = (total_clusters > MAX_FAT12) ?
> > 16 : 12; +
> > +	/* some OSes set FAT_STATE_DIRTY and clean it on
> > unmount. */
> > +	sbi->dirty = b->fat16.state & FAT_STATE_DIRTY;
> > +
> > +	/* check that FAT table does not overflow */
> > +	fat_clusters = calc_fat_clusters(sb);
> > +	total_clusters = min(total_clusters,
> > fat_clusters - FAT_START_ENT);
> 
> Ah, you meant this duplicated one.
> 
> Let's use structure like fat_boot_sector (but more cpu
> friendly) on stack or something, instead of modify bh
> (BPB). Modifying bh in bdev is visible via /dev/foo, this
> is why I want to avoid to modify.
> 
> With this, we can share almost all codes on both of
> read_bpb() and static_bpb(), and avoids to modify bdev
> buffer? And those 2 helpers only has small chunk of code,
> and provide the required parameters?
> 
> Thanks.

Hi,

I think I understand the idea, sounds good to me. Working to
clean up now.

Thanks again,
Conrad
