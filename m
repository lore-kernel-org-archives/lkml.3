Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953AbaLRKx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 05:53:58 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:16697 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbaLRKxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 05:53:54 -0500
X-AuditID: cbfee691-f79b86d000004a5a-cf-5492b22dfd13
From: Inha Song <ideal.song@samsung.com>
To: broonie@kernel.org, lee.jones@linaro.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sameo@linux.intel.com, ckeepax@opensource.wolfsonmicro.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com,
        Inha Song <ideal.song@samsung.com>
Subject: [alsa-devel] [PATCH v2 1/2] mfd: arizona: Add support for OUTn_MONO
 register control
Date: Thu, 18 Dec 2014 19:53:15 +0900
Message-id: <1418899996-19744-2-git-send-email-ideal.song@samsung.com>
X-Mailer: git-send-email 2.0.0.390.gcb682f8
In-reply-to: <1418899996-19744-1-git-send-email-ideal.song@samsung.com>
References: <1418899996-19744-1-git-send-email-ideal.song@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmkeLIzCtJLcpLzFFi42JZI2JSqKu3aVKIwewuRoupD5+wWfybcoPd
	Yv6Rc6wW/W8Wslrs+nuf0eLcq5WMFve/HmW0uLxrDpvF0usXmSyWv/3PZjFh+loWi9a9R9gt
	TnezOvB6rJm3htHjcl8vk8fK5V/YPDat6mTzuHNtD5vHvJOBHi8n/mbz6NuyitHj8ya5AM4o
	LpuU1JzMstQifbsErowrjZ3sBb84Kqa3SzcwLmXvYuTkkBAwkThw7wwLhC0mceHeerYuRi4O
	IYGljBKTemESJhLbDrxlgUgsYpQ4unUBVNUcJokPPxpYQarYBDQkvn/ezAxiiwjoSHz+eIwZ
	pIhZYA+TxKQFq8H2CQvES7zYdhTI5uBgEVCVeHvWAiTMK+Am8WT+HFaIbdoS+xpmsoHYnALu
	ElO3vgOzhYBqrj3bBnaFhMA9dolZV1+BNbAICEh8m3yIBWSmhICsxKYDzBBzJCUOrrjBMoFR
	eAEjwypG0dSC5ILipPQiU73ixNzi0rx0veT83E2MwDg6/e/ZxB2M9w9YH2IU4GBU4uGV0JsU
	IsSaWFZcmXuI0RRow0RmKdHkfGC05pXEGxqbGVmYmpgaG5lbmimJ8+pI/wwWEkhPLEnNTk0t
	SC2KLyrNSS0+xMjEwSnVwBhQq+o/u/R2B+eC5iYWxZs2aomXLPc1Jv/WE39TlrNt0sTXSSWX
	fi451HRzk9zN5lkul84bnvt+37zH4XKuZrPz4ZXSZpN/hvlE+JhoB02tqdO7y+g8v2SbmeTe
	0JbqUO2ONS8eXXhQnOpuMTPKtddvus/EGN4T6dXpt9Vmfq9NsJZavNw0W4mlOCPRUIu5qDgR
	AFyo0vGeAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t9jAV3dTZNCDK4+MbWY+vAJm8W/KTfY
	LeYfOcdq0f9mIavFrr/3GS3OvVrJaHH/61FGi8u75rBZLL1+kcli+dv/bBYTpq9lsWjde4Td
	4nQ3qwOvx5p5axg9Lvf1MnmsXP6FzWPTqk42jzvX9rB5zDsZ6PFy4m82j74tqxg9Pm+SC+CM
	amC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6W0mh
	LDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMOYcaWxk73gF0fF9HbpBsal7F2M
	nBwSAiYS2w68ZYGwxSQu3FvP1sXIxSEksIhR4ujWBVDOHCaJDz8aWEGq2AQ0JL5/3swMYosI
	6Eh8/niMGaSIWWAPk8SkBavBxgoLxEu82HYUyObgYBFQlXh71gIkzCvgJvFk/hxWiG3aEvsa
	ZrKB2JwC7hJTt74Ds4WAaq4928YygZF3ASPDKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzg
	KH0mtYNxZYPFIUYBDkYlHl4JvUkhQqyJZcWVuYcYJTiYlUR4o3OAQrwpiZVVqUX58UWlOanF
	hxhNgY6ayCwlmpwPTCB5JfGGxiZmRpZG5oYWRsbmSuK8SvZtIUIC6YklqdmpqQWpRTB9TByc
	Ug2MAmsOrAqc/Cgrrdlwk/R2H6OVW+8Wf7ZsOVflx26q8VyvU/WJnKL2jfPsK7ouNPULWXOe
	OOOQGmZRl8AU4bLvg9+nxQktvJd7Lrzc51tWp71piTPPqqlmjs5NrHrtVeLL95/p8TpmPvOF
	gvr/t29sovXa2Kefrota5PmsSDzt32u798V8C/uVWIozEg21mIuKEwEvSsey6AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some boards need to set the OUTn_MONO register to configurates
the output signal path as a mono differential output. This
wlf,out-mono property is optional. If present, values must be
specified less than or equal to the number of output signals.
If values less than the number of output signals, elements
that has not been specified are set to 0 by default.

Example:
 - wlf,out-mono = <1 0 1>; /* set OUT1,OUT3 to mono differential */

Signed-off-by: Inha Song <ideal.song@samsung.com>
---
 drivers/mfd/arizona-core.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index bce7c07..cc2927d 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -561,6 +561,16 @@ static int arizona_of_get_core_pdata(struct arizona *arizona)
 		count++;
 	}
 
+	count = 0;
+	of_property_for_each_u32(arizona->dev->of_node,
+				 "wlf,out-mono", prop, cur, val) {
+		if (count >= ARRAY_SIZE(arizona->pdata.out_mono))
+			break;
+
+		arizona->pdata.out_mono[count] = !!val;
+		count++;
+	}
+
 	return 0;
 }
 
-- 
2.0.0.390.gcb682f8

