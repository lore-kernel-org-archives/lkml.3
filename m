Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab3KEPV0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 10:21:26 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:55023 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab3KEPVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 10:21:25 -0500
X-AuditID: cbfec7f5-b7ef66d00000795a-eb-52790cf38fd0
From: Tomasz Figa <t.figa@samsung.com>
To: Olof Johansson <olof@lixom.net>
Cc: Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 1/2] of: irq: Fix interrupt-map entry matching
Date: Tue, 05 Nov 2013 16:21:18 +0100
Message-id: <2713030.RoDxNQo0oz@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11.2 (Linux/3.11.5-gentoo; KDE/4.11.2; x86_64; ; )
In-reply-to: <2177804.l4VGDTRFDu@amdc1227>
References: <1381869563-16083-1-git-send-email-grant.likely@linaro.org>
 <20131104050455.GA3651@quad.lixom.net> <2177804.l4VGDTRFDu@amdc1227>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsVy+t/xq7qfeSqDDA5eEbP40NTKbDH/yDlW
	iwN/djBafD28gtHi8q45bBanrn9mc2Dz6HnTwupx59oeNo8rJ5pYPT5vkgtgieKySUnNySxL
	LdK3S+DKWDPNtaCbreLX72nsDYwfWLoYOTkkBEwk1p56wAphi0lcuLeerYuRi0NIYCmjxJIz
	69khnC4miVPfG5lAqtgE1CQ+NzxiA7FFBJQlnrRdYgaxmQXuMEosOJwFYgsL2Ekc+X2UEcRm
	EVCV6P7bwA5i8wpoSpx+/A3M5hdQl3i37SnYTFEBN4npPw6CzeEU0JJ49LWJCWJxH6PErgMH
	WSCaBSV+TL7HArFMXmLf/qmsELaWxPqdx5kmMArOQlI2C0nZLCRlCxiZVzGKppYmFxQnpeca
	6RUn5haX5qXrJefnbmKEhPrXHYxLj1kdYhTgYFTi4bW8UB4kxJpYVlyZe4hRgoNZSYT32P+K
	ICHelMTKqtSi/Pii0pzU4kOMTBycUg2MhxzXzFqvbH82427ewXCpZ/+PGV2L+ll3WSXyQuXV
	+uQNMZbXD7S0u3xcv+Kjp7Rpw58pD2XWPa7rKbluXyHyTFbmz0zpVYtKXrd7VkXd5WJPK98w
	34fnDO9TjQftc06fnXJN4Yi3U0XThQkTuuMuGDTvaO26U7SbSdmQWyMw9xEPn8BZlt2VSizF
	GYmGWsxFxYkA94KyLFMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes interrupt-map entry matching code to properly match all
specifier cells with interrupt map entries.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
---
 drivers/of/irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index 0ed5ed4..717eed4 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -195,7 +195,7 @@ int of_irq_parse_raw(const __be32 *addr, struct of_phandle_args *out_irq)
 			/* Compare specifiers */
 			match = 1;
 			for (i = 0; i < (addrsize + intsize); i++, imaplen--)
-				match = !((match_array[i] ^ *imap++) & imask[i]);
+				match &= !((match_array[i] ^ *imap++) & imask[i]);
 
 			pr_debug(" -> match=%d (imaplen=%d)\n", match, imaplen);
 
-- 
1.8.4.2


