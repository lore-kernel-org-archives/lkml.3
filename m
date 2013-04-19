Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030482Ab3DSNwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 09:52:20 -0400
Received: from dkim2.fusionio.com ([66.114.96.54]:49787 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968307Ab3DSNwS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 09:52:18 -0400
X-ASG-Debug-ID: 1366379535-03d6a51395176a60001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>
From: Chris Mason <clmason@fusionio.com>
In-Reply-To: <20130419133250.GR4816@kernel.dk>
CC: Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "namhyung@gmail.com" <namhyung@gmail.com>,
        "agk@redhat.com" <agk@redhat.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "neilb@suse.de" <neilb@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <516E5EF8.9090507@cn.fujitsu.com>
 <1366209997.8817.12.camel@pippen.local.home>
 <20130418123738.GV4816@kernel.dk> <516FED09.1040008@cn.fujitsu.com>
 <20130418133546.GX4816@kernel.dk> <516FFFAC.8040103@cn.fujitsu.com>
 <20130418143014.GZ4816@kernel.dk> <5170BB00.8080200@cn.fujitsu.com>
 <20130419055754.GA9691@mtj.dyndns.org> <20130419133250.GR4816@kernel.dk>
Message-ID: <20130419135214.30947.96188@localhost.localdomain>
User-Agent: alot/0.3.4
Subject: Re: [BUG REPORT] Kernel panic on 3.9.0-rc7-4-gbb33db7
Date: Fri, 19 Apr 2013 09:52:14 -0400
X-ASG-Orig-Subj: Re: [BUG REPORT] Kernel panic on 3.9.0-rc7-4-gbb33db7
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1366379535
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.128572
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Jens Axboe (2013-04-19 09:32:50)
> > 
> > No wonder this thing crashes.  Chris, can't the original bio carry
> > bbio in bi_private and let end_bio_extent_readpage() free the bbio
> > instead of abusing bi_bdev like this?
> 
> Ugh, wtf.
> 
> Chris, time for a swim in the bay :-)

Yeah, I can't really defend this one.  We needed a space for an int and
I assumed end_io meant the FS was free to do horrible things.

Really though, I'll just take a quick dip in the lake and patch this out
of btrfs. 

Jan is probably right about changing around our endio callbacks to
explicitly pass the mirror, it should be less complex and cleaner.

Many thanks to everyone here that tracked it down.

-chris
