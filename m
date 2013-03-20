Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933081Ab3CUN5C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 09:57:02 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:20948 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758278Ab3CUN5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 09:57:00 -0400
Date: Wed, 20 Mar 2013 17:27:53 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Subject: [GIT PULL] (xen) stable/for-jens-3.9
Message-ID: <20130320212753.GA15060@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Jens,

Please git pull the following branch:

 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-jens-3.9

which has a bunch of fixes. They vary from being able to deal with unknown
requests, overflow in statistics, compile warnings, bug in the error path,
removal of unnecessary logic. There is also one performance fix - which is
to allocate pages for requests when the driver loads - instead of doing it
per request.

That is it. Please pull!

 drivers/block/xen-blkback/blkback.c |  68 +++++++++-------
 drivers/block/xen-blkback/common.h  |  40 ++++++++--
 drivers/block/xen-blkback/xenbus.c  |  14 ++--
 drivers/block/xen-blkfront.c        | 154 +++++++++++++++++++++---------------
 include/xen/interface/io/blkif.h    |  10 +++
 5 files changed, 179 insertions(+), 107 deletions(-)

Chen Gang (1):
      xen/xen-blkback: preq.dev is used without initialized

David Vrabel (1):
      xen/blkback: correctly respond to unknown, non-native requests

Jan Beulich (1):
      xen-blkback: fix dispatch_rw_block_io() error path

Mihnea Dobrescu-Balaur (1):
      xen-blkfront: replace kmalloc and then memcpy with kmemdup

Roger Pau Monne (5):
      xen-blkback: fix foreach_grant_safe to handle empty lists
      xen-blkfront: switch from llist to list
      xen-blkback: don't store dev_bus_addr
      xen-blkfront: pre-allocate pages for requests
      xen-blkfront: remove frame list from blk_shadow

Zoltan Kiss (1):
      xen/blkback: Change statistics counter types to unsigned

