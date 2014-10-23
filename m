Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516AbaJWMvf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 08:51:35 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:63717 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932411AbaJWMvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 08:51:33 -0400
X-Original-SENDERIP: 165.186.175.39
X-Original-MAILFROM: gioh.kim@lge.com
From: Gioh Kim <gioh.kim@lge.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Rebecca Schultz Zavin <rebecca@android.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        gunho.lee@lge.com, gioh.kim@lge.com
Subject: [RFC 0/2] enable pool shrinking in page unit
Date: Thu, 23 Oct 2014 21:52:18 +0900
Message-Id: <1414068740-9553-1-git-send-email-gioh.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Current shrinking is not page unit, block unit.
But shrinker returns the pools size with page unit.
So it is confused.

And there is no ways to shrink at any moment and any amount.

I have 2 patches:

1. Patch 1/2: make pool be shrinked by page unit
This patch trys to shrink pool in page unit.

2. Patch 2/2: enable debugfs to shrink pool directly
This patch enable debugfs to specify shrink amount.

Thanks for any feedback.

This patchset is based on linux-next-20141023.

Gioh Kim (2):
  staging: ion: shrink page-pool by page unit
  staging: ion: debugfs to shrink pool

 drivers/staging/android/ion/ion.c             |   31 +++++++------------------
 drivers/staging/android/ion/ion_page_pool.c   |    5 ++--
 drivers/staging/android/ion/ion_system_heap.c |    7 ++++--
 3 files changed, 16 insertions(+), 27 deletions(-)

-- 
1.7.9.5

