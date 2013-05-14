Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758485Ab3ENUv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 16:51:27 -0400
Received: from cobra.newdream.net ([66.33.216.30]:35804 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757626Ab3ENUv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 16:51:26 -0400
Date: Tue, 14 May 2013 13:51:21 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: torvalds@linux-foundation.org
cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for -rc2
Message-ID: <alpine.DEB.2.00.1305141334510.9090@cobra.newdream.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following patches from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

Yes, this is a much larger pull than I would like after -rc1.  There are a 
few things included:

 - a few fixes for leaks and incorrect assertions
 - a few patches fixing behavior when mapped images are resized
 - handling for cloned/layered images that are flattened out from 
   underneath the client

The last bit was non-trivial, and there is some code movement and 
associated cleanup mixed in.  This was ready and was meant to go in last 
week but I missed the boat on Friday.  My only excuse is that I was 
waiting for an all clear from the testing and there were many other shiny 
things to distract me.

Strictly speaking, handling the flatten case isn't a regression and could 
wait, so if you like we can try to pull the series apart, but Alex and I 
would much prefer to have it all in as it is a case real users will hit 
with 3.10.

Thanks!
sage


----------------------------------------------------------------
Alex Elder (33):
      rbd: fix leak of format 2 snapshot context
      rbd: revalidate only for mapping size changes
      rbd: update capacity in rbd_dev_refresh()
      rbd: kill rbd_update_mapping_size()
      rbd: don't print warning if not mapping a parent
      rbd: don't look up snapshot id in rbd_dev_mapping_set()
      rbd: kill rbd_dev_clear_mapping()
      rbd: always set read-only flag in rbd_add()
      rbd: set the mapping size and features later
      rbd: zero format 1 header structure earlier
      rbd: refactor rbd_header_from_disk()
      rbd: update in-core header directly
      rbd: simplify rbd_dev_v1_probe()
      rbd: get rid of trivial v1 header wrappers
      rbd: define rbd_dev_v2_header_info()
      rbd: fix an incorrect assertion condition
      rbd: support reading parent page data
      rbd: set mapping read-only flag in rbd_add()
      rbd: only set up watch for mapped images
      rbd: kill rbd_img_request_get()
      libceph: init sent and completed when starting
      rbd: fix parent request size assumption
      rbd: support reading parent page data for writes
      rbd: ignore zero-overlap parent
      rbd: get parent info on refresh
      rbd: don't release write request until necessary
      rbd: define rbd_dev_unparent()
      rbd: define parent image request routines
      rbd: reference count parent requests
      rbd: detect when clone image is flattened
      rbd: re-submit read request for flattened clone
      rbd: re-submit write request for flattened clone
      rbd: re-submit flattened write request (part 2)

 drivers/block/rbd.c   | 935 +++++++++++++++++++++++++++++---------------------
 net/ceph/osd_client.c |   5 +-
 2 files changed, 553 insertions(+), 387 deletions(-)
