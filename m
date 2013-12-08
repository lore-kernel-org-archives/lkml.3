Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759309Ab3LHQek (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 11:34:40 -0500
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:11716 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754768Ab3LHQei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 11:34:38 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuYTAJGepFJXQD2Q/2dsb2JhbABZJ4JgOIJ+tmECAoEWF3SCJQEBBAE6HCMFCwgDDgouOR4GE4d8CgEIwCwTBI0XgUYzB4QzA4lAjlMBkhODNi8
Date: Sun, 8 Dec 2013 16:35:26 +0800
From: Fabian Frederick <fabf@skynet.be>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, npiggin@gmail.com
Subject: Re: [PATCH 1/1] ramdisk: documentation update
Message-Id: <20131208163526.7143455a40dae6357b7dad32@skynet.be>
In-Reply-To: <52A3E52F.1090303@infradead.org>
References: <20131207075221.5401d0c4fdebe5515c4f1643@skynet.be>
	<52A3E52F.1090303@infradead.org>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 07 Dec 2013 19:19:11 -0800
Randy Dunlap wrote:

> On 12/06/13 15:52, Fabian Frederick wrote:
> > -ramdisk_blocksize doesn't exist anymore.
> > -Module parameters added to documentation.
> > 
> > Signed-off-by: Fabian Frederick <fabf@skynet.be>
> > ---
> >  Documentation/blockdev/ramdisk.txt | 23 ++++++++++++++++++-----
> >  1 file changed, 18 insertions(+), 5 deletions(-)
> > 
> > diff --git a/Documentation/blockdev/ramdisk.txt b/Documentation/blockdev/ramdisk.txt
> > index fa72e97..5dca7b1 100644
> > --- a/Documentation/blockdev/ramdisk.txt
> > +++ b/Documentation/blockdev/ramdisk.txt
> > @@ -36,21 +36,30 @@ allowing one to squeeze more programs onto an average installation or
> >  rescue floppy disk.
> >  
> >  
> > -2) Kernel Command Line Parameters
> > +2) Parameters
> >  ---------------------------------
> >  
> > +2a) Kernel Command Line Parameters
> > +
> >  	ramdisk_size=N
> >  	==============
> >  
> >  This parameter tells the RAM disk driver to set up RAM disks of N k size.  The
> >  default is 4096 (4 MB) (8192 (8 MB) on S390).
> 
> I don't find any place that S390 changes CONFIG_BLK_DEV_RAM_SIZE from its default
> of 4096 to 8192.  Did you?  If so, where please?

You're right, it's an old S390 recommendation.I'm removing it as well :)

> 
> 
> >  
> > -	ramdisk_blocksize=N
> > -	===================
> > +2b) Module parameters
> > +
> > +	rd_nr
> > +	=====
> > +	/dev/ramX devices created.
> >  
> > -This parameter tells the RAM disk driver how many bytes to use per block.  The
> > -default is 1024 (BLOCK_SIZE).
> > +	max_part
> > +	========
> > +	Maximum partition number.
> >  
> > +	rd_size
> > +	=======
> > +	cf ramdisk_size.
> 
> Compare to ramdisk_size?  how about
> 
> 	See ramdisk_size.
> or
> 	Same as ramdisk_size.

ok.
> 
> >  
> >  3) Using "rdev -r"
> >  ------------------
> 
> 
> As for the Changelog, it would be better just to delete all of it.
> That's what git is for (and good at).

Git only gives post 2008 updates.I guess we keep previous changelogs in text mode where 
available ?

I had no reaction to this patch (also about ramdisk) 
https://lkml.org/lkml/2013/12/6/748
Should I merge it to this one ?

> 
> 
> -- 
> ~Randy

Fabian
