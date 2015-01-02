Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750818AbbABIEC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 03:04:02 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:21228 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbbABIEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 03:04:00 -0500
X-AuditID: cbfee68f-f791c6d000004834-dc-54a650ed7cc2
From: Inha Song <ideal.song@samsung.com>
To: broonie@kernel.org, lee.jones@linaro.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sameo@linux.intel.com, ckeepax@opensource.wolfsonmicro.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com,
        Inha Song <ideal.song@samsung.com>
Subject: [alsa-devel] [PATCH v2 RESEND 1/2] mfd: arizona: Add support for
 OUTn_MONO register control
Date: Fri, 02 Jan 2015 17:03:48 +0900
Message-id: <1420185829-24886-2-git-send-email-ideal.song@samsung.com>
X-Mailer: git-send-email 2.0.0.390.gcb682f8
In-reply-to: <1420185829-24886-1-git-send-email-ideal.song@samsung.com>
References: <1420185829-24886-1-git-send-email-ideal.song@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42JZI2JSovs2YFmIwfvrBhZTHz5hs/g35Qa7
	xfwj51gt+t8sZLXY9fc+o8W5VysZLe5/PcpocXnXHDaLpdcvMlksf/ufzWLC9LUsFq17j7Bb
	nO5mdeD1WDNvDaPH5b5eJo+Vy7+weWxa1cnmcefaHjaPeScDPV5O/M3m0bdlFaPH501yAZxR
	XDYpqTmZZalF+nYJXBlXGjvZC35xVExvl25gXMrexcjJISFgIvF++mRGCFtM4sK99WwgtpDA
	UkaJP9sjYWq2rnjA2sXIBRRfxCix89M/NghnDpPEredXmUGq2AQ0JL5/3gxmiwjoSHz+eIwZ
	pIhZYA+TxKQFq8HWCQukSeyY9pGli5GDg0VAVaLpQxBImFfATWLhurVQV2hL7GuYCXYFp4C7
	xMMVN1ghLnKT+L9hBdgVEgKP2CX23F8O1sAiICDxbfIhsJkSArISmw4wQ8yRlDi44gbLBEbh
	BYwMqxhFUwuSC4qT0ouM9YoTc4tL89L1kvNzNzECo+j0v2f9OxjvHrA+xCjAwajEw6twbWmI
	EGtiWXFl7iFGU6ANE5mlRJPzgbGaVxJvaGxmZGFqYmpsZG5ppiTOu1DqZ7CQQHpiSWp2ampB
	alF8UWlOavEhRiYOTqkGRoEvvhvbk9dI34s6spw5WEnFaFPUpLCqiS+eZveK5N7T/VnxJvhi
	om/7/vSFjr8uXPsxp95JpzTS4OnbGweUTVxc316suL82PKRJbuKDG9+PMckqv13tdGBXaLsR
	78FTSpub2bx/OFVd8Fi3urTrN0vuSa4/wm9yDF5ytxXlLrGv5Nmyeu6X1UosxRmJhlrMRcWJ
	ADN7FmydAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t9jAd23ActCDBas1rSY+vAJm8W/KTfY
	LeYfOcdq0f9mIavFrr/3GS3OvVrJaHH/61FGi8u75rBZLL1+kcli+dv/bBYTpq9lsWjde4Td
	4nQ3qwOvx5p5axg9Lvf1MnmsXP6FzWPTqk42jzvX9rB5zDsZ6PFy4m82j74tqxg9Pm+SC+CM
	amC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6W0mh
	LDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMOYcaWxk73gF0fF9HbpBsal7F2M
	nBwSAiYSW1c8YIWwxSQu3FvP1sXIxSEksIhRYuenf1DOHCaJW8+vMoNUsQloSHz/vBnMFhHQ
	kfj88RgzSBGzwB4miUkLVoONFRZIk9gx7SNLFyMHB4uAqkTThyCQMK+Am8TCdWsZIbZpS+xr
	mMkGYnMKuEs8XHED7AohoJr/G1awTmDkXcDIsIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMj
	OEqfSe9gXNVgcYhRgINRiYdX4drSECHWxLLiytxDjBIczEoivH1yS0KEeFMSK6tSi/Lji0pz
	UosPMZoCHTWRWUo0OR+YQPJK4g2NTcyMLI3MDS2MjM2VxHmV7NtChATSE0tSs1NTC1KLYPqY
	ODilGhhTPS9kbF/+Vn3+4qsKy/dnqNgnT7Fivv3hr7OFeUS/wd6o6Vx12kmLP1qrxCnEKJ5d
	ZPFT4c4ctV/XuOWstq+U3uua8crl+JSS2EXfXjAtLujkDk+XbXToU3l3fc+KLoXzk3Qu+NXu
	c/u2+tVPMd/E/FnmJ+1zdx5qqRUoV+DcEe9+L20mB4MSS3FGoqEWc1FxIgBH300m6AIAAA==
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

