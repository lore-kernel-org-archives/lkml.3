Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbaHMQ6K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 12:58:10 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:52909 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbaHMQ6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 12:58:08 -0400
Message-ID: <53EB991F.3070302@adfin.com>
Date: Wed, 13 Aug 2014 12:58:07 -0400
From: Milosz Tanski <milosz@adfin.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: linux-cachefs@redhat.com
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, NeilBrown <neilb@suse.de>
Subject: [PATCH 0/3] FS-Cache: Bug fixes for bugs that happen under vma pressure
 v2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FS-Cache has a few bugs generally only get tried in error mode / under
VMA preassure. The problem is exacerbated when majority of the IO is
cacheable netfs IO. At that point there are few pages that are evictable
due to GPF_NOFS allocation strategies.

The first bug is a recursive hang caused by fscache write out to ext4
which in turn needs to allocate pages and ends up calling releasepages()
on the netfs.

The second two bugs are cookie ref count bugs that happen when in the
error cases (mostly from related memory alloc failures).

This is the second try at this with Sign-Off lines, suggestions from
David and debug log on time out. With the log line we can further
investigate how often this happens and be smarter with the timeout (if
need be).

Milosz Tanski (3):
  FS-Cache: Timeout for releasepage()
  FS-Cache: Reduce cookie ref count if submit fails.
  FS-Cache: refcount becomes corrupt under vma pressure.

 fs/fscache/object.c |    2 ++
 fs/fscache/page.c   |   26 ++++++++++++++++++++++----
 2 files changed, 24 insertions(+), 4 deletions(-)

-- 
1.7.9.5

