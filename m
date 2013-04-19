Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030246Ab3DSMPh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 08:15:37 -0400
Received: from dkim1.fusionio.com ([66.114.96.53]:41564 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968240Ab3DSMPf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 08:15:35 -0400
X-ASG-Debug-ID: 1366373734-03d6a52ac02fe0c0001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Tejun Heo <tj@kernel.org>, Wanlong Gao <gaowanlong@cn.fujitsu.com>
From: Chris Mason <clmason@fusionio.com>
In-Reply-To: <20130419055754.GA9691@mtj.dyndns.org>
CC: Jens Axboe <axboe@kernel.dk>, Steven Rostedt <rostedt@goodmis.org>,
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
 <20130419055754.GA9691@mtj.dyndns.org>
Message-ID: <20130419121532.30947.69296@localhost.localdomain>
User-Agent: alot/0.3.4
Subject: Re: [BUG REPORT] Kernel panic on 3.9.0-rc7-4-gbb33db7
Date: Fri, 19 Apr 2013 08:15:32 -0400
X-ASG-Orig-Subj: Re: [BUG REPORT] Kernel panic on 3.9.0-rc7-4-gbb33db7
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1366373734
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.128566
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tejun Heo (2013-04-19 01:57:54)
> 
> Ewweeeeeeeeeeeeeeeeeehh........
> 
> No wonder this thing crashes.  Chris, can't the original bio carry
> bbio in bi_private and let end_bio_extent_readpage() free the bbio
> instead of abusing bi_bdev like this?

Yes, we can definitely carry bbio up higher in the stack.  I'll patch it
up right now.  I do agree that it'll be too big for -final, but we'll
have it either way.

-chris

