Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933451Ab3HGVy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:54:57 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:55710 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932518Ab3HGVyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:54:54 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: axboe@kernel.dk
Cc: neilb@suse.de, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        dm-devel@redhat.com, linux-raid@vger.kernel.org
Subject: [PATCH 0/22] Immutable biovecs, block layer changes
Date: Wed,  7 Aug 2013 14:54:09 -0700
Message-Id: <1375912471-5106-1-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens - here's the immutable biovec patch series. I'd really like to get
this stuff into 3.12 if at all possible, and I think this series ought
to be ready - and, the dio rewrite and various other fun stuff is gated
on this stuff.

Not much in these patches has changed over the past six months or so,
besides rebasing. The first two patches are new, but pretty trivial.

Testing wise - I've exercised the core changes pretty thoroughly with
bcache, but the driver changes are pretty hard for me to test - even if
I managed to get test environments rigged up for everything, I wouldn't
trust myself to get useful code coverage - so this is going to need help
from the various driver maintainers testing wise. Fortunately, most of
the driver changes are pretty mechanical.

I _did_ test the md changes as well as I could think of, to hopefully
avoid a similar fiasco as the one in 3.10 with the bio_copy_data().
Uhh, apologies for sticking you with that Neil, hopefully this series
goes smoother :)

Jens - I'm sure you'll want to performance test this stuff before it
goes in, and it would be warrented; this does inflate struct bio.

_However_, I have more patches (that depend on this patch series) to get
that back - segment merging improvements that get rid of
bi_seg_front_size, bi_seg_back_size, and bi_phys_segments. Once all that
is in it should be a net reduction to the size of struct bio.

Patch series is available in git -
git://evilpiepirate.org/~kent/linux-bcache.git for-jens

