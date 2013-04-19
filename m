Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab3DSBQr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 21:16:47 -0400
Received: from smtprelay0073.hostedemail.com ([216.40.44.73]:46543 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751625Ab3DSBQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 21:16:45 -0400
X-Greylist: delayed 465 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Apr 2013 21:16:45 EDT
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Panda: scanned!
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::::::,RULES_HIT:152:355:379:599:800:960:966:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1431:1437:1515:1516:1518:1534:1538:1567:1593:1594:1711:1714:1730:1747:1777:1792:2196:2199:2393:2559:2562:3138:3139:3140:3141:3142:3865:3866:3868:3872:4385:5007:6119:7652:7875:7903:9413:10004:10400:10848:11658:11914:12517:12519:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: join19_6b8797157f427
X-Filterd-Recvd-Size: 1852
User-Agent: K-9 Mail for Android
In-Reply-To: <20130418203705.GJ4816@kernel.dk>
References: <516FED09.1040008@cn.fujitsu.com> <20130418133546.GX4816@kernel.dk> <516FFFAC.8040103@cn.fujitsu.com> <20130418143014.GZ4816@kernel.dk> <CA+55aFwA8njGh4v8ZfR_o4s4m=Hugnadeir=uxbeE4yxHiBKLg@mail.gmail.com> <20130418172732.GB9897@mtj.dyndns.org> <20130418173811.GF4816@kernel.dk> <20130418180752.GD9897@mtj.dyndns.org> <20130418181318.GH4816@kernel.dk> <CA+55aFxEThMJid_PiL=ko3duRPzzynkhMovsrm3TR_UXxUGciA@mail.gmail.com> <20130418203705.GJ4816@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [BUG REPORT] Kernel panic on 3.9.0-rc7-4-gbb33db7
From: "srostedt@gmail.com" <rostedt@goodmis.org>
Date: Thu, 18 Apr 2013 21:08:54 -0400
To: Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Tejun Heo <tj@kernel.org>, Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        Namhyung Kim <namhyung@gmail.com>, Alasdair G Kergon <agk@redhat.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        Neil Brown <neilb@suse.de>, LKML <linux-kernel@vger.kernel.org>
Message-ID: <292ec4c2-f2d3-47fc-816f-472e83c10959@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Could it be a module not recompiled with a newer kernel?

-- Steve


Jens Axboe <axboe@kernel.dk> wrote:


>
>Hmm dunno. It happens right after we've completed the bio, which
>touches
>a lot of fields too. bi_bdev sits between bi_next (which we definitely
>used) and bi_flags.
>
>But adding slab use-after-free debugging would show for sure.

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
