Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933127Ab3ICXKa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 19:10:30 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:41364 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664Ab3ICXK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 19:10:28 -0400
Date: Tue, 3 Sep 2013 19:10:24 -0400
From: Milosz Tanski <milosz@adfin.com>
To: ceph-devel@vger.kernel.org
Cc: sage@inktank.com, zheng.z.yan@intel.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] fscache fixes for ceph
Message-ID: <cover.1378249347.git.milosz@adfin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On the whole the current iteration of FSCache on Ceph has been quite stable for
me. We've had it deployed on 4 clients running for a week in a row. I did run
into two small issues.

First one, I wasn't checking if the page was marked with private_2 before
asking FSCache to write to it. I've never seen this before and I only seen this
issue once.

The second issue is similar to what I was seeing before with pages marked
private_2 when we return them to the page cache. In this case the start_read()
in addr.c was returning the pages in the error path of the code. I have plugged
that issue. I only seen this one a handful of times across all clients.

As usual please apply the changes from repo located at:

  https://bitbucket.org/adfin/linux-fs.git branch: wip-ceph-fscache

Cheers,
- Milosz

Milosz Tanski (2):
  ceph: ceph_readpage_to_fscache didn't check if marked
  ceph: page still marked private_2

 fs/ceph/addr.c  |  1 +
 fs/ceph/cache.c |  3 +++
 fs/ceph/cache.h | 14 +++++++++++++-
 3 files changed, 17 insertions(+), 1 deletion(-)

-- 
1.8.1.2

