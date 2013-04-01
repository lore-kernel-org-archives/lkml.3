Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759382Ab3DAXKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 19:10:40 -0400
Received: from ozlabs.org ([203.10.76.45]:36687 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757700Ab3DAXKj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 19:10:39 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: <torvalds@linux-foundation.org>, "LKML" <linux-kernel@vger.kernel.org>
Cc: Amit Shah <amit.shah@redhat.com>
Cc: Asias He <asias@redhat.com>
Cc: FuXiangChun <xfu@redhat.com>
Cc: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: Sjur =?utf-8?Q?Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [PULL] virtio fixes
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 02 Apr 2013 09:38:27 +1030
Message-ID: <871uat7st0.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit e84e7a56a3aa2963db506299e29a5f3f09377f9b:

  virtio: rng: disallow multiple device registrations, fixes crashes (2013-03-08 11:30:43 +1100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git tags/fixes-for-linus

for you to fetch changes up to 9ba5c80b1aea8648a3efe5f22dc1f7cacdfbeeb8:

  virtio: console: add locking around c_ovq operations (2013-03-30 14:25:46 +1030)

----------------------------------------------------------------
One reversion, a tiny leak fix, and a cc:stable locking fix, in two parts.

Thanks,
Rusty.

----------------------------------------------------------------
Amit Shah (2):
      virtio: console: rename cvq_lock to c_ivq_lock
      virtio: console: add locking around c_ovq operations

Satoru Takeuchi (1):
      hw_random: free rng_buffer at module exit

Sjur BrÃ¦ndeland (1):
      Revert "virtio_console: Initialize guest_connected=true for rproc_serial"

 drivers/char/hw_random/core.c |    9 +++++++++
 drivers/char/virtio_console.c |   44 ++++++++++++++++++++++++++++-------------
 2 files changed, 39 insertions(+), 14 deletions(-)
