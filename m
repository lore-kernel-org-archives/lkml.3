Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab3JIWO1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 18:14:27 -0400
Received: from smtprelay0215.hostedemail.com ([216.40.44.215]:59659 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754076Ab3JIWO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 18:14:26 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2692:2828:2904:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3871:3872:3873:3874:4321:5007:6119:7652:7903:10004:10400:10848:11232:11658:11914:12296:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netchec
X-HE-Tag: bed50_7d82f3677bf39
X-Filterd-Recvd-Size: 2086
Message-ID: <1381356861.2050.33.camel@joe-AO722>
Subject: Re: [PATCH v3] vsprintf: Check real user/group id for %pK
From: Joe Perches <joe@perches.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, eldad@fogrefinery.com,
        Jiri Kosina <jkosina@suse.cz>, jgunthorpe@obsidianresearch.com,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        George Spelvin <linux@horizon.com>,
        "kernel-hardening@lists.openwall.com" 
	<kernel-hardening@lists.openwall.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 09 Oct 2013 15:14:21 -0700
In-Reply-To: <5255D2FD.6050705@gmail.com>
References: <5255D023.2030907@gmail.com>
	 <1381356014.2050.28.camel@joe-AO722> <5255D2FD.6050705@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-10 at 09:04 +1100, Ryan Mallon wrote:
> On 10/10/13 09:00, Joe Perches wrote:
[]
> > Move the interrupt tests and pK-error printk
> > into case 1:
> > 
> > It's the only case where CAP_SYSLOG needs to be
> > tested so it doesn't need to be above the switch.
> 
> Like I said, I think it is useful to do the pK-error check anyway. It is
> checking for internal kernel bugs, since if 'pK-error' ever gets
> printed, then some kernel code is doing the wrong thing.

I think you don't quite understand how kptr_restrict works.

If it's 0, then the ptr value is always emitted naturally.
if it's 2, then the ptr value is always emitted as 0.

> Therefore, I
> think it is useful to print it always (I would argue it even makes sense
> when kptr_restrict=0).

How?  Maybe it's me that doesn't quite understand.


