Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbaCJN4u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 09:56:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715AbaCJN4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 09:56:48 -0400
Date: Mon, 10 Mar 2014 09:52:56 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Shaohua Li <shli@kernel.org>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk,
        agk@redhat.com
Subject: Re: [patch v3]DM: dm-insitu-comp: a compressed DM target for SSD
Message-ID: <20140310135256.GA28665@redhat.com>
References: <20140218101304.GA24889@kernel.org>
 <20140307075733.GB21790@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140307075733.GB21790@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07 2014 at  2:57am -0500,
Shaohua Li <shli@kernel.org> wrote:

> ping!

Hi,

I intend to get dm-insitu-comp reviewed for 3.15.  Sorry I haven't
gotten back with you before now, been busy tending to 3.14-rc issues.

I took a quick first pass over your code a couple weeks ago.  Looks to
be in great shape relative to coding conventions and the more DM
specific conventions.  Clearly demonstrates you have a good command of
DM concepts and quirks.

But one thing that would really help get dm-insitu-comp into 3.15 is to
show that the code is working as you'd expect.  To that end, it'd be
great if you'd be willing to add dm-insitu-comp support to the
device-mapper-test-suite, see:
https://github.com/jthornber/device-mapper-test-suite

I recently added barebones/simple dm-crypt support, see:
https://github.com/jthornber/device-mapper-test-suite/commit/c865bcd4e48228e18626d94327fb2485cf9ec9a1

But It may be that activation/test code for the other targets (e.g. thin
or cache) are more useful examples to follow for implemnting
dm-insitu-comp stack activation, see:
https://github.com/jthornber/device-mapper-test-suite/blob/master/lib/dmtest/pool-stack.rb
https://github.com/jthornber/device-mapper-test-suite/blob/master/lib/dmtest/cache_stack.rb

All said, implementing dm-insitu-comp support for dmts (including some
tests that establish it is working as intended) isn't a hard requirement
for getting the target upstream but it would _really_ help.

Mike
