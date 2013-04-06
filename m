Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163346Ab3DFMCQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 08:02:16 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:39998 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1163295Ab3DFMCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 08:02:14 -0400
From: "Michael D. Setzer II" <msetzerii@gmail.com>
To: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Date: Sat, 06 Apr 2013 22:02:08 +1000
MIME-Version: 1.0
Subject: Re: Error in linux-3.0.72 build.
Message-ID: <51600EC0.1522.21A5AE@msetzerii.gmail.com>
In-reply-to: <20130406112657.GA3625@pd.tnic>
References: <515FF835.28644.1FF1E@msetzerii.gmail.com>, <20130406112657.GA3625@pd.tnic>
X-mailer: Pegasus Mail for Windows (4.63)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 Apr 2013 at 13:26, Borislav Petkov wrote:

Date sent:      	Sat, 6 Apr 2013 13:26:57 +0200
From:           	Borislav Petkov <bp@alien8.de>
To:             	"Michael D. Setzer II" <msetzerii@gmail.com>
Copies to:      	linux-kernel@vger.kernel.org, 
linux-ext4@vger.kernel.org
Subject:        	Re: Error in linux-3.0.72 build.

> On Sat, Apr 06, 2013 at 08:25:57PM +1000, Michael D. Setzer II wrote:
> > Just downloaded new kernels, and find this error in build.
> > 
> > fs/built-in.o: In function `find_group_flex':
> > /home/msetzerii/data/linux-3.0.72/fs/ext4/ialloc.c:359: undefined 
> > reference to `__udivdi3'
> > /home/msetzerii/data/linux-3.0.72/fs/ext4/ialloc.c:374: undefined 
> > reference to `__udivdi3'
> > make: *** [.tmp_vmlinux1] Error 1
> 
> Looks like your compiler is generating 64-bit division which is a call
> into libgcc. Which gcc version are you using?
> 
> +ext4 folks.

Did a diff on the new ialloc.c and the previous one from 3.0.71

348,349c348,349
< 	ext4_fsblk_t blocks_per_flex = sbi->s_blocks_per_group * 
flex_size;
< 	ext4_fsblk_t flexbg_free_blocks;
---
> 	int blocks_per_flex = sbi->s_blocks_per_group * flex_size;
> 	int flexbg_free_blocks;
358c358
< 	flexbg_free_blocks = 
atomic64_read(&flex_group[best_flex].free_blocks);
---
> 	flexbg_free_blocks = 
atomic_read(&flex_group[best_flex].free_blocks);
373c373
< 		flexbg_free_blocks = 
atomic64_read(&flex_group[i].free_blocks);
---
> 		flexbg_free_blocks = 
atomic_read(&flex_group[i].free_blocks);
383,384c383,384
< 		    ((atomic64_read(&flex_group[i].free_blocks) >
< 		      
atomic64_read(&flex_group[best_flex].free_blocks)) &&
---
> 		    ((atomic_read(&flex_group[i].free_blocks) >
> 		      atomic_read(&flex_group[best_flex].free_blocks)) 
&&
390c390
< 	    !atomic64_read(&flex_group[best_flex].free_blocks))
---
> 	    !atomic_read(&flex_group[best_flex].free_blocks))
409d408
< 	__u64 free_blocks;
410a410
> 	__u32 free_blocks;
427c427
< 		stats->free_blocks = 
atomic64_read(&flex_group[g].free_blocks);
---
> 		stats->free_blocks = 
atomic_read(&flex_group[g].free_blocks);

> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --


+----------------------------------------------------------+
  Michael D. Setzer II -  Computer Science Instructor      
  Guam Community College  Computer Center                  
  mailto:mikes@kuentos.guam.net                            
  mailto:msetzerii@gmail.com
  http://www.guam.net/home/mikes
  Guam - Where America's Day Begins                        
  G4L Disk Imaging Project maintainer 
  http://sourceforge.net/projects/g4l/
+----------------------------------------------------------+

http://setiathome.berkeley.edu (Original)
Number of Seti Units Returned:  19,471
Processing time:  32 years, 290 days, 12 hours, 58 minutes
(Total Hours: 287,489)

BOINC@HOME CREDITS
SETI        14361044.287140   |   EINSTEIN    10723942.979852
ROSETTA      6832434.144171   |   ABC         15903532.519753

