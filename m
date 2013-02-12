Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761357Ab3BLQGX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 11:06:23 -0500
Received: from mail-vb0-f51.google.com ([209.85.212.51]:54656 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760313Ab3BLQGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 11:06:22 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: nbd-general@lists.sf.net, Paul Clements <Paul.Clements@steeleye.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/3] NBD fixes for caching and block device flags
Date: Tue, 12 Feb 2013 17:06:08 +0100
Message-Id: <1360685171-3792-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first two patches improve the behavior of NBD with respect to the host
cache---respectively the server's cache and the client's.  The first adds
support for flushing the backing storage, so that NBD is safe against
power losses.  The second properly syncs and cleans the client's page
cache when an NBD device is disconnected from the server.

The third reports read-only devices properly in sysfs.

Ok for 3.9?  I saw the last NBD patches were applied by Andrew Morton,
so I'm CCing him; Paul, please ack them if they are okay.

Paolo

Alex Bligh (1):
  nbd: support FLUSH requests

Paolo Bonzini (2):
  nbd: fsync and kill block device on shutdown
  nbd: show read-only state in sysfs

 drivers/block/nbd.c      |   35 +++++++++++++++++++++++++++++++++--
 include/uapi/linux/nbd.h |    3 ++-
 2 files changed, 35 insertions(+), 3 deletions(-)

