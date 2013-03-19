Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562Ab3CSUFX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 16:05:23 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:33364 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757207Ab3CSUFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 16:05:19 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>, David Howells <dhowells@redhat.com>
Cc: Jiri Slaby <jslaby@suse.cz>, Sasha Levin <levinsasha928@gmail.com>,
        Dave Jones <davej@redhat.com>, Michel Lespinasse <walken@google.com>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 0/7] ldsem patchset
Date: Tue, 19 Mar 2013 15:26:02 -0400
Message-Id: <1363721169-22445-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
References: <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo and David,

Greg has asked me to get your acks on the r/w semaphore implementation
in the first patch,
  'tty: Add timed, writer-prioritized rw_semaphore'

Would you please review the implementation and comment?


This is a re-spin of the remainder of 'ldisc patchset'.
The semaphore-related patches of that set have been squashed into the
first patch.


Sasha and Dave,

Please don't run the 44-patch ldisc patchset anymore. That patchset
was only partially applied so trinity testing for linux-next may
give false assurance that those bugs are fixed.


Peter Hurley (7):
  tty: Add timed, writer-prioritized rw semaphore
  tty: Add lock/unlock ldisc pair functions
  tty: Replace ldisc locking with ldisc_sem
  tty: Clarify ldisc variable
  tty: Fix hangup race with TIOCSETD ioctl
  tty: Clarify multiple-references comment in TIOCSETD ioctl
  tty: Fix tty_ldisc_lock name collision

 drivers/tty/Makefile      |   2 +-
 drivers/tty/tty_buffer.c  |   2 +-
 drivers/tty/tty_io.c      |   7 +-
 drivers/tty/tty_ldisc.c   | 447 +++++++++++++++------------------------------
 drivers/tty/tty_ldsem.c   | 453 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/tty.h       |   4 +-
 include/linux/tty_ldisc.h |  49 ++++-
 7 files changed, 653 insertions(+), 311 deletions(-)
 create mode 100644 drivers/tty/tty_ldsem.c

-- 
1.8.1.2

