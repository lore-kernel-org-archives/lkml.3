Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932738AbaICKKc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 06:10:32 -0400
Received: from relay.parallels.com ([195.214.232.42]:53869 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932725AbaICKK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 06:10:28 -0400
Subject: [PATCH 0/2] fuse: fix regression in fuse_get_user_pages()
To: viro@zeniv.linux.org.uk
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: miklos@szeredi.hu, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, werner.baumann@onlinehome.de
Date: Wed, 03 Sep 2014 14:10:23 +0400
Message-ID: <20140903100826.23218.95122.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The patchset fixes a regression introduced by the following commits:

c7f3888ad7f0 ("switch iov_iter_get_pages() to passing maximal number of pages")
c9c37e2e6378 ("fuse: switch to iov_iter_get_pages()")

The regression manifests itslef like this (thanks to Werner Baumann for reporting):

> davfs2 uses the fuse kernel module directly (not using the fuse
> userspace library). A user of davfs2 reported this problem
> (http://savannah.nongnu.org/support/?108640):
> 
> dd if=/dev/zero of=/mnt/owncloud/test.txt bs=20416 count=1
> works fine, but
> dd if=/dev/zero of=/mnt/owncloud/test.txt bs=20417 count=1
> fails.

Thanks,
Maxim

---

Maxim Patlasov (2):
      vfs: switch iov_iter_get_pages() to passing maximal size
      fuse: fuse_get_user_pages(): do not pack more data than requested


 fs/direct-io.c      |    2 +-
 fs/fuse/file.c      |   13 +++++++++----
 include/linux/uio.h |    2 +-
 mm/iov_iter.c       |   17 +++++++++--------
 4 files changed, 20 insertions(+), 14 deletions(-)

-- 
Signature
