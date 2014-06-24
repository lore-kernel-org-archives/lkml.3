Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014AbaFXLQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 07:16:25 -0400
Received: from mail.phunq.net ([184.71.0.62]:36943 "EHLO starbase.phunq.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752091AbaFXLQX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 07:16:23 -0400
From: Daniel Phillips <daniel@phunq.net>
To: Dave Chinner <david@fromorbit.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        =?utf-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>,
        Pavel Machek <pavel@ucw.cz>, <linux-kernel@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] Tux3 for review
Date: Tue, 24 Jun 2014 04:16:14 -0700
User-Agent: Trojita/0.4.1; Qt/4.8.6; X11; Linux; Ubuntu 14.04 LTS
MIME-Version: 1.0
Message-ID: <99b6bb23-4255-4c39-9281-96288dc6d73c@phunq.net>
In-Reply-To: <20140622010600.GX9508@dastard>
References: <20140520031802.GF18954@dastard>
 <20140613103216.GA4589@amd.pavel.ucw.cz>
 <02d3b094-808c-4b17-903d-1280d451704b@phunq.net>
 <20140613202039.GA23872@amd.pavel.ucw.cz>
 <b67e55e1-af54-4f34-802c-95749771aca4@phunq.net>
 <1402932354.2197.61.camel@dabdike.int.hansenpartnership.com>
 <20140619082129.GA4309@xo-6d-61-c0.localdomain>
 <alpine.LFD.2.00.1406191117240.2182@localhost.localdomain>
 <ad0baf8f-091f-45d0-8d9f-f72d78d0d1ff@phunq.net>
 <1403378941.2177.24.camel@dabdike.int.hansenpartnership.com>
 <20140622010600.GX9508@dastard>
Organization: tux3.org
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, June 21, 2014 6:06:00 PM PDT, Dave Chinner wrote:
> BTW, it's worth noting that reviewers are *allowed* to change their
> mind at any time during a discussion or during review cycles.
> Indeed, this occurs quite commonly. It's no different to multiple
> reviewers disagreeing on what the best way to make the improvement
> is - sometimes it takes an implementation to solidify opinion on the
> best approach to solving a problem.

The issue I have is not that you changed your mind per se, but
that you were right the first time and wrong the second time.
As you know, reviewers are not just allowed to change their
minds but are also allowed to be wrong from time to time.

The reason that you were wrong the second time is not that the
interface you proposed is wrong - I believe that we violently
agree about superblock-based writeback as the correct approach
long term - but that the current, inode based writeback already
works well enough for our needs. It therefore makes exactly zero
sense to go off on a tangent to engineer a new core mechanism
at the same time as merging the filesystem. The correct way to
do it is to get a likely user into kernel first (Tux3) and
then engineer the new interface that will be so all-dancing
that you will immediately feel compelled to adopt it for XFS.

Obviously, with only one user of the imperfect/functional
interface the maintenance overhead of updating it to the new
perfect/amazing interface rounds to zero. Remember, this is an
_internal_ API, so the do-not-break rule simply does not apply.
Instead, the "perfect is the enemy of good enough" rule is
operative.

Just to reiterate for the tl;dr amongst us: you were right the
first time. Go ahead and change your mind, but when you finally
realize that you were wrong the second time, please do let us
know.

Meanwhile, we must concentrate on the upcoming page forking
hooks, which promise to provide even more scope for being both
right and wrong, and smart or stupid about which parts of the
kernel should be deeply re-engineered versus prudently adapted
to evolving needs.

Regards,

Daniel
