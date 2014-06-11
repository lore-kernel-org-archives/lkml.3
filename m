Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbaFKAld (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 20:41:33 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:58936 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaFKAlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 20:41:31 -0400
X-AuditID: cbfee690-b7fb56d000003439-b8-5397a5b9cc7b
From: Chanwoo Choi <cw00.choi@samsung.com>
To: broonie@kernel.org, lgirdwood@gmail.com, grant.likely@linaro.org,
        robh+dt@kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 0/2] regulator: of: Add support for pasing regulator suspend
 state
Date: Wed, 11 Jun 2014 09:41:21 +0900
Message-id: <1402447283-11356-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsWyRsSkUHfn0unBBt93ylhMffiEzeL6l+es
	FvOPnGO1OPBnB6PF2aY37BbfrnQwWVzeNYfN4nbjCjaL1r1H2B04PXbOusvusWlVJ5vHnWt7
	2Dz6tqxi9Pi8SS6ANYrLJiU1J7MstUjfLoErY+6k/awFu3kqnjV9YW5g7OHqYuTkkBAwkbjZ
	v5sJwhaTuHBvPVsXIxeHkMBSRomf554CJTjAimYd84OIT2eUWHZ3IROE08QkceDrJrBuNgEt
	if0vbrCBNIgIREms7QCrYRaYzSjRcr6PGaRGWCBM4srmbWD1LAKqEn8PTQCL8wq4SrRs6GWB
	uEJO4sOeR+wgzRIC/ewSq89tYoZoEJD4NvkQC8RFshKbDjBD1EtKHFxxg2UCo+ACRoZVjKKp
	BckFxUnpRSZ6xYm5xaV56XrJ+bmbGIGhfPrfswk7GO8dsD7EmAw0biKzlGhyPjAW8kriDY3N
	jCxMTUyNjcwtzUgTVhLnVXuUFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBUVDganbm+4k2
	L7bN/dvRazcnja9h/fe1jNZBy22KdsQe0vwkWSkluymmPK6zQPNCx85LjdzHJrO3RvRcTlyV
	uPnsTo31h7Y//tBlO6fItOHZBYWeBXIriizfRHTXMtROOaE411PWSWq3fQ9neoJNg8ivmBaD
	akZvoyrpFz7iYtfcTvAL/dunxFKckWioxVxUnAgAEdJPinsCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsVy+t9jQd2dS6cHG8w5IGox9eETNovrX56z
	Wsw/co7V4sCfHYwWZ5vesFt8u9LBZHF51xw2i9uNK9gsWvceYXfg9Ng56y67x6ZVnWwed67t
	YfPo27KK0ePzJrkA1qgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxU
	WyUXnwBdt8wcoIuUFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1jBlzJ+1n
	LdjNU/Gs6QtzA2MPVxcjB4eEgInErGN+XYycQKaYxIV769m6GLk4hASmM0osu7uQCcJpYpI4
	8HUTE0gVm4CWxP4XN9hAmkUEoiTWdoDVMAvMZpRoOd/HDFIjLBAmcWXzNrB6FgFVib+HJoDF
	eQVcJVo29LJAbJOT+LDnEfsERu4FjAyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYIj5ZnU
	DsaVDRaHGAU4GJV4eA9ITA8WYk0sK67MPcQowcGsJMJrkwYU4k1JrKxKLcqPLyrNSS0+xJgM
	tH0is5Rocj4wivNK4g2NTcyMLI3MDS2MjM1JE1YS5z3Qah0oJJCeWJKanZpakFoEs4WJg1Oq
	gXGJsrXVgiU7vMTe5nxWMP2fMq2ET6/12+6Jt5J0M4qDjswqNGXjq9q7plmpwYxb6OxCmZbk
	K8HaZgc7+UN/nUsM3itZ+sDWd02gaPGhtHtBHac6v056HtEkMLWnv/Av15z8C1GncrSn9PyS
	yUubGHKSw0PFdnKOEs+/VS++ZO3gyJWf3ibSq8RSnJFoqMVcVJwIAM2m89zYAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regulators would set different state/mode according to the kind of suspend
state. So regulation_constraints structure has already regulator suspend state filed.
This patch parse regulator suspend state from devicetree file.

For example:

	ldoX_reg: LDOx {
		regulator-name = "VAP_XXX_1.2V";
		regulator-min-microvolt = <1200000>;
		regulator-max-microvolt = <1200000>;
		regulator-always-on;

		regulator-initial-state = <3>;	/* PM_SUSPEND_MEM */
		regulator-state-standby {
			regulator-volt = <1200000>;
			regulator-mode = <0x2>;	/* REGULATOR_MODE_NORMAL */
		};

		regulator-state-mem {
			regulator-volt = <1200000>;
			regulator-mode = <0x8>;	/* REGULATOR_MODE_STANDBY */
			regulator-off-in-suspend;
		};

		regulator-state-disk {
			regulator-volt = <1200000>;
			regulator-mode = <0x2>;	/* REGULATOR_MODE_NORMAL */
			regulator-on-in-suspend;
		};
	};

Changes from v1:
- Check whether regulator-initial-state and regulator-mode is correct or not
- Add more detailed description about regulator-initial-state, regulator-mode
  and regulator-state-[standby/mem/disk] for devicetree bindings
- Modify example of regulator suspend state in bindings documentation

Chanwoo Choi (2):
  regulator: of: Add support for parsing regulator_state for suspend state
  dt-bindings: regulator: Add regulator suspend state for PM state

 .../devicetree/bindings/regulator/regulator.txt    | 32 +++++++++
 drivers/regulator/of_regulator.c                   | 76 +++++++++++++++++++++-
 2 files changed, 106 insertions(+), 2 deletions(-)

-- 
1.8.0

