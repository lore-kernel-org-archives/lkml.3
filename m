Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab3CKKbB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 06:31:01 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:51412 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753212Ab3CKKbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 06:31:00 -0400
Message-ID: <1362997664.3137.52.camel@x61.thuisdomein>
Subject: Re: [PATCH] md/raid456: remove depends on CONFIG_EXPERIMENTAL
From: Paul Bolle <pebolle@tiscali.nl>
To: NeilBrown <neilb@suse.de>
Cc: Chris Metcalf <cmetcalf@tilera.com>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dan Williams <djbw@fb.com>,
        Kees Cook <keescook@chromium.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Alasdair G Kergon <agk@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Mon, 11 Mar 2013 11:27:44 +0100
In-Reply-To: <20130228091110.7da87b53@notabene.brown>
References: <20130223074001.GA5199@www.outflux.net>
	 <CAA9_cmfa1hhijh4g_hSwMy_GR81rxjEFMurJwSvhBruh1R5dtw@mail.gmail.com>
	 <20130228091110.7da87b53@notabene.brown>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Mar 2013 10:27:44.0465 (UTC) FILETIME=[11720410:01CE1E43]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Following will be in -next shortly.
> 
> NeilBrown
> 
> 
> From 51acbcec6c42b24482bac18e42befc822524535d Mon Sep 17 00:00:00 2001
> From: NeilBrown <neilb@suse.de>
> Date: Thu, 28 Feb 2013 09:08:34 +1100
> Subject: [PATCH] md: remove CONFIG_MULTICORE_RAID456
> 
> This doesn't seem to actually help and we have an alternate
> multi-threading approach waiting in the wings, so just get
> rid of this config option and associated code.
> 
> As a bonus, we remove one use of CONFIG_EXPERIMENTAL
> 
> Cc: Dan Williams <djbw@fb.com>
> Cc: Kees Cook <keescook@chromium.org>
> Signed-off-by: NeilBrown <neilb@suse.de>

That commit entered mainline in v3.9-rc2 (still as commit
51acbcec6c42b24482bac18e42befc822524535d). It missed one instance of
CONFIG_MULTICORE_RAID456, so this additional patch is needed (which also
cleans that macro from two defconfig files). Compile tested, by the way.


Paul Bolle

>From ab10e19eeca5ae271ae965418ff736db0230aab6 Mon Sep 17 00:00:00 2001
From: Paul Bolle <pebolle@tiscali.nl>
Date: Mon, 11 Mar 2013 11:16:25 +0100
Subject: [PATCH] md: remove CONFIG_MULTICORE_RAID456 entirely

Once instance of this Kconfig macro remained after commit
51acbcec6c42b24482bac18e42befc822524535d ("md: remove
CONFIG_MULTICORE_RAID456"). Remove that one too. And, while we're at it,
also remove it from the defconfig files that carry it.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 arch/tile/configs/tilegx_defconfig  | 1 -
 arch/tile/configs/tilepro_defconfig | 1 -
 drivers/md/raid5.h                  | 4 ----
 3 files changed, 6 deletions(-)

diff --git a/arch/tile/configs/tilegx_defconfig b/arch/tile/configs/tilegx_defconfig
index 8c5eff6..4768481 100644
--- a/arch/tile/configs/tilegx_defconfig
+++ b/arch/tile/configs/tilegx_defconfig
@@ -330,7 +330,6 @@ CONFIG_MD_RAID0=m
 CONFIG_MD_RAID1=m
 CONFIG_MD_RAID10=m
 CONFIG_MD_RAID456=m
-CONFIG_MULTICORE_RAID456=y
 CONFIG_MD_FAULTY=m
 CONFIG_BLK_DEV_DM=m
 CONFIG_DM_DEBUG=y
diff --git a/arch/tile/configs/tilepro_defconfig b/arch/tile/configs/tilepro_defconfig
index e7a3dfc..dd2b8f0 100644
--- a/arch/tile/configs/tilepro_defconfig
+++ b/arch/tile/configs/tilepro_defconfig
@@ -324,7 +324,6 @@ CONFIG_MD_RAID0=m
 CONFIG_MD_RAID1=m
 CONFIG_MD_RAID10=m
 CONFIG_MD_RAID456=m
-CONFIG_MULTICORE_RAID456=y
 CONFIG_MD_FAULTY=m
 CONFIG_BLK_DEV_DM=m
 CONFIG_DM_DEBUG=y
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 18b2c4a..31e2ec1 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -221,10 +221,6 @@ struct stripe_head {
 	struct stripe_operations {
 		int 		     target, target2;
 		enum sum_check_flags zero_sum_result;
-		#ifdef CONFIG_MULTICORE_RAID456
-		unsigned long	     request;
-		wait_queue_head_t    wait_for_ops;
-		#endif
 	} ops;
 	struct r5dev {
 		/* rreq and rvec are used for the replacement device when
-- 
1.7.11.7


