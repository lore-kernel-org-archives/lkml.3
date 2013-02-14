Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935104Ab3BNX0i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 18:26:38 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:35665 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935068Ab3BNX0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 18:26:37 -0500
Date: Thu, 14 Feb 2013 18:26:30 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: [GIT PULL] (xen) stable/for-jens-3.8
Message-ID: <20130214232630.GA8440@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Jens,

Please git pull the following branch:

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-jens-3.8

which has fixes to the blkback that I hope you can push to Linus for 3.8.
The one that is quite vicious is the "xen-blkfront: drop the use of
llist_for_each_entry_safe". It is a fix to re-do an "free-ing" loop - otherwise
we hit a GCC 4.1.1 bug (so RHEL5 based) that turns the loop in an unbound one.

Please pull!

 drivers/block/xen-blkback/blkback.c |  1 -
 drivers/block/xen-blkback/xenbus.c  | 49 ++++++++++++++++++-------------------
 drivers/block/xen-blkfront.c        | 13 +++++++---
 include/linux/llist.h               | 25 -------------------
 4 files changed, 34 insertions(+), 54 deletions(-)

Jan Beulich (1):
      xen-blkback: do not leak mode property

Konrad Rzeszutek Wilk (2):
      xen/blkback: Don't trust the handle from the frontend.
      xen-blkfront: drop the use of llist_for_each_entry_safe

