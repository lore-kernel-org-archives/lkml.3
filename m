Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933050Ab3LDSNa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 13:13:30 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52475 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753945Ab3LDSN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 13:13:28 -0500
From: Serban Constantinescu <serban.constantinescu@arm.com>
To: gregkh@linuxfoundation.org, arve@android.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, john.stultz@linaro.org,
        ccross@android.com, Dave.Butcher@arm.com, irogers@google.com,
        romlem@android.com
Cc: Serban Constantinescu <serban.constantinescu@arm.com>
Subject: [PATCH v1 0/9] Android: Add Support for Binder Compat
Date: Wed,  4 Dec 2013 18:09:32 +0000
Message-Id: <1386180581-6710-1-git-send-email-serban.constantinescu@arm.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

The patches attached add support for 32bit userspace running on 64bit
kernels. This is the last series of patches needed for basic 32bit Android
bring-up on 64bit kernels.

The series is split into refactoring the binder driver and the addition
of the compat layer. Please note that the helper macros are extended
with compat handling by the last patch of the series.

The patches have been successfully tested on 32 and 64bit platforms.

Thanks for your help,
Best regards,
Serban Constantinescu

Serban Constantinescu (9):
  staging: android: binder: Move some of the logic into subfunction
  staging: android: binder: Add binder_copy_to_user()
  staging: android: binder: Add cmd == CMD_NAME handling
  staging: android: binder: Add align_helper() macro
  staging: android: binder: Add deref_helper() macro
  staging: android: binder: Add size_helper() macro
  staging: android: binder: Add copy_flat_binder_object()
  staging: android: binder: Add binder compat handling to binder.h
  staging: android: binder: Add binder compat layer

 drivers/staging/android/binder.c |  846 ++++++++++++++++++++++++++++----------
 drivers/staging/android/binder.h |  109 +++++
 2 files changed, 732 insertions(+), 223 deletions(-)

-- 
1.7.9.5

