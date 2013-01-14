Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116Ab3ANUuK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 15:50:10 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:44925 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756944Ab3ANUuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 15:50:09 -0500
Date: Mon, 14 Jan 2013 15:50:01 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: [GIT PULL] (xen) stable/for-jens-3.8 - bug-fixes.
Message-ID: <20130114205001.GA6879@phenom.dumpdata.com>
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

which has a couple of fixes that should have been pulled some time ago (my mistake
on not posting this earlier). There is one serious fix in there from Roger
which allows the blkback to handle bio's with partial data. Without that patch
the LVM operations on guests can fail (and often do). Please pull!

Thanks!

 drivers/block/xen-blkback/blkback.c | 18 ++++++++------
 drivers/block/xen-blkback/xenbus.c  | 49 ++++++++++++++++++-------------------
 drivers/block/xen-blkfront.c        | 10 +++++---
 include/linux/llist.h               | 25 +++++++++++++++++++
 4 files changed, 66 insertions(+), 36 deletions(-)

Jan Beulich (1):
      xen-blkback: do not leak mode property

Roger Pau Monne (3):
      xen-blkback: implement safe iterator for the list of persistent grants
      llist/xen-blkfront: implement safe version of llist_for_each_entry
      xen-blkfront: handle bvecs with partial data

