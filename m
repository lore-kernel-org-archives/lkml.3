Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbaHVLTY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 07:19:24 -0400
Received: from mail-wi0-f195.google.com ([209.85.212.195]:46349 "EHLO
	mail-wi0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbaHVLTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 07:19:22 -0400
From: Arianna Avanzini <avanzini.arianna@gmail.com>
To: konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org
Cc: bob.liu@oracle.com, felipe.franciosi@citrix.com, axboe@fb.com,
        avanzini.arianna@gmail.com
Subject: [PATCH RFC 0/4] Multi-queue support for xen-blkfront and xen-blkback
Date: Fri, 22 Aug 2014 13:20:00 +0200
Message-Id: <1408706404-6614-1-git-send-email-avanzini.arianna@gmail.com>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

this patchset adds to the Xen PV block driver support to exploit the multi-
queue block layer API by sharing and using multiple I/O rings in the frontend
and backend. It is the result of my internship for GNOME's Outreach Program
for Women ([1]), in which I was mentored by Konrad Rzeszutek Wilk.

The patchset implements in the backend driver the retrieval of information
about the currently-in-use block layer API for a certain device and about
the number of available submission queues, if the API turns out to be the
multi-queue one. The information is then advertised to the frontend driver
via XenStore. The frontend device can exploit such an information to allocate
and grant multiple I/O rings that the backend will be able to map.
The patchset has been tested with fio's IOmeter emulation on a four-cores
machine with a null_blk device (some results are available here: [2]).

This patch series is just an RFC prototype. Any comments or suggestions are
more than welcome.
Thank you,
Arianna

[1] http://goo.gl/bcvHMh
[2] http://goo.gl/O8RlLL

Arianna Avanzini (4):
  xen, blkfront: add support for the multi-queue block layer API
  xen, blkfront: factor out flush-related checks from do_blkif_request()
  xen, blkfront: introduce support for multiple hw queues
  xen, blkback: add support for multiple block rings

 drivers/block/xen-blkback/blkback.c | 376 ++++++++-------
 drivers/block/xen-blkback/common.h  | 111 +++--
 drivers/block/xen-blkback/xenbus.c  | 475 ++++++++++++-------
 drivers/block/xen-blkfront.c        | 886 +++++++++++++++++++++++-------------
 4 files changed, 1151 insertions(+), 697 deletions(-)

-- 
2.0.4

