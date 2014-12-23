Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbaLWHka (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 02:40:30 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:58515 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbaLWHk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 02:40:28 -0500
X-AuditID: cbfee691-f79b86d000004a5a-46-54991c6a3936
From: Chanwoo Choi <cw00.choi@samsung.com>
To: s.nawrocki@samsung.com, tomasz.figa@gmail.com
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com, inki.dae@samsung.com,
        cw00.choi@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3]  clk: samsung: Use samsung_cmu_register_one() to simplify
 code
Date: Tue, 23 Dec 2014 16:40:20 +0900
Message-id: <1419320423-19228-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsWyRsSkQDdLZmaIwe8NyhbXvzxntZh0fwKL
	Re+Cq2wWZ5vesFtc3jWHzWLG+X1MFofftLNarNr1h9GBw2PnrLvsHn1bVjF6fN4kF8AcxWWT
	kpqTWZZapG+XwJVx4p5wwQm2ilV7HrA1MO5k7WLk5JAQMJH4smYnM4QtJnHh3nq2LkYuDiGB
	pYwSHx+tY4Qp6n77hBkisYhR4veNWWAdQgJNTBLPn6iC2GwCWhL7X9wA6ubgEBEwlLh5SAmk
	nllgGaPE0w03mEBqhAVCJRZ1bwezWQRUJeYcmwq2gFfAVWLS1wfsEMsUJJYtn8kK0iwh8JtN
	YvruC1ANAhLfJh9iAVkgISArsekA1NWSEgdX3GCZwCi4gJFhFaNoakFyQXFSepGpXnFibnFp
	Xrpecn7uJkZgqJ7+92ziDsb7B6wPMQpwMCrx8C44MyNEiDWxrLgy9xCjKdCGicxSosn5wIjI
	K4k3NDYzsjA1MTU2Mrc0UxLn1ZH+GSwkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBMT/vfIp4
	f6Csh07vv2Xd+9dc/ncyqivmt9dW3bpAN8/5t676FOXm6jvf3CkwfbLSPQ7Ok67lU4+/NXr+
	WiXpi3BgYPuBchcZM5Nlj45ufTuxS+TlIeZTKRaaZQ8trnZN9J1QdqRu/vWS+afKGJMdGRMW
	TviZb7f/zIEFayb82zrnid6uG3nK15RYijMSDbWYi4oTAdMmI4tQAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42I5/e+xgG6WzMwQgx3tMhbXvzxntZh0fwKL
	Re+Cq2wWZ5vesFtc3jWHzWLG+X1MFofftLNarNr1h9GBw2PnrLvsHn1bVjF6fN4kF8Ac1cBo
	k5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0gpJCWWJO
	KVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYx48Q94YITbBWr9jxga2DcydrFyMkh
	IWAi0f32CTOELSZx4d56ti5GLg4hgUWMEr9vzAJLCAk0MUk8f6IKYrMJaEnsf3EDqIiDQ0TA
	UOLmISWQemaBZYwSTzfcYAKpERYIlVjUvR3MZhFQlZhzbCojiM0r4Cox6esDdohlChLLls9k
	ncDIvYCRYRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcCQ8k9rBuLLB4hCjAAejEg/vgjMz
	QoRYE8uKK3MPMUpwMCuJ8L4UnxkixJuSWFmVWpQfX1Sak1p8iNEUaPtEZinR5HxglOaVxBsa
	m5gZWRqZG1oYGZsrifMq2beFCAmkJ5akZqemFqQWwfQxcXBKNTCG21msXSjbPcO7tvVzm0H0
	Z/v19VXmh+4w/dZlzg5cvHgHt2iI0q+lz5+zsDw75HXo8NXT3d11Zc0y4UvZM4ur+X8ePZw2
	c9bkpQdqnz6rz+bmT1ou3rrlQGhhahGD99Scq3vaDJdOaTEsVraxPLLlfbT1u4/PkxaJLtfl
	cXKs3fhlavOTc1ZKLMUZiYZazEXFiQDlSBZYmgIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set uses the samsung_cmu_register_one() function to simplify the
clock driver for Exynos3250/Exynos4415 SoC and change return value of
samsung_cmu_register_one() because some clock driver may need the instance
of samsung_clk_provider structure.

Chanwoo Choi (3):
  clk: samsung: Changes the return value of samsung_cmu_register_one()
  clk: samsung: exynos3250: Use samsung_cmu_register_one() to simplify code
  clk: samsung: exynos4415: Use samsung_cmu_register_one() to simplify code

 drivers/clk/samsung/clk-exynos3250.c | 217 ++++++++---------------------------
 drivers/clk/samsung/clk-exynos4415.c | 216 ++++++++--------------------------
 drivers/clk/samsung/clk.c            |  13 ++-
 drivers/clk/samsung/clk.h            |   3 +-
 4 files changed, 107 insertions(+), 342 deletions(-)

-- 
1.8.5.5

