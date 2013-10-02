Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab3JBRh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 13:37:59 -0400
Received: from relay.parallels.com ([195.214.232.42]:39767 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481Ab3JBRh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 13:37:58 -0400
Subject: [PATCH 0/4] fuse: fixes for fuse_writepage_in_flight() and friends
 -v2
To: miklos@szeredi.hu
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 02 Oct 2013 21:37:56 +0400
Message-ID: <20131002173701.31188.33547.stgit@dhcp-10-30-17-2.sw.ru>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos,

This version implements your suggestion about cropping secondary requests
in fuse_send_writepage().

> The patch-set fixes a few issues I found while reviewing your
> recent "fixes for writepages" patch-set.
>
> The patches are for writepages.v2. If they are OK, I'll re-check
> them for for-next.

Thanks,
Maxim

---

Maxim Patlasov (4):
      fuse: writepages: roll back changes if request not found
      fuse: writepages: crop secondary requests
      fuse: writepage: update bdi writeout when deleting secondary request
      fuse: writepages: protect secondary requests from fuse file release


 fs/fuse/file.c |   64 +++++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 51 insertions(+), 13 deletions(-)

-- 
Signature
