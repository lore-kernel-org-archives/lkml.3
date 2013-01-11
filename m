Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980Ab3AKWI7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 17:08:59 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:36787 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755937Ab3AKWIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 17:08:42 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        Laurent Navet <laurent_navet@yahoo.com>,
        Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 5/6] staging: line6: drop ToneportSourceInfo CamelCase name
Date: Fri, 11 Jan 2013 23:08:13 +0100
Message-Id: <1357942094-11495-6-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1357942094-11495-1-git-send-email-stefanha@gmail.com>
References: <1357942094-11495-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following checkpatch.pl warning:

  WARNING: Avoid CamelCase: <ToneportSourceInfo>
  #5383: FILE: staging/line6/toneport.c:90:
  +struct ToneportSourceInfo {

Since the struct is only used to define the global
toneport_source_info[] table, I have chosen to make the struct
anonymous and part of the table definition.

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/toneport.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/line6/toneport.c b/drivers/staging/line6/toneport.c
index a529dd3..2f44d56 100644
--- a/drivers/staging/line6/toneport.c
+++ b/drivers/staging/line6/toneport.c
@@ -87,12 +87,10 @@ static struct line6_pcm_properties toneport_pcm_properties = {
 static int led_red = 0x00;
 static int led_green = 0x26;
 
-struct ToneportSourceInfo {
+static const struct {
 	const char *name;
 	int code;
-};
-
-static const struct ToneportSourceInfo toneport_source_info[] = {
+} toneport_source_info[] = {
 	{"Microphone", 0x0a01},
 	{"Line", 0x0801},
 	{"Instrument", 0x0b01},
-- 
1.8.0.2

