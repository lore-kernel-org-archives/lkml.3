Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945Ab3C0G4q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 02:56:46 -0400
Received: from intranet.asianux.com ([58.214.24.6]:4218 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842Ab3C0G4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 02:56:45 -0400
X-Spam-Score: -100.7
Message-ID: <5152980D.8090903@asianux.com>
Date: Wed, 27 Mar 2013 14:56:13 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: drbd-dev@lists.linbit.com
CC: drbd-user@lists.linbit.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/block/drbd: remove erroneous semicolon
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  need remove it, or always return -EBUSY.
  it is found by compiler with 'EXTRA_CFLAG=-W'.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 drivers/block/drbd/drbd_actlog.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index 6afe173..6608076 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -389,7 +389,7 @@ int drbd_al_begin_io_nonblock(struct drbd_conf *mdev, struct drbd_interval *i)
 		if (unlikely(tmp != NULL)) {
 			struct bm_extent  *bm_ext = lc_entry(tmp, struct bm_extent, lce);
 			if (test_bit(BME_NO_WRITES, &bm_ext->flags)) {
-				if (!test_and_set_bit(BME_PRIORITY, &bm_ext->flags));
+				if (!test_and_set_bit(BME_PRIORITY, &bm_ext->flags))
 					return -EBUSY;
 				return -EWOULDBLOCK;
 			}
-- 
1.7.7.6
