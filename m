Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab3KONkf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 08:40:35 -0500
Received: from dkim2.fusionio.com ([66.114.96.54]:48952 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab3KONk0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 08:40:26 -0500
X-ASG-Debug-ID: 1384522825-0421b57ae5ecea0001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Heiko Carstens <heiko.carstens@de.ibm.com>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <20131115122131.3802.25439@localhost.localdomain>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-btrfs@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Mark Brown <broonie@kernel.org>
References: <20131114171952.3802.93244@localhost.localdomain>
 <20131115113216.GA7777@osiris>
 <20131115122131.3802.25439@localhost.localdomain>
Message-ID: <20131115134019.3802.51473@localhost.localdomain>
User-Agent: alot/0.3.4
Subject: Re: [GIT PULL] Btrfs
Date: Fri, 15 Nov 2013 08:40:19 -0500
X-ASG-Orig-Subj: Re: [GIT PULL] Btrfs
X-Originating-IP: [10.101.1.160]
X-Barracuda-Connect: cas1.int.fusionio.com[10.101.1.40]
X-Barracuda-Start-Time: 1384522825
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.142337
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Chris Mason (2013-11-15 07:21:31)
> Quoting Heiko Carstens (2013-11-15 06:32:16)
> > On Thu, Nov 14, 2013 at 12:19:52PM -0500, Chris Mason wrote:
> > > Hi Linus,
> > > 
> > > Please pull my for-linus branch:
> > > 
> > > git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus
> > > 
> > > This is our usual merge window set of bug fixes, performance
> > > improvements and cleanups.  Miao Xie has some really nice optimizations
> > > for writeback.
> > > 
> > > Josef also expanded our sanity checks quite a bit; these make up a big
> > > chunk of the new lines.
> > 
> > Hmm..  b19e68439375  "btrfs: Remove redundant local zero structure" seems to
> > use the empty_zero_page incorrectly and causes this compile warning on s390:
> > 
> >   CC      fs/btrfs/ioctl.o
> > fs/btrfs/ioctl.c: In function 'btrfs_is_empty_uuid':
> > fs/btrfs/ioctl.c:372:2: warning: passing argument 2 of 'memcmp' makes pointer from
> >                         integer without a cast [enabled by default]
> >   return !memcmp(uuid, empty_zero_page, BTRFS_UUID_SIZE);
> >   ^
> > 
> > In fact there seem to be two more incorrect usages in the kernel. The patch
> > below is not really tested.
> 
> Thanks Heiko,
> 
> I'll make a new pull with the btrfs part of this.

Or something slightly different ;)

BUG: unable to handle kernel paging request at 0000000001ba6000
IP: [<ffffffff812b3656>] memcmp+0xf/0x22

-chris

