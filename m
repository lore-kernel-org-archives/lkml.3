Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab3H1QaZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 12:30:25 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:17928 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075Ab3H1QaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 12:30:19 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-b3-521e2599fce6
From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
To: kgene.kim@samsung.com
Cc: mturquette@linaro.org, tomasz.figa@gmail.com, yadi.brar@samsung.com,
        dianders@chromium.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ian.campbell@citrix.com, rob@landley.net,
        thomas.abraham@linaro.org, s.nawrocki@samsung.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux@arm.linux.org.uk, ben-linux@fluff.org,
        linux-samsung-soc@vger.kernel.org,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Subject: [RFC 1/3] clk: samsung: pll: Add support for PLL6545a and PLL6522x
Date: Wed, 28 Aug 2013 18:29:15 +0200
Message-id: <1377707357-4902-2-git-send-email-m.krawczuk@partner.samsung.com>
X-Mailer: git-send-email 1.8.1.2
In-reply-to: <1377707357-4902-1-git-send-email-m.krawczuk@partner.samsung.com>
References: <1377707357-4902-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFLMWRmVeSWpSXmKPExsVy+t9jQd2ZqnJBBvvvyFlMWneAyWL+kXOs
	FmeXHWSzeNPbwWLRu+Aqm8Wmx9dYLRa2LWGxuLxrDpvFjPP7mCxuX+a1OL3mFLPF0usXmSye
	TrjIZjFh+loWi3Uvp7NYHH7Tzmrx6mAbi8WxGUsYLVbt+sNoMWf6OyYHEY8189YwerQ097B5
	zG64yOLxevIERo+/q14we+ycdZfd49Xqmawed67tYfPYvKTe4+C7PUwefVtWMXp83iTnsXFu
	aABvFJdNSmpOZllqkb5dAlfGngsyBR/ZKza/38HSwHiBrYuRk0NCwERi44SLrBC2mMSFe+uB
	4lwcQgLTGSVOdp1hhnDamST2vtnJCFLFJmAuMfHZJhYQW0RAUqKp4Q9YEbNAB4vE0wMvwUYJ
	C3hLPFzwCqyIRUBV4t7Md2DreAV8JSZtmsUMsU5B4uflE2BxTgE/iT+HPoP1CgHVbPo2i3EC
	I+8CRoZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMEx8kxqB+PKBotDjAIcjEo8vBG/ZYOE
	WBPLiitzDzFKcDArifD+FpELEuJNSaysSi3Kjy8qzUktPsQozcGiJM57oNU6UEggPbEkNTs1
	tSC1CCbLxMEp1cAozxnCxHmLM4RfvF5M7f2V98q7vCwm1d0K8212O6ww/2XWqYfVYW9CclRk
	915Yduef1+f8Zk5x4T3Kf+7wb7Sv+8WxKj+/+e6Zg8fDlp3gVgvu4ijyTPP5Ubcmc/ux1hO7
	Vj2NDfiZ6dFe/WOr4+zzWW0tH0W/vxQSZOZf/kx/233mz+q8kwOUWIozEg21mIuKEwEkTCf1
	jQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
---
 drivers/clk/samsung/clk-pll.c | 2 ++
 drivers/clk/samsung/clk-pll.h | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/clk/samsung/clk-pll.c b/drivers/clk/samsung/clk-pll.c
index 7572d1d..c62ddfc 100644
--- a/drivers/clk/samsung/clk-pll.c
+++ b/drivers/clk/samsung/clk-pll.c
@@ -644,6 +644,8 @@ static void __init _samsung_clk_register_pll(struct samsung_pll_clock *pll_clk,
 			init.ops = &samsung_pll36xx_clk_ops;
 		break;
 	case pll_6552:
+	case pll_6545a:
+	case pll_6522x:
 		init.ops = &samsung_pll6552_clk_ops;
 		break;
 	case pll_6553:
diff --git a/drivers/clk/samsung/clk-pll.h b/drivers/clk/samsung/clk-pll.h
index cd11037..7679c4c 100644
--- a/drivers/clk/samsung/clk-pll.h
+++ b/drivers/clk/samsung/clk-pll.h
@@ -19,6 +19,8 @@ enum samsung_pll_type {
 	pll_2650,
 	pll_6552,
 	pll_6553,
+	pll_6545a,
+	pll_6522x,
 };
 
 #define PLL_35XX_RATE(_rate, _m, _p, _s)			\
-- 
1.8.1.2

