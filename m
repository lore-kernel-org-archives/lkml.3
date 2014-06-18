Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbaFRWlE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 18:41:04 -0400
Received: from 1wt.eu ([62.212.114.60]:43441 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754786AbaFRWlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 18:41:01 -0400
Date: Thu, 19 Jun 2014 00:40:59 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Linux 2.6.32.63
Message-ID: <20140618224059.GA7101@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've just released Linux 2.6.32.63.

The patch and changelog will appear soon at the following locations:
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.32/
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.32/patch-2.6.32.63.bz2
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.32/patch-2.6.32.63.xz
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.32/patch-2.6.32.63.gz
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.32/ChangeLog-2.6.32.63

The updated 2.6.32.y git tree can be found at:
   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-2.6.32.y
  http://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-2.6.32.y

The tree can be browsed on the gitweb interface:
  http://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/log/?id=refs/heads/linux-2.6.32.y

Testing status (build/boot, OK/FAIL, otherwise not tested) :

         ARCH  |         CONFIGURATION
       --------+-----------------------------------
               |  allmodconfig     other-config
        x86_64 |    build:OK            -
          i386 |    build:OK            -

Thanks to all reviewers, and to Greg for the final packaging.
Willy

---------
 Makefile                   |   2 +-
 include/linux/ethtool.h    |   4 +-
 kernel/auditsc.c           |  25 +++--
 kernel/futex.c             | 243 +++++++++++++++++++++++++++++++++++----------
 net/core/ethtool.c         |  17 +++-
 net/core/sysctl_net_core.c |   3 +-
 net/ipv4/sysctl_net_ipv4.c |   3 +-
 7 files changed, 229 insertions(+), 68 deletions(-)

Summary of changes from 2.6.32.62 to 2.6.32.63
==============================================
Andy Lutomirski (1):
      auditsc: audit_krule mask accesses need bounds checking

Ben Hutchings (1):
      ethtool: Report link-down while interface is down

Thomas Gleixner (6):
      futex: Add another early deadlock detection check
      futex: Prevent attaching to kernel threads
      futex-prevent-requeue-pi-on-same-futex.patch futex: Forbid uaddr == uaddr2 in futex_requeue(..., requeue_pi=1)
      futex: Validate atomic acquisition in futex_lock_pi_atomic()
      futex: Always cleanup owner tid in unlock_pi
      futex: Make lookup_pi_state more robust

Willy Tarreau (2):
      net: fix regression introduced in 2.6.32.62 by sysctl fixes
      Linux 2.6.32.63

