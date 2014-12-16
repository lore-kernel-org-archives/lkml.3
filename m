Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751247AbaLPGgL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 01:36:11 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:54560 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbaLPGgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 01:36:09 -0500
Date: Mon, 15 Dec 2014 22:35:49 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Hogan <james.hogan@imgtec.com>, linux-metag@vger.kernel.org
Subject: Re: linux-next: Tree for Dec 16
Message-ID: <20141216063549.GA1060@roeck-us.net>
References: <20141216154622.7c2ded16@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141216154622.7c2ded16@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A010203.548FD2D8.046F,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 3
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 03:46:22PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Please do not add any code destined for v3.20 to your linux-next included
> trees/branches until after v3.19-rc1 is released.
> 
> Changes since 20141215:
> 
> The infiniband tree gained a conflict against Linus' tree and a build
> failure so I used the version from next-20141215.
> 
> The userns tree gained a conflict against the vfs tree.
> 
> The clk tree gained a build failure so I used the version from
> next-20141215.
> 
> Non-merge commits (relative to Linus' tree): 3588
>  2582 files changed, 123494 insertions(+), 135748 deletions(-)
> 

My metag buildbot test fails with this kernel.

bisect result:

a82be12232dcccf6b914cec7458e96ee79fae0e3 is the first bad commit
commit a82be12232dcccf6b914cec7458e96ee79fae0e3
Author: Andy Lutomirski <luto@amacapital.net>
Date:   Tue Dec 16 13:26:43 2014 +1100

    all arches, signal: move restart_block to struct task_struct

bisect log:

# bad: [a0eda581bf3fdc7be6bdf4cb18ce087675699336] Add linux-next specific files for 20141216
# good: [b2776bf7149bddd1f4161f14f79520f17fc1d71d] Linux 3.18
git bisect start 'HEAD' 'v3.18'
# good: [27afc5dbda52ee3dbcd0bda7375c917c6936b470] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux
git bisect good 27afc5dbda52ee3dbcd0bda7375c917c6936b470
# good: [a5e6d5b3bb7124309ce581e9e050e029ab037609] Merge remote-tracking branch 'l2-mtd/master'
git bisect good a5e6d5b3bb7124309ce581e9e050e029ab037609
# good: [93cc1d514a7e8bc4e00ce913ddccb34ee8a2a001] Merge remote-tracking branch 'ipmi/for-next'
git bisect good 93cc1d514a7e8bc4e00ce913ddccb34ee8a2a001
# good: [865cde938ee6ab758fd47d1a36150aee20371b85] staging: unisys: virtpci: Fix CamelCase in delete_vbus_device()
git bisect good 865cde938ee6ab758fd47d1a36150aee20371b85
# good: [594e400a2c3a64d7c3ba8ad7b0196c887a354100] staging: comedi: das6402: add basic (*do_cmdtest) for AI async commands
git bisect good 594e400a2c3a64d7c3ba8ad7b0196c887a354100
# good: [4e8bb35b814a1377dcaf48b98d4ab29176528cdc] Merge remote-tracking branch 'target-updates/for-next'
git bisect good 4e8bb35b814a1377dcaf48b98d4ab29176528cdc
# good: [e03f3bb62ca8a1124bc408046c50aed7629b24cc] next-20141215/clk
git bisect good e03f3bb62ca8a1124bc408046c50aed7629b24cc
# bad: [a82be12232dcccf6b914cec7458e96ee79fae0e3] all arches, signal: move restart_block to struct task_struct
git bisect bad a82be12232dcccf6b914cec7458e96ee79fae0e3
# good: [4425fdc4c01ab7699072a417741a008b0dca576b] ocfs2: do not fallback to buffer I/O write if appending
git bisect good 4425fdc4c01ab7699072a417741a008b0dca576b
# good: [98b090c1d15d1c94f01f071b283ce44be8644220] mm: define MADV_FREE for some arches
git bisect good 98b090c1d15d1c94f01f071b283ce44be8644220
# good: [ca402e9bfbbac21d3d7541c33adb60f7ebcc480e] arm: add pmd_mkclean for THP
git bisect good ca402e9bfbbac21d3d7541c33adb60f7ebcc480e
# good: [60eeb1279b50c205f045d2b7c76c906a2d2fb751] mm: Fix comment typo "CONFIG_TRANSPARNTE_HUGE"
git bisect good 60eeb1279b50c205f045d2b7c76c906a2d2fb751
# good: [1134212f12cb9e5b3c24b7be5cfa304486f2f96b] do_shared_fault(): check that mmap_sem is held
git bisect good 1134212f12cb9e5b3c24b7be5cfa304486f2f96b
# first bad commit: [a82be12232dcccf6b914cec7458e96ee79fae0e3] all arches, signal: move restart_block to struct task_struct

--

Guenter
