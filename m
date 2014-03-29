Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbaC2RuT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 13:50:19 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:54952 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456AbaC2RuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 13:50:17 -0400
Date: Sat, 29 Mar 2014 23:20:42 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Anil Gurumurthy <agurumur@brocade.com>,
        Vijaya Mohan Guvva <vmohan@brocade.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 08/55] scsi: Mark function as static in bfa/bfa_port.c
Message-ID: <fbb295b42460bf3f3551b39713fd209dde6e810d.1396114897.git.rashika.kheria@gmail.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark functions as static in bfa/bfa_port.c because they are not used
outside this file.

This eliminates the following warning in bfa/bfa_port.c:
drivers/scsi/bfa/bfa_port.c:776:1: warning: no previous prototype for ‘bfa_cee_isr’ [-Wmissing-prototypes]
drivers/scsi/bfa/bfa_port.c:812:1: warning: no previous prototype for ‘bfa_cee_notify’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/bfa/bfa_port.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_port.c b/drivers/scsi/bfa/bfa_port.c
index 8ea7697..3928a05 100644
--- a/drivers/scsi/bfa/bfa_port.c
+++ b/drivers/scsi/bfa/bfa_port.c
@@ -772,7 +772,7 @@ bfa_cee_reset_stats(struct bfa_cee_s *cee,
  * @return void
  */
 
-void
+static void
 bfa_cee_isr(void *cbarg, struct bfi_mbmsg_s *m)
 {
 	union bfi_cee_i2h_msg_u *msg;
@@ -808,7 +808,7 @@ bfa_cee_isr(void *cbarg, struct bfi_mbmsg_s *m)
  * @return void
  */
 
-void
+static void
 bfa_cee_notify(void *arg, enum bfa_ioc_event_e event)
 {
 	struct bfa_cee_s *cee = (struct bfa_cee_s *) arg;
-- 
1.7.9.5

