Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab3JBLAe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 07:00:34 -0400
Received: from relay.parallels.com ([195.214.232.42]:34192 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321Ab3JBLAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 07:00:33 -0400
Subject: [PATCH 0/5] fuse: fixes for fuse_writepage_in_flight() and friends
To: miklos@szeredi.hu
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 02 Oct 2013 15:00:31 +0400
Message-ID: <20131002105815.26932.46041.stgit@dhcp-10-30-17-2.sw.ru>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos,

The patch-set fixes a few issues I found while reviewing your
recent "fixes for writepages" patch-set.

The patches are for writepages.v2. If they are OK, I'll re-check
them for for-next.

Thanks,
Maxim

---

Maxim Patlasov (5):
      fuse: writepages: roll back changes if request not found
      fuse: writepages: crop secondary requests on send
      fuse: writepages: crop secondary requests on attach
      fuse: writepage: update bdi writeout when deleting secondary request
      fuse: writepages: protect secondary requests from fuse file release


 fs/fuse/file.c |   95 +++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 83 insertions(+), 12 deletions(-)

-- 
Signature
