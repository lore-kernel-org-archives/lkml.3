Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761160Ab3BNOyb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 09:54:31 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:60287 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680Ab3BNOy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 09:54:28 -0500
Date: Thu, 14 Feb 2013 15:54:24 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@ftp.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [-rc7 regression] Block IO/VFS/ext3/timer spinlock lockup?
Message-ID: <20130214145424.GA26071@gmail.com>
References: <CA+55aFz50VvnMjoDCbg01N+rMu5vscu88kr0SV3tWLjaiL0TeA@mail.gmail.com>
 <20130213111007.GA11367@gmail.com>
 <CA+55aFxrjsVkBwUdjmc4MYvEsjEyCJZ7AFpGrWvbbQFB3EVtHA@mail.gmail.com>
 <alpine.LFD.2.02.1302140012460.22263@ionos>
 <20130214144510.GC25282@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130214144510.GC25282@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> CPU0 appears to be idle:
> 
> [  118.510000] Call Trace:
> [  118.510000]  [<7900844b>] cpu_idle+0x86/0xb4
> [  118.510000]  [<792a91df>] rest_init+0x103/0x108
> [  118.510000]  [<794558cc>] start_kernel+0x2c7/0x2cc


So, I've done a partial bisection, the breakage appears to have 
gone upstream between v3.8-rc3 and v3.8-rc4.

This roughly coincides with the time frame when I first saw 
these lockups pop up, so in that sense it's a plausible result - 
but there weren't all that many commits in -rc4 and none looks 
really suspicious, so this might be one of those non-bisectable 
bugs.

( Later today I'll try to finish the bisection just in case it
  results in something useful. )

Thanks,

	Ingo
