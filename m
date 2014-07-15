Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030272AbaGOXi2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:38:28 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:49867 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933950AbaGOXiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:38:23 -0400
Message-ID: <53C5BB6C.3090006@codeaurora.org>
Date: Tue, 15 Jul 2014 16:38:20 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Georgi Djakov <gdjakov@mm-sol.com>
CC: mturquette@linaro.org, linux@arm.linux.org.uk, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v1] clk: qcom: Add APQ8084 Multimedia Clock Controller
 (MMCC) support
References: <1402591302-12100-1-git-send-email-gdjakov@mm-sol.com> <53C04ED9.6030508@codeaurora.org>
In-Reply-To: <53C04ED9.6030508@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/14 13:53, Stephen Boyd wrote:
> On 06/12/14 09:41, Georgi Djakov wrote:
>> Add support for the multimedia clock controller found on the APQ8084
>> based platforms. This will allow the multimedia device drivers to
>> control their clocks.
>>
>> Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
>> ---
> I started picking up the qcom clock patches from the list. I see that
> this one has a small problem though:
>
> drivers/clk/qcom/mmcc-apq8084.c:169:10: warning: Initializer entry
> defined twice
> drivers/clk/qcom/mmcc-apq8084.c:170:10:   also defined here
> drivers/clk/qcom/mmcc-apq8084.c:185:10: warning: Initializer entry
> defined twice
> drivers/clk/qcom/mmcc-apq8084.c:187:10:   also defined here
> drivers/clk/qcom/mmcc-apq8084.c:203:10: warning: Initializer entry
> defined twice
> drivers/clk/qcom/mmcc-apq8084.c:205:10:   also defined here
>

Ok I've squashed in this fix:

diff --git a/drivers/clk/qcom/mmcc-apq8084.c b/drivers/clk/qcom/mmcc-apq8084.c
index 9cc956a5e9c9..751eea376a2b 100644
--- a/drivers/clk/qcom/mmcc-apq8084.c
+++ b/drivers/clk/qcom/mmcc-apq8084.c
@@ -34,12 +34,12 @@
 #define P_HDMIPLL      2
 #define P_GPLL0                3
 #define P_EDPVCO       3
-#define P_MMPLL4       3
-#define P_GPLL1                4
+#define P_MMPLL4       4
 #define P_DSI0PLL      4
 #define P_DSI0PLL_BYTE 4
 #define P_MMPLL2       4
 #define P_MMPLL3       4
+#define P_GPLL1                5
 #define P_DSI1PLL      5
 #define P_DSI1PLL_BYTE 5
 #define P_MMSLEEP      6
@@ -166,8 +166,8 @@ static const u8 mmcc_xo_mmpll0_1_4_gpll0_map[] = {
        [P_XO]          = 0,
        [P_MMPLL0]      = 1,
        [P_MMPLL1]      = 2,
-       [P_MMPLL4]      = 3,
        [P_GPLL0]       = 5,
+       [P_MMPLL4]      = 3,
 };
 
 static const char *mmcc_xo_mmpll0_1_4_gpll0[] = {
@@ -183,8 +183,8 @@ static const u8 mmcc_xo_mmpll0_1_4_gpll1_0_map[] = {
        [P_MMPLL0]      = 1,
        [P_MMPLL1]      = 2,
        [P_MMPLL4]      = 3,
-       [P_GPLL1]       = 4,
        [P_GPLL0]       = 5,
+       [P_GPLL1]       = 4,
 };
 
 static const char *mmcc_xo_mmpll0_1_4_gpll1_0[] = {
@@ -201,8 +201,8 @@ static const u8 mmcc_xo_mmpll0_1_4_gpll1_0_sleep_map[] = {
        [P_MMPLL0]      = 1,
        [P_MMPLL1]      = 2,
        [P_MMPLL4]      = 3,
-       [P_GPLL1]       = 4,
        [P_GPLL0]       = 5,
+       [P_GPLL1]       = 4,
        [P_MMSLEEP]     = 6,
 };


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

