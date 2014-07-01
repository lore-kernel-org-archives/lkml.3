Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964828AbaGARIO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 13:08:14 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:53652 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932410AbaGARIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 13:08:11 -0400
From: Anton Protopopov <a.s.protopopov@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Anton Protopopov <a.s.protopopov@gmail.com>
Subject: [PATCH] staging: vt6655: fixed sparse warnings
Date: Tue,  1 Jul 2014 21:06:29 +0400
Message-Id: <1404234389-27077-1-git-send-email-a.s.protopopov@gmail.com>
X-Mailer: git-send-email 1.8.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit fixes a few sparse warnings for missing the 'static' keyword
in array definitions:
    drivers/staging//vt6655/rxtx.c:81:22: warning: symbol 'wTimeStampOff' was not declared. Should it be static?
    drivers/staging//vt6655/rxtx.c:86:22: warning: symbol 'wFB_Opt0' was not declared. Should it be static?
    drivers/staging//vt6655/rxtx.c:90:22: warning: symbol 'wFB_Opt1' was not declared. Should it be static?

Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
---
 drivers/staging/vt6655/rxtx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index 2219d71..60fe6db 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -78,16 +78,16 @@ static int msglevel = MSG_LEVEL_INFO;
 #define CRITICAL_PACKET_LEN      256    // if packet size < 256 -> in-direct send
                                         //    packet size >= 256 -> direct send
 
-const unsigned short wTimeStampOff[2][MAX_RATE] = {
+static const unsigned short wTimeStampOff[2][MAX_RATE] = {
 	{384, 288, 226, 209, 54, 43, 37, 31, 28, 25, 24, 23}, // Long Preamble
 	{384, 192, 130, 113, 54, 43, 37, 31, 28, 25, 24, 23}, // Short Preamble
 };
 
-const unsigned short wFB_Opt0[2][5] = {
+static const unsigned short wFB_Opt0[2][5] = {
 	{RATE_12M, RATE_18M, RATE_24M, RATE_36M, RATE_48M}, // fallback_rate0
 	{RATE_12M, RATE_12M, RATE_18M, RATE_24M, RATE_36M}, // fallback_rate1
 };
-const unsigned short wFB_Opt1[2][5] = {
+static const unsigned short wFB_Opt1[2][5] = {
 	{RATE_12M, RATE_18M, RATE_24M, RATE_24M, RATE_36M}, // fallback_rate0
 	{RATE_6M , RATE_6M,  RATE_12M, RATE_12M, RATE_18M}, // fallback_rate1
 };
-- 
1.8.3.4

