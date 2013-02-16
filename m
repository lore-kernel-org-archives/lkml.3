Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431Ab3BPIZS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 03:25:18 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:63528 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab3BPIZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 03:25:17 -0500
Date: Sat, 16 Feb 2013 09:25:12 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>, Greg KH <gregkh@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@ftp.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
        Laura Abbott <lauraa@codeaurora.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: [-rc7 regression] Buggy commit: "mm: use aligned zone start for
 pfn_to_bitidx calculation"
Message-ID: <20130216082512.GA18851@gmail.com>
References: <CA+55aFz50VvnMjoDCbg01N+rMu5vscu88kr0SV3tWLjaiL0TeA@mail.gmail.com>
 <20130213111007.GA11367@gmail.com>
 <CA+55aFxrjsVkBwUdjmc4MYvEsjEyCJZ7AFpGrWvbbQFB3EVtHA@mail.gmail.com>
 <alpine.LFD.2.02.1302140012460.22263@ionos>
 <20130214144510.GC25282@gmail.com>
 <20130214145424.GA26071@gmail.com>
 <20130214150810.GA26095@gmail.com>
 <CAE9FiQXc=7+TMwbfd20YiHNfOHX_kUOzYcVm8-uaP2R_C_1RRg@mail.gmail.com>
 <20130215114425.GD26955@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130215114425.GD26955@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> Revert attached below - it reverts cleanly and I'll test this 
> today, to see whether this solves the sporadic lockups.

Ok, the revert survived a day of hundreds of randconfigs - while 
it would lock up within 100 randconfigs before.

So this commit appears to be the root cause of the regression.

Thanks,

	Ingo
