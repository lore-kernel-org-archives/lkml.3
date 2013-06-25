Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513Ab3FYX75 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 19:59:57 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:62290 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab3FYX7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 19:59:55 -0400
From: Chad Williamson <chad@dahc.us>
To: gregkh@linuxfoundation.org
Cc: puff65537@bansheeslibrary.com, viro@zeniv.linux.org.uk,
        tulinizer@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Chad Williamson <chad@dahc.us>
Subject: [PATCH v2 6/6] Staging: silicom: remove typedef for dev_desc_t
Date: Tue, 25 Jun 2013 18:59:24 -0500
Message-Id: <1372204764-16203-3-git-send-email-chad@dahc.us>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1372204764-16203-1-git-send-email-chad@dahc.us>
References: <1372204764-16203-1-git-send-email-chad@dahc.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the dev_desc_t typedef for the dev_desc struct in bpctl_mod.c,
resolving a checkpatch.pl warning. In fact, we can use an anonymous
struct, since it's only used in the single dev_desc array of device
descriptions, whose definition follows immediately.

Signed-off-by: Chad Williamson <chad@dahc.us>
---
v2: rebased onto latest master in linux-next
---
 drivers/staging/silicom/bpctl_mod.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/silicom/bpctl_mod.c b/drivers/staging/silicom/bpctl_mod.c
index 91c864c..32bc530 100644
--- a/drivers/staging/silicom/bpctl_mod.c
+++ b/drivers/staging/silicom/bpctl_mod.c
@@ -5981,11 +5981,9 @@ struct bpmod_info {
 
 };
 
-typedef struct _dev_desc {
+struct {
 	char *name;
-} dev_desc_t;
-
-dev_desc_t dev_desc[] = {
+} dev_desc[] = {
 	{"Silicom Bypass PXG2BPFI-SD series adapter"},
 	{"Silicom Bypass PXG2BPFIL-SD series adapter"},
 	{"Silicom Bypass PXG2BPFILX-SD series adapter"},
-- 
1.8.1.4

