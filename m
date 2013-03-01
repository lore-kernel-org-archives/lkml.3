Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab3CAXCj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 18:02:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478Ab3CAXCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 18:02:37 -0500
Date: Fri, 1 Mar 2013 23:02:19 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bart Van Assche <bvanassche@acm.org>, Chao Yang <chyang@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org,
        Heinz Mauelshagen <mauelshagen@redhat.com>,
        Joe Thornber <ejt@redhat.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        Kees Cook <keescook@chromium.org>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Mike Snitzer <snitzer@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>, stable@vger.kernel.org,
        Wang Sheng-Hui <shhuiw@gmail.com>
Subject: [git pull] device-mapper updates for 3.9
Message-ID: <20130301230219.GB1877@agk.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Bart Van Assche <bvanassche@acm.org>, Chao Yang <chyang@redhat.com>,
	Dan Carpenter <dan.carpenter@oracle.com>, dm-devel@redhat.com,
	linux-kernel@vger.kernel.org,
	Heinz Mauelshagen <mauelshagen@redhat.com>,
	Joe Thornber <ejt@redhat.com>,
	Jun'ichi Nomura <j-nomura@ce.jp.nec.com>,
	Kees Cook <keescook@chromium.org>,
	Mike Christie <michaelc@cs.wisc.edu>,
	Mike Snitzer <snitzer@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>, stable@vger.kernel.org,
	Wang Sheng-Hui <shhuiw@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/agk/linux-dm tags/dm-3.9-changes

to get the following device-mapper updates for 3.9.

Thanks,
Alasdair

----------------------------------------------------------------
The main addition here is a long-desired target framework to allow
an SSD to be used as a cache in front of a slower device.  Cache
tuning is delegated to interchangeable policy modules so these can
be developed independently of the mechanics needed to shuffle the
data around.

Other than that, kcopyd users acquire a throttling parameter, ioctl
buffer usage gets streamlined, more mempool reliance is reduced
and there are a few other bug fixes and tidy-ups.

----------------------------------------------------------------
Alasdair G Kergon (6):
      dm: remove CONFIG_EXPERIMENTAL
      dm: clean up clone_bio
      dm: rename request variables to bios
      dm: rename bio cloning functions
      dm: refactor bio cloning
      dm: add target num_write_bios fn

Heinz Mauelshagen (1):
      dm cache: add cleaner policy

Joe Thornber (7):
      dm persistent data: add btree_walk
      dm bio prison: pass cell memory in
      dm thin: remove cells from stack
      dm persistent data: add transactional array
      dm persistent data: add bitset
      dm: add cache target
      dm cache: add mq policy

Jun'ichi Nomura (3):
      dm: do not replace bioset for request based dm
      dm: remove unused _rq_bio_info_cache
      dm: merge io_pool and tio_pool

Kees Cook (1):
      dm persistent data: remove CONFIG_EXPERIMENTAL

Mike Christie (1):
      dm: fix limits initialization when there are no data devices

Mike Snitzer (3):
      dm thin: support a non power of 2 discard_granularity
      dm thin: use block_size_is_power_of_two
      dm persistent data: set some btree fn parms const

Mikulas Patocka (7):
      dm: fix truncated status strings
      dm bufio: use WRITE_FLUSH instead of REQ_FLUSH
      dm snapshot: add missing module aliases
      dm ioctl: introduce ioctl_flags
      dm ioctl: optimize functions without variable params
      dm ioctl: allow message to return data
      dm kcopyd: introduce configurable throttling

Wang Sheng-Hui (1):
      dm table: remove superfluous variable reset

 Documentation/device-mapper/cache-policies.txt |   77 +
 Documentation/device-mapper/cache.txt          |  243 +++
 drivers/md/Kconfig                             |   55 +-
 drivers/md/Makefile                            |    6 +
 drivers/md/dm-bio-prison.c                     |  155 +-
 drivers/md/dm-bio-prison.h                     |   58 +-
 drivers/md/dm-bufio.c                          |    2 +-
 drivers/md/dm-cache-block-types.h              |   54 +
 drivers/md/dm-cache-metadata.c                 | 1146 +++++++++++
 drivers/md/dm-cache-metadata.h                 |  142 ++
 drivers/md/dm-cache-policy-cleaner.c           |  464 +++++
 drivers/md/dm-cache-policy-internal.h          |  124 ++
 drivers/md/dm-cache-policy-mq.c                | 1195 +++++++++++
 drivers/md/dm-cache-policy.c                   |  161 ++
 drivers/md/dm-cache-policy.h                   |  228 +++
 drivers/md/dm-cache-target.c                   | 2584 ++++++++++++++++++++++++
 drivers/md/dm-crypt.c                          |   45 +-
 drivers/md/dm-delay.c                          |   12 +-
 drivers/md/dm-flakey.c                         |   11 +-
 drivers/md/dm-ioctl.c                          |  166 +-
 drivers/md/dm-kcopyd.c                         |  121 +-
 drivers/md/dm-linear.c                         |   13 +-
 drivers/md/dm-mpath.c                          |   12 +-
 drivers/md/dm-raid.c                           |   10 +-
 drivers/md/dm-raid1.c                          |   17 +-
 drivers/md/dm-snap.c                           |   33 +-
 drivers/md/dm-stripe.c                         |   27 +-
 drivers/md/dm-table.c                          |   11 +-
 drivers/md/dm-target.c                         |    2 +-
 drivers/md/dm-thin-metadata.c                  |   12 +-
 drivers/md/dm-thin.c                           |  277 ++-
 drivers/md/dm-verity.c                         |    8 +-
 drivers/md/dm-zero.c                           |    2 +-
 drivers/md/dm.c                                |  452 +++--
 drivers/md/persistent-data/Kconfig             |    2 +-
 drivers/md/persistent-data/Makefile            |    2 +
 drivers/md/persistent-data/dm-array.c          |  808 ++++++++
 drivers/md/persistent-data/dm-array.h          |  166 ++
 drivers/md/persistent-data/dm-bitset.c         |  163 ++
 drivers/md/persistent-data/dm-bitset.h         |  165 ++
 drivers/md/persistent-data/dm-block-manager.c  |    1 +
 drivers/md/persistent-data/dm-btree-internal.h |    1 +
 drivers/md/persistent-data/dm-btree-spine.c    |    7 +
 drivers/md/persistent-data/dm-btree.c          |   52 +
 drivers/md/persistent-data/dm-btree.h          |   15 +-
 include/linux/device-mapper.h                  |   49 +-
 include/linux/dm-kcopyd.h                      |   25 +-
 include/uapi/linux/dm-ioctl.h                  |   11 +-
 48 files changed, 8791 insertions(+), 601 deletions(-)
 create mode 100644 Documentation/device-mapper/cache-policies.txt
 create mode 100644 Documentation/device-mapper/cache.txt
 create mode 100644 drivers/md/dm-cache-block-types.h
 create mode 100644 drivers/md/dm-cache-metadata.c
 create mode 100644 drivers/md/dm-cache-metadata.h
 create mode 100644 drivers/md/dm-cache-policy-cleaner.c
 create mode 100644 drivers/md/dm-cache-policy-internal.h
 create mode 100644 drivers/md/dm-cache-policy-mq.c
 create mode 100644 drivers/md/dm-cache-policy.c
 create mode 100644 drivers/md/dm-cache-policy.h
 create mode 100644 drivers/md/dm-cache-target.c
 create mode 100644 drivers/md/persistent-data/dm-array.c
 create mode 100644 drivers/md/persistent-data/dm-array.h
 create mode 100644 drivers/md/persistent-data/dm-bitset.c
 create mode 100644 drivers/md/persistent-data/dm-bitset.h

