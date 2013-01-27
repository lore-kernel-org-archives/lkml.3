Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156Ab3A0HRI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 02:17:08 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:48928 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756046Ab3A0HRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 02:17:05 -0500
Date: Sat, 26 Jan 2013 23:16:13 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>
Subject: Re: block: optionally snapshot page contents to provide stable pages
 during write
Message-ID: <20130127071613.GA4761@blackbox.djwong.org>
References: <CA+icZUXsi0jZZE9HBWG0D6-+oJBeX+8nHpZ9F02x=B7dG3X+yg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUXsi0jZZE9HBWG0D6-+oJBeX+8nHpZ9F02x=B7dG3X+yg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 26, 2013 at 01:39:46PM +0100, Sedat Dilek wrote:
> Hi Darrick,
> 
> can you tell me why you do not put your help text where it normally
> belongs ("help" Kconfig item)?

Sure -- the non-ISA bounce pool is only used by a small number of specific
parts of the kernel that require it.  If those parts aren't built, then forcing
it on causes a useless memory pool to be created, wasting memory.  Since kbuild
can figure out when we need it and when we don't, there's no need to present
the user with a config option that they can only use to do the wrong thing.

--D
> 
> 273 # We also use the bounce pool to provide stable page writes for jbd.  jbd
> 274 # initiates buffer writeback without locking the page or setting
> PG_writeback,
> 275 # and fixing that behavior (a second time; jbd2 doesn't have this
> problem) is
> 276 # a major rework effort.  Instead, use the bounce buffer to snapshot pages
> 277 # (until jbd goes away).  The only jbd user is ext3.
> 278 config NEED_BOUNCE_POOL
> 279         bool
> 280         default y if (TILE && USB_OHCI_HCD) || (BLK_DEV_INTEGRITY && JBD)
> 281         help
> 282         line #273..277
> 
> Noticed while hunting a culprit commit in Linux-Next as my
> kernel-config got changed between next-20130123..next-20130124.
> 
> Regards,
> - Sedat -
> 
> [1] http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commitdiff;h=3f1c22e#patch5
