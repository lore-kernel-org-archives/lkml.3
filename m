Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034AbaFYTDA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 15:03:00 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:43778 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902AbaFYTC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 15:02:58 -0400
Date: Wed, 25 Jun 2014 15:02:50 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Fabian Frederick <fabf@skynet.be>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] fs/omfs/inode.c: replace count*size kzalloc by
 kcalloc
Message-ID: <20140625190250.GB399@localhost>
References: <1403720237-19131-1-git-send-email-fabf@skynet.be>
 <CA+55aFypOwqaxfMwG5H8QSsRyMrMV7ibW_k5CQdc=EPXYmrfLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFypOwqaxfMwG5H8QSsRyMrMV7ibW_k5CQdc=EPXYmrfLg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 11:27:21AM -0700, Linus Torvalds wrote:
> On Wed, Jun 25, 2014 at 11:17 AM, Fabian Frederick <fabf@skynet.be> wrote:
> > kcalloc manages count*sizeof overflow.
> 
> As far as I can tell, any overflow has happened long before, in
> 
>     bitmap_size = DIV_ROUND_UP(sbi->s_num_blocks, 8);
> 
> where 'sbi->s_num_blocks' i san u64, and 'bitmap_size' is an 'int'.
> 
> I don't think the patch is necessarily a bad thing, but I think it
> might be more important to sanity-check that part instead.

Agreed - even though the FS data structures support 64-bit block
count, I've never seen an OMFS fs with more than about 2M blocks
(typical device had 20 gigs w/ 8k blocks).  So it would make
sense to bail in omfs_fill_super if that number is greater than
2^31 or so.

(I am fine with the kcalloc patch too, though.)

-- 
Bob Copeland %% www.bobcopeland.com
