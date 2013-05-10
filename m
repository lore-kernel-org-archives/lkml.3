Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab3EJOBm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:01:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39834 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771Ab3EJOBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:01:40 -0400
Date: Fri, 10 May 2013 15:01:32 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>, stable@vger.kernel.org,
        Bharata B Rao <bharata.rao@gmail.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: Re: [dm-devel] [git pull] device-mapper updates for 3.10
Message-ID: <20130510140132.GA3580@agk-dp.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>, stable@vger.kernel.org,
	Bharata B Rao <bharata.rao@gmail.com>,
	Wei Yongjun <yongjun_wei@trendmicro.com.cn>
References: <20130510102029.GE1396@agk-dp.fab.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130510102029.GE1396@agk-dp.fab.redhat.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 11:20:29AM +0100, Alasdair G Kergon wrote:
> Please pull from:
>   git://git.kernel.org/pub/scm/linux/kernel/git/agk/linux-dm tags/dm-3.10-changes

And the kbuild test robot just spotted that I lost a line from one of
the patches which meant the thin threshold notification wouldn't
happen, sorry.

Take two...

Alasdair


Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/agk/linux-dm tags/dm-3.10-changes-2

to get the following device-mapper updates for 3.10.

----------------------------------------------------------------
Allow devices that hold metadata for the device-mapper thin
provisioning target to be extended easily; allow WRITE SAME on
multipath devices; an assortment of little fixes and clean-ups.

----------------------------------------------------------------
Alasdair G Kergon (3):
      dm: document iterate_devices
      dm cache policy: fix description of lookup fn
      dm cache: move config fns

Joe Thornber (12):
      dm cache: tune migration throttling
      dm persistent data: fix error message typos
      dm cache: fix typos in comments
      dm cache: replace memcpy with struct assignment
      dm thin: refactor data dev resize
      dm thin: open dev read only when possible
      dm persistent data: support space map resizing
      dm thin: detect metadata device resizing
      dm persistent data: add threshold callback to space map
      dm persistent metadata: add space map threshold callback
      dm thin: generate event when metadata threshold passed
      dm cache: set config value

Mike Snitzer (3):
      dm stripe: fix regression in stripe_width calculation
      dm table: fix write same support
      dm mpath: enable WRITE SAME support

Mikulas Patocka (1):
      dm bufio: avoid a possible __vmalloc deadlock

Wei Yongjun (2):
      dm cache: fix error return code in cache_create
      dm snapshot: fix error return code in snapshot_ctr

 drivers/md/dm-bufio.c                              |   24 ++-
 drivers/md/dm-cache-metadata.c                     |    4 +-
 drivers/md/dm-cache-policy.h                       |    4 +-
 drivers/md/dm-cache-target.c                       |  100 +++++-----
 drivers/md/dm-mpath.c                              |    1 +
 drivers/md/dm-snap.c                               |    1 +
 drivers/md/dm-stripe.c                             |   11 +-
 drivers/md/dm-table.c                              |    2 +-
 drivers/md/dm-thin-metadata.c                      |   36 +++-
 drivers/md/dm-thin-metadata.h                      |    7 +
 drivers/md/dm-thin.c                               |  200 ++++++++++++++++----
 drivers/md/persistent-data/dm-space-map-disk.c     |    3 +-
 drivers/md/persistent-data/dm-space-map-metadata.c |  127 +++++++++++--
 drivers/md/persistent-data/dm-space-map.h          |   23 +++
 include/linux/device-mapper.h                      |   15 ++
 15 files changed, 442 insertions(+), 116 deletions(-)
