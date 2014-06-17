Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbaFQA1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 20:27:20 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:19922 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbaFQA1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 20:27:18 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-24-539f8b6470d1
From: Chanwoo Choi <cw00.choi@samsung.com>
To: lee.jones@linaro.org, broonie@kernel.org, sameo@linux.intel.com
Cc: sbkim73@samsung.com, k.kozlowski@samsung.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org, t.figa@samsung.com,
        sachin.kamat@linaro.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv6 0/3] mfd: sec-core: Add support S2MPU02 PMIC device
Date: Tue, 17 Jun 2014 09:27:07 +0900
Message-id: <1402964830-24890-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsWyRsSkSDele36wwY5+DoupD5+wWVz/8pzV
	Yv6Rc6wW/W8Wslqce7WS0eL1C0OLs01v2C3ufz3KaHF51xw2i6XXLzJZ3G5cwWYxYfpaFou3
	d6azWLTuPcJucfJPL6PF6W5Wi4srvjBZrJ/xmsVByGPNvDWMHpf7epk8Vi7/wuaxeYWWx6ZV
	nWwed67tYfOYdzLQo2/LKkaPz5vkAjijuGxSUnMyy1KL9O0SuDI2/J3AXvCPt6L5p2AD412u
	LkZODgkBE4mmH/0sELaYxIV769lAbCGBpYwSh7fGw9S0nbzK3MXIBRRfxCixrv0uK4TTxCSx
	etYtsA42AS2J/S9ugNkiAs4S3z9NZAMpYhZoY5ZYuXQqO0hCWMBV4mnLbKAEBweLgKrE0l/u
	IGFekHDfaSaIbXISH/Y8YgcpkRB4yS6x0hAkzCIgIPFt8iEWiLCsxKYDzBDVkhIHV9xgmcAo
	uICRYRWjaGpBckFxUnqRkV5xYm5xaV66XnJ+7iZGYPyc/vesbwfjzQPWhxiTgcZNZJYSTc4H
	xl9eSbyhsZmRhamJqbGRuaUZacJK4ryLHiYFCQmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamB0
	SNnw9tvtL2uuxau5yawVZ5iidY0p5s6pqA+Jeb/39P30/nHe/ldyO293UXOXs93u6+ey99x0
	YTHvea98pmbiNKkln+cYhuSWrwnunL/4ZHXZ8+qVYjMn3VT7Oic/S+Zu3Wq/4/WtgacS+Cb6
	/ryWuf3nM+Zpcf9905ye9tQ+6OoyNO50YGhWYinOSDTUYi4qTgQAO0w8ZLUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+xgG5y9/xgg2vvrS2mPnzCZnH9y3NW
	i/lHzrFa9L9ZyGpx7tVKRovXLwwtzja9Ybe4//Uoo8XlXXPYLJZev8hkcbtxBZvFhOlrWSze
	3pnOYtG69wi7xck/vYwWp7tZLS6u+MJksX7GaxYHIY8189Ywelzu62XyWLn8C5vH5hVaHptW
	dbJ53Lm2h81j3slAj74tqxg9Pm+SC+CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDU
	NbS0MFdSyEvMTbVVcvEJ0HXLzAF6R0mhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+R
	ARpIWMOYseHvBPaCf7wVzT8FGxjvcnUxcnJICJhItJ28ygxhi0lcuLeerYuRi0NIYBGjxLr2
	u6wQThOTxOpZt9hAqtgEtCT2v7gBZosIOEt8/zQRrINZoI1ZYuXSqewgCWEBV4mnLbOBEhwc
	LAKqEkt/uYOEeUHCfaeZILbJSXzY84h9AiP3AkaGVYyiqQXJBcVJ6bmGesWJucWleel6yfm5
	mxjBMfpMagfjygaLQ4wCHIxKPLwPZecHC7EmlhVX5h5ilOBgVhLh5TIHCvGmJFZWpRblxxeV
	5qQWH2JMBlo+kVlKNDkfmD7ySuINjU3MjCyNzA0tjIzNSRNWEuc90GodKCSQnliSmp2aWpBa
	BLOFiYNTqoGxLCNZkaPszhvpQ8FlfidXL+reL63vZtenNTl4mUryxR8H5rT8vh0883/dkklX
	TR+y3Px/m9MqvEUncrtOHX9MX3j8eeGlvz79WfyZ71hEOduK0qhV8z79uWG4+uQ35jWHQlLX
	BOTtVdXvcl9eY7Xj9PVFM22ay48sXa9wvOfTd0bZwj3+dd+ZlViKMxINtZiLihMB4BD4/xUD	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset add Samsung S2MPU02 PMIC device driver in exiting S2MPS11 PMIC
driver because S2MPU02 has a little different between S2MPU02 and S2MPS1x.
The S2MPU02 PMIC has LDO[1-28] and BUCK[1-7] regulators.

Changes from v5:
- Remove the duplicate code about mfd_add_devices() and regmap_add_irq_chip()
- Add acked message by Lee Jones for mfd patch on patch2

Changes from v4:
- This patchset is rebased on 'Linux 3.16-rc1'.

Changes from v3:
- Fix bug of s2mps14_regulator_set_suspend_disable()

Changes from v2:
- Change patchset name
- Remove un-necessary switch statement
- Add acked message by Mark Brown for regulator patch
- Add reviewed message by Krzysztof Kozlowski for all patchs

Changes from v1:
- Fix typo about patch description
- Use existing suspend_state variable instead of defining new variable for S2MPU02
- Remove unnecessary parameter of s2mps11_pmic_dt_parse()
- Remove unfit comment of s2mpu02.h file
- Both patch2 and patch3 should be squashed on patch2

Chanwoo Choi (3):
  mfd: sec-core: Add support for S2MPU02 device
  regulator: s2mps11: Add support S2MPU02 regulator device
  dt-bindings: mfd: s2mps11: Add support S2MPU02 PMIC

 Documentation/devicetree/bindings/mfd/s2mps11.txt |   7 +-
 drivers/mfd/sec-core.c                            |  71 ++++-
 drivers/mfd/sec-irq.c                             | 110 ++++++--
 drivers/regulator/s2mps11.c                       | 321 ++++++++++++++++++++--
 include/linux/mfd/samsung/core.h                  |   1 +
 include/linux/mfd/samsung/irq.h                   |  24 ++
 include/linux/mfd/samsung/s2mpu02.h               | 201 ++++++++++++++
 7 files changed, 682 insertions(+), 53 deletions(-)
 create mode 100644 include/linux/mfd/samsung/s2mpu02.h

-- 
1.8.0

