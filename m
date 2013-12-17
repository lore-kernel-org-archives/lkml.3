Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab3LQNXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 08:23:38 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:25594 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab3LQNXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 08:23:33 -0500
X-AuditID: cbfec7f5-b7f6f6d000005b3b-fa-52b050530982
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] mfd/regulator: s5m: Various fixes and GPIO control over
 Buck9
Date: Tue, 17 Dec 2013 14:23:16 +0100
Message-id: <1387286601-21646-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGLMWRmVeSWpSXmKPExsVy+t/xK7rBARuCDFp/iVk0XA2xmPrwCZvF
	/CPnWC363yxktTjwZwejxblXKxktXr8wtLj/9SijxbcrHUwWC9uWsFhc3jWHzWLp9YtMFhOm
	r2WxOLziAJPFupfTWSxO/ulltDjdzWpxccUXJotjM5YwOgh7rJm3htFjwecr7B6X+3qZPHbO
	usvusXL5FzaPTas62TxerZ7J6nHn2h42j3knAz36tqxi9Pi8SS6AO4rLJiU1J7MstUjfLoEr
	4+3DTYwFa3gqrl/uYm9gPMjZxcjJISFgInHlVysrhC0mceHeerYuRi4OIYGljBJn3+xnBEkI
	CfQxSbSdjQex2QSMJTYvX8IGYosIXGOVOHMmFMQWFgiR+PP6ODuIzSKgKvHzwlOwobwC7hJf
	N81m6WLkAFqgIDFnks0ERq4FjAyrGEVTS5MLipPSc430ihNzi0vz0vWS83M3MULC9usOxqXH
	rA4xCnAwKvHwHli2PkiINbGsuDL3EKMEB7OSCO83jw1BQrwpiZVVqUX58UWlOanFhxiZODil
	GhgTjl2xn+3LfWPFunn3N7toyWb2Pa5iUn6QvCNRpXnh0gl3BaK+LW2c6exj1sQ8oWnp06Y5
	e8Oj8+91cs0O23ZlTfTnx+tiuLeZlR/LdtE9IvTt2vZblruvfnTc/qjSf+rtyl92DKXiImYv
	VjqvMr6w6B4PW9LXJ1+Oper2ftqmKNH67+M8meQfSizFGYmGWsxFxYkAIwE11DkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a small set of patches with minor fixes for s5m8767 MFD driver
and regulator.

The patchset touches 3 different issues:
1. Patch 1/5: Add symbols for hard-coded DVS_RAMP values.
2. Patch 2/5 and 3/5: Remove the sec_reg* helpers hiding the regmap API.
3. Patch 4/5 and 5/5: Add GPIO control over Buck9/eMMC regulator.

I am sending this in one set as all of the patches use regmap API and they
mix over the removal of sec_reg* helpers.

The patchset is based on v3.13-rc4 however they also depend on previous
s5m8767 regulator patches (already in Mark Brown tree):
 - regulator: s5m8767: Define symbol for buck control mask
 - regulator: s5m8767: Implement voltage setting for BUCK7/8 regulators
https://git.kernel.org/cgit/linux/kernel/git/broonie/regulator.git/log/?h=topic/s5m8767


Best regards,
Krzysztof


Krzysztof Kozlowski (5):
  regulator: s5m8767: Add symbols for hard-coded DVS_RAMP register
  regulator: s5m8767: Do not use sec_reg* regmap helpers
  mfd: sec: Remove sec_reg* regmap helpers
  regulator: s5m8767: Use GPIO for controlling Buck9/eMMC
  regulator: s5m8767: Document new bindings for Buck9 GPIO control

 .../bindings/regulator/s5m8767-regulator.txt       |   16 ++
 drivers/mfd/sec-core.c                             |   30 ---
 drivers/regulator/s5m8767.c                        |  207 ++++++++++++++++----
 include/linux/mfd/samsung/core.h                   |    8 +-
 include/linux/mfd/samsung/s5m8767.h                |   22 +++
 5 files changed, 207 insertions(+), 76 deletions(-)

-- 
1.7.9.5

