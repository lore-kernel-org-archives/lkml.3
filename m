Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622Ab3H3K0v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 06:26:51 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:52617 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882Ab3H3K0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 06:26:49 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-69-5220736716b8
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Len Brown <lenb@kernel.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] intel_idle: mark states tables with __initdata tag
Date: Fri, 30 Aug 2013 12:26:42 +0200
Message-id: <3627555.yC4BdJJnVe@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t9jAd2MYoUgg51XWSzmfZa12PnwLZvF
	5V1z2Cw+9x5htOhf2MvkwOqxaVUnm8eda3vYPB4tbmH0+LxJLoAlissmJTUnsyy1SN8ugSvj
	08TVbAWf+SoebGplamD8zN3FyMkhIWAi8W7tEUYIW0ziwr31bF2MXBxCAosYJX6uu84C4bQw
	Scx+94gFpIpNwEpiYvsqsA4RAXmJTTs7wYqYBXoZJY7OuswMkhAWcJfoON3NCmKzCKhKbGz5
	yw5i8wpoStyYexAsLirgKfFp0lJmiLigxI/J98AWMAMN3bd/KiuErSWxfudxpgmMfLOQlM1C
	UjYLSdkCRuZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMGB+UxqB+PKBotDjAIcjEo8vA+C
	5YOEWBPLiitzDzFKcDArifBWpCoECfGmJFZWpRblxxeV5qQWH2KU5mBREuc90GodKCSQnliS
	mp2aWpBaBJNl4uCUamCMMzLa2F6T+FIrUe+RgFCL6pZj5pxaxxOeMZVVnbdr2htgma+xyfy8
	98Tbdo8PLGnPcs9cbyxQKGV5KSl57mYlsUt9qg8e7T/1a/cBh922RVJ2nVP2vZStiwpxOiHw
	db2H1NrAjV/6EsXd28Lyl/yOSlynsni+iNOiB39KBBbU5t3pe3iz9JQSS3FGoqEWc1FxIgAG
	OzumSAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

States tables are only accessed during driver initialization so they
can be marked with __initdata tag.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Len Brown <lenb@kernel.org>
---
 drivers/idle/intel_idle.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 9c97fbb42..53b24f1 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -123,7 +123,7 @@ static struct cpuidle_state *cpuidle_state_table;
  * which is also the index into the MWAIT hint array.
  * Thus C0 is a dummy.
  */
-static struct cpuidle_state nehalem_cstates[] = {
+static struct cpuidle_state nehalem_cstates[] __initdata = {
 	{
 		.name = "C1-NHM",
 		.desc = "MWAIT 0x00",
@@ -156,7 +156,7 @@ static struct cpuidle_state nehalem_cstates[] = {
 		.enter = NULL }
 };
 
-static struct cpuidle_state snb_cstates[] = {
+static struct cpuidle_state snb_cstates[] __initdata = {
 	{
 		.name = "C1-SNB",
 		.desc = "MWAIT 0x00",
@@ -196,7 +196,7 @@ static struct cpuidle_state snb_cstates[] = {
 		.enter = NULL }
 };
 
-static struct cpuidle_state ivb_cstates[] = {
+static struct cpuidle_state ivb_cstates[] __initdata = {
 	{
 		.name = "C1-IVB",
 		.desc = "MWAIT 0x00",
@@ -236,7 +236,7 @@ static struct cpuidle_state ivb_cstates[] = {
 		.enter = NULL }
 };
 
-static struct cpuidle_state hsw_cstates[] = {
+static struct cpuidle_state hsw_cstates[] __initdata = {
 	{
 		.name = "C1-HSW",
 		.desc = "MWAIT 0x00",
@@ -297,7 +297,7 @@ static struct cpuidle_state hsw_cstates[] = {
 		.enter = NULL }
 };
 
-static struct cpuidle_state atom_cstates[] = {
+static struct cpuidle_state atom_cstates[] __initdata = {
 	{
 		.name = "C1E-ATM",
 		.desc = "MWAIT 0x00",
-- 
1.8.2.3


