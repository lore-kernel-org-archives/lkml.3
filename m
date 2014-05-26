Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496AbaEZNUo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 09:20:44 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:55698 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbaEZNUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 09:20:42 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-b5-53833fa229df
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Sangbeom Kim <sbkim73@samsung.com>, Lee Jones <lee.jones@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>, linux-kernel@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        devicetree@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 0/3] regulator: merge s2mps11 and s2mpa01 drivers
Date: Mon, 26 May 2014 15:20:20 +0200
Message-id: <1401110423-5647-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBJMWRmVeSWpSXmKPExsVy+t/xq7qL7JuDDb5tVLPYOGM9q8XUh0/Y
	LOYfOcdq8fqFocXZpjfsFve/HmW0+Halg8ni8q45bBYzzu9jslh75C67xck/vYwWF1d8YbJY
	P+M1iwOvx85Zd9k9Nq3qZPO4c20Pm0ffllWMHp83yQWwRnHZpKTmZJalFunbJXBlHP5ziLVg
	IXfFsoN3WBoYL3B0MXJySAiYSCy/9ZYdwhaTuHBvPRuILSSwlFHi8+EECLuPSeLqaR4Qm03A
	WGLz8iVANVwcIgI3GCWOT7vM3MXIwcEssIJJ4r4zSI2wgKPEllOXWEBsFgFViVmHm1lBSngF
	3CR2daZCrJKTOHlsMusERu4FjAyrGEVTS5MLipPSc430ihNzi0vz0vWS83M3MUJC6+sOxqXH
	rA4xCnAwKvHwvshrChZiTSwrrsw9xCjBwawkwqvF2RwsxJuSWFmVWpQfX1Sak1p8iJGJg1Oq
	gbHx/4cbfzwPTej8sXrN/cBNkzZt+ZV9xW7itWTW3OvNq5N2HGk/0/1huda7oGbz1dvdEqyT
	eI7mftp94sZx5tqTC9n2+qToCF4M85520vI380v1R6e4VkT9s/rfGHmVvdhmZeOrzLU6rJlN
	zzaKvbRky7jZz9CdqnqP6eEamSNKbb+/9RvF/a1VYinOSDTUYi4qTgQAa07j1AsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


The patchset merges s2mpa01 regulator driver into s2mps11. As a result
the s2mps11 supports:
 - S2MPA01
 - S2MPS11
 - S2MPS14

These PMIC-s are very similar to each other and they are often used
along with Samsung's Exynos SoCs. Merging this into one driver has
two benefits:
 - less code duplication,
 - one PMIC driver can be used in common Exynos default config.


The patchset was tested on Arndale Octa board with S2MPS11 PMIC. I am
kindly asking for testing on some board with S2MPA01.

Patches are rebased against current Mark Brown's regulator tree:
v3.15-rc5-41-g7c603c1c9e33


Best regards,
Krzysztof


Krzysztof Kozlowski (3):
  regulator: s2mps11: Refactor setting ramp delay
  regulator: s2mps11: Merge S2MPA01 driver
  regulator: s2mpa01: Remove driver because it was merged into s2mps11

 Documentation/devicetree/bindings/mfd/s2mpa01.txt |  90 ----
 Documentation/devicetree/bindings/mfd/s2mps11.txt | 106 +++--
 drivers/regulator/Kconfig                         |  11 +-
 drivers/regulator/Makefile                        |   1 -
 drivers/regulator/s2mpa01.c                       | 482 ---------------------
 drivers/regulator/s2mps11.c                       | 483 +++++++++++++++++-----
 6 files changed, 454 insertions(+), 719 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/mfd/s2mpa01.txt
 delete mode 100644 drivers/regulator/s2mpa01.c

-- 
1.9.1

