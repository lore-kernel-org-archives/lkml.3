Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660Ab3K2N04 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 08:26:56 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36935 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab3K2N0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 08:26:55 -0500
Date: Fri, 29 Nov 2013 14:26:53 +0100
From: Pavel Machek <pavel@ucw.cz>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Peter Korsgaard <jacmet@sunsite.dk>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Richard Genoud <richard.genoud@gmail.com>, zhouguangming@innofidei.com,
        Hans Zhang <zhanghonghui@innofidei.com>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Make the mtdblock read/write skip the bad nand sector
Message-ID: <20131129132653.GA14204@amd.pavel.ucw.cz>
References: <20131122114509.GB2414@localhost>
 <5292A7E7.5060003@innofidei.com>
 <20131125101147.GA2408@localhost>
 <CACQ1gAi26WeiopptcZmBp6h0a5TacLo5mvVCOm6-H_1HtnwvXg@mail.gmail.com>
 <529334D9.2030204@innofidei.com>
 <20131125115238.GC2408@localhost>
 <1385381770.24518.18.camel@shinybook.infradead.org>
 <20131125123012.GE2408@localhost>
 <87fvqkldmh.fsf@dell.be.48ers.dk>
 <1385394419.24518.40.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385394419.24518.40.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Hi,
> > 
> >  > Thanks a lot for the insight. After reading this, I'm wondering what's
> >  > preventing us from killing MTD block support altogether. Artem, already
> >  > suggested it a while back...
> > 
> > People using squashfs/cramfs/readonly ext2/.. on a NOR flash?
> 
> And people who *still*, after all these years, don't realise that they
> don't actually need it to mount JFFS2. Even as the root file system
> (although they *do* need rootfstype=jffs2).

I must admit I'm such person...

I guess printk("...you don't really need mtdblock...") in jffs2's
mount code would probably improve that realisation...

This certainly does not help:

pavel@amd:/data/l/linux-n900$ grep -ri mtdblock  Documentation
Documentation/frv/booting.txt:	   exec -c "console=ttySM0,115200
ip=:::::dhcp root=/dev/mtdblock2 rw"
Documentation/frv/booting.txt:	 /dev/mtdblock3	Fourth RedBoot
partition on the System Flash
Documentation/arm/SA1100/Assabet:which is the third one.  Within
Linux, this correspond to /dev/mtdblock2.
Documentation/arm/SA1100/Assabet:	exec -b 0x100000 -l 0xc0000 -c
"root=/dev/mtdblock2"

(Should not mtdblock be at least in devices.txt file?)

BTW... is there documentation of mtdblock "translation layer"
somewhere? I realize it is very simple, but it does need to keep some
data?

I guess running jffs on regular block device (USB stick, SD card) is
not feasible?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
