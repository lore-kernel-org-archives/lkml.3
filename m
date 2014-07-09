Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273AbaGITSi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 15:18:38 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:52708 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223AbaGITSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 15:18:35 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH] Fix DRBD regression
Date: Wed,  9 Jul 2014 21:18:31 +0200
Message-Id: <1404933512-5166-1-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

In 3.13 the commit 786235eeb 'kthread: make kthread_create() killable'
broke DRBD's fence peer mechanism in a subtle way. Since only a part
of our user base has fencing properly configured this regression was
unnoticed until now. Please consider to submit this for 3.16-rc5.

Thanks,
 Phil

Lars Ellenberg (1):
  drbd: fix regression 'out of mem, failed to invoke fence-peer helper'

 drivers/block/drbd/drbd_nl.c | 6 ++++++
 1 file changed, 6 insertions(+)

-- 
1.9.1

