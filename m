Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842Ab3EUOeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 10:34:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179Ab3EUOeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 10:34:36 -0400
Date: Tue, 21 May 2013 16:34:25 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
X-X-Sender: lukas@localhost
To: Lukas Czerner <lczerner@redhat.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        akpm@linux-foundation.org, hughd@google.com
Subject: Re: [PATCH v4 00/20] change invalidatepage prototype to accept
 length
In-Reply-To: <1368549454-8930-1-git-send-email-lczerner@redhat.com>
Message-ID: <alpine.LFD.2.00.1305211622330.2469@localhost>
References: <1368549454-8930-1-git-send-email-lczerner@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 May 2013, Lukas Czerner wrote:

> Date: Tue, 14 May 2013 18:37:14 +0200
> From: Lukas Czerner <lczerner@redhat.com>
> To: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
>     linux-ext4@vger.kernel.org, akpm@linux-foundation.org, hughd@google.com,
>     lczerner@redhat.com
> Subject: [PATCH v4 00/20] change invalidatepage prototype to accept length

Hi Ted,

you've mentioned that you'll carry the changed in the ext4 tree. Are
you going to take it for the next merge window ?

However I still need some review on the mm part of the series,
Andrew, Hugh, anyone ?

Thanks!
-Lukas

> 
> Hi,
> 
> This set of patches are aimed to allow truncate_inode_pages_range() handle
> ranges which are not aligned at the end of the page. Currently it will
> hit BUG_ON() when the end of the range is not aligned. Punch hole feature
> however can benefit from this ability saving file systems some work not
> forcing them to implement their own invalidate code to handle unaligned
> ranges.
> 
> In order for this to woke we need change ->invalidatepage() address space
> operation to to accept range to invalidate by adding 'length' argument in
> addition to 'offset'. This is different from my previous attempt to create
> new aop ->invalidatepage_range (http://lwn.net/Articles/514828/) which I
> reconsidered to be unnecessary.
> 
> It would be for the best if this series could go through ext4 branch since
> there are a lot of ext4 changes which are based on dev branch of ext4 
> (git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git)
> 
> For description purposes this patch set can be divided into following
> groups:
> 
> patch 0001:    Change ->invalidatepage() prototype adding 'length' argument
> 	and changing all the instances. In very simple cases file
> 	system methods are completely adapted, otherwise only
> 	prototype is changed and the rest will follow. This patch
> 	also implement the 'range' invalidation in
> 	block_invalidatepage().
> 
> patch 0002 - 0009:
> 	Make the use of new 'length' argument in the file system
> 	itself. Some file systems can take advantage of it trying
> 	to invalidate only portion of the page if possible, some
> 	can't, however none of the file systems currently attempt
> 	to truncate non page aligned ranges.
> 
> 
> patch 0010:    Teach truncate_inode_pages_range() to handle non page aligned
> 	ranges.
> 
> patch 0011 - 0020:
> 	Ext4 changes build on top of previous changes, simplifying
> 	punch hole code. Not all changes are realated specifically
> 	to invalidatepage() change, but all are related to the punch
> 	hole feature.
> 
> Even though this patch set would mainly affect functionality of the file
> file systems implementing punch hole I've tested all the following file
> system using xfstests without noticing any bugs related to this change.
> 
> ext3, ext4, xfs, btrfs, gfs2 and reiserfs
> 
> I've also tested block size < page size on ext4 with xfstests and fsx.
> 
> 
> v3 -> v4: Some minor changes based on the reviews. Added two ext4 patches
> 	  as suggested by Jan Kara.
> 
> Thanks!
> -Lukas
> 
> 
