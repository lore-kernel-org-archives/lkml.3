Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438Ab3DQXZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 19:25:56 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:62463 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab3DQXZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 19:25:54 -0400
X-AuditID: cbfee68d-b7f786d000005188-5a-516f2f81f019
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org,
        cpgs@samsung.com
Cc: stable@vger.kernel.org, "'Li Fei'" <fei.li@intel.com>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        "'Liu Chuansheng'" <chuansheng.liu@intel.com>
References: 
In-reply-to: 
Subject: [PATCH 3.8-stable] regmap: irq: call pm_runtime_put in
 pm_runtime_get_sync
Date: Thu, 18 Apr 2013 08:25:52 +0900
Message-id: <003601ce3bc2$e72fd950$b58f8bf0$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJswAu8tBWAAAHkyUAAAQsZQ
Content-language: ko
x-cr-hashedpuzzle: DGmy JL/I JsKj MTJ5 Qk7m We9M YjDg 1BhE 5zha 9lRo /8Pq
 AAHwAA== ADRwVQ== AEmiow== AExnWQ==
 AGh9OQ==;7;YgByAG8AbwBuAGkAZQBAAG8AcABlAG4AcwBvAHUAcgBjAGUALgB3AG8AbABmAHMAbwBuAG0AaQBjAHIAbwAuAGMAbwBtADsAYwBoAHUAYQBuAHMAaABlAG4AZwAuAGwAaQB1AEAAaQBuAHQAZQBsAC4AYwBvAG0AOwBjAHAAZwBzAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtADsAZgBlAGkALgBsAGkAQABpAG4AdABlAGwALgBjAG8AbQA7AGoAaABiAGkAcgBkAC4AYwBoAG8AaQBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBzAHQAYQBiAGwAZQBAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnAA==;Sosha1_v1;7;{4317CF70-B29C-4314-A011-0D8459D83B48};agBoAGIAaQByAGQALgBjAGgAbwBpAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtAA==;Wed,
 17 Apr 2013 23:25:38
 GMT;WwBQAEEAVABDAEgAIAAzAC4AOAAtAHMAdABhAGIAbABlAF0AIAByAGUAZwBtAGEAcAA6ACAAaQByAHEAOgAgAGMAYQBsAGwAIABwAG0AXwByAHUAbgB0AGkAbQBlAF8AcAB1AHQAIABpAG4AIABwAG0AXwByAHUAbgB0AGkAbQBlAF8AZwBlAHQAXwBzAHkAbgBjAA==
x-cr-puzzleid: {4317CF70-B29C-4314-A011-0D8459D83B48}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsVy+t8zY91G/fxAg0+7WS3+zT7FZjH9yz5m
	i5eHNC1uLjvAYrGkmdvi8q45bBYLNj5idGD3WLznJZPHy4m/2Tz6tqxi9Pi8SS6AJYrLJiU1
	J7MstUjfLoErY+viCUwFkzgruo5cY2lgvMDexcjJISFgIrHyYSMzhC0mceHeerYuRi4OIYFl
	jBJr1h9jgim6tu0fK0RiEaPEo8VzWUASQgJ/GSXaNruB2GwCuhLH1m9hBbFFBOIlji06yQ7S
	wCwwh1Hi6qkNQGM5gBq4JVY3B4HUcArwSKz70wm2WVggVOL3lr1gM1kEVCWOP+llBLF5Bewk
	Xl6bxgxhC0r8mHwPrIZZQEti/c7jTBC2vMTmNW+ZQcZLCKhLPPqrC3GCm8SK7qVQJSIS+168
	YwQ5R0JgCbvExm/PWCHqTSWW/9GGiP9ll/j7sp8Z4gYBiW+TD7FA1MhKbDoADSBJiYMrbrBM
	YJSaheSiWUgumoXkollIVi9gZFnFKJpakFxQnJReZKhXnJhbXJqXrpecn7uJERLfvTsYbx+w
	PsSYDLR+IrOUaHI+MD3klcQbGpsZWZiamBobmVuakSasJM6r1mIdKCSQnliSmp2aWpBaFF9U
	mpNafIiRiYNTqoFx4r5TGay7z/+pFtBv0E186OKSJR2R8aUxuNYlnW/pur7eIrPNfU5tuW2m
	612+XRJ59s7KoyWFs9RVXS//4R+bAuv8eP8u9hkZvB/O+zddvmwfvUHV7rul0fl8HiGOrVH3
	So4sbmz8uTHy8cVG3oWHJ7DMzKzd8nVGV7tnd6ygnHP8ie3hhkosxRmJhlrMRcWJABu6+hUF	AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHKsWRmVeSWpSXmKPExsVy+t9jAd1G/fxAg5/hFv9mn2KzmP5lH7PF
	y0OaFjeXHWCxWNLMbXF51xw2iwUbHzE6sHss3vOSyePlxN9sHn1bVjF6fN4kF8AS1cBok5Ga
	mJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0X0mhLDGnFCgU
	kFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYsXXxBKaCSZwVXUeusTQwXmDvYuTkkBAw
	kbi27R8rhC0mceHeerYuRi4OIYFFjBKPFs9lAUkICfxllGjb7AZiswnoShxbvwWsQUQgXuLY
	opPsIA3MAnMYJa6e2gDUzQHUwC2xujkIpIZTgEdi3Z9OZhBbWCBU4veWvWAzWQRUJY4/6WUE
	sXkF7CReXpvGDGELSvyYfA+shllAS2L9zuNMELa8xOY1b5lBxksIqEs8+qsLcYKbxIrupVAl
	IhL7XrxjBDlHQmAJu8TGb89YIepNJZb/0Z7AKDILyYZZSDbMQrJhFpJRCxhZVjGKphYkFxQn
	peca6hUn5haX5qXrJefnbmIEp45nUjsYVzZYHGIU4GBU4uF9sCovUIg1say4MvcQowQHs5II
	7yPZ/EAh3pTEyqrUovz4otKc1OJDjMnAAJjILCWanA9Ma3kl8YbGJmZGlkZmFkYm5uakCSuJ
	8x5otQ4UEkhPLEnNTk0tSC2C2cLEwSnVwKgTstG3/LWPtIwK99727R3dGxbpPpJgrywoPhc7
	cbl7gj1/XnVplJWb/8eMSKPtQod8LnBHsb4rnexmfjfej9+Sr2p7r/uNf/aNVyb9LzIsWbU+
	98mPOXf3M82t8ni26rXQ2WmcrOIz6jxaD/ROq1Z3skj4KdXy+/QXxcP7D75gbu1atmIzgxJL
	cUaioRZzUXEiADXHrHlhAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Li Fei <fei.li@intel.com>"

commit 283189d3be56aa6db6f192bb255df68493cd79ac upstream.

Even in failed case of pm_runtime_get_sync, the usage_count
is incremented. In order to keep the usage_count with correct
value and runtime power management to behave correctly, call
pm_runtime_put(_sync) in such case.

Signed-off-by Liu Chuansheng <chuansheng.liu@intel.com>
Signed-off-by: Li Fei <fei.li@intel.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/base/regmap/regmap-irq.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/base/regmap/regmap-irq.c
b/drivers/base/regmap/regmap-irq.c
index 5972ad9..d623eea 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -167,6 +167,7 @@ static irqreturn_t regmap_irq_thread(int irq, void *d)
 		if (ret < 0) {
 			dev_err(map->dev, "IRQ thread failed to resume:
%d\n",
 				ret);
+			pm_runtime_put(map->dev);
 			return IRQ_NONE;
 		}
 	}
-- 
1.7.9.5

