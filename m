Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110AbaGVPtv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 11:49:51 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:60370 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755830AbaGVPtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 11:49:49 -0400
Message-ID: <53CE881B.3070402@adfin.com>
Date: Tue, 22 Jul 2014 11:49:47 -0400
From: Milosz Tanski <milosz@adfin.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: linux-cachefs@redhat.com
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David Howells" <dhowells@redhat.com>, "NeilBrown" <neilb@suse.de>,
        "Shantanu Goel" <sgoel01@yahoo.com>
Subject: [PATCH 0/3] FS-Cache: Bug fixes for bugs that happen under vma pressure
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FS-Cache has a few bugs generally only get tried in error mode / under
VMA preassure. The problem is exhasterbated when majority of the IO is
cacheable netfs IO. At that point there are few pages that are evictalbe
due to GPF_NOFS allocation strategies. 

The first bug is a recursive hang caused by fscache write out to ext4
which in turn needs to allocate pages and ends up calling releasepages()
on the netfs.

The second two bugs are cookie ref count bugs that happen when in the
error cases (mostly from related memory alloc failures).

Milosz Tanski (3):
  FS-Cache: Timeout for releasepage()
  FS-Cache: Reduce cookie ref count if submit fails.
  FS-Cache: refcount becomes corrupt under vma pressure.

 fs/fscache/object.c |    4 ++++
 fs/fscache/page.c   |   22 ++++++++++++++++++----
 2 files changed, 22 insertions(+), 4 deletions(-)

-- 
1.7.9.5

