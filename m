Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741AbaKRI7t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 03:59:49 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:54610 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020AbaKRI7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 03:59:46 -0500
X-AuditID: cbfee68f-f791c6d000004834-f1-546b0a806c07
From: Chanwoo Choi <cw00.choi@samsung.com>
To: lee.jones@linaro.org, broonie@kernel.org, mturquette@linaro.org,
        a.zummo@towertech.it
Cc: lgirdwood@gmail.com, sbkim73@samsung.com, sameo@linux.intel.com,
        geunsik.lim@samsung.com, inki.dae@samsung.com,
        kyungmin.park@samsung.com, k.kozlowski@samsung.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 0/5] mfd: sec-core: Add support S2MPS13 PMIC device
Date: Tue, 18 Nov 2014 17:59:38 +0900
Message-id: <1416301183-10478-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsWyRsSkWLeBKzvEYPFKWYslF6+yW0x9+ITN
	4vqX56wW84+cY7X4M6GVzWLS/QksFq9fGFqcbXrDbnH/61FGi29XOpgsLu+aw2bxdMJFNovT
	3awWF1d8YXLg89g56y67x6ZVnWwed67tYfOYdzLQo2/LKkaP6fN+Mnl83iQXwB7FZZOSmpNZ
	llqkb5fAlfG7qYux4C93xdW7fawNjBc4uhg5OSQETCRW9B9khrDFJC7cW8/WxcjFISSwlFHi
	/t6vTDBFX98vZoRITGeU+Dq9lwnCaWKS2Nj0hRGkik1AS2L/ixtsILaIQLTE8afHwTqYBXqY
	JN73bgQrEhZwlVi95yvYPhYBVYm5j96zgNi8QPFJP+ezQ6xTkFi2fCYrSLOEwD52ib0bt7BC
	NAhIfJt8CKiBAyghK7HpANTdkhIHV9xgmcAouICRYRWjaGpBckFxUnqRsV5xYm5xaV66XnJ+
	7iZGYDyc/vesfwfj3QPWhxgFOBiVeHgTpmaFCLEmlhVX5h5iNAXaMJFZSjQ5Hxh1eSXxhsZm
	RhamJqbGRuaWZkrivAulfgYLCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYKzendD8XN6R45Pf
	3Bvqt05t/+Syfdcidut644/5b+X0WvsX7fwj4DR1qkr70dJvYtt/qvLIBFy9xrXAJ+BKpcQh
	1Zgs52oOd3Vd5eZ7G89/NvX5afCIcb/8mhSbatUj57oTDeVPXlw2b96N4xX1ZwU2bvras6Ms
	QVShOLtw8eyap7ODkzYI5SmxFGckGmoxFxUnAgBv0zvHggIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t9jQd0GruwQgxvfhS2WXLzKbjH14RM2
	i+tfnrNazD9yjtXiz4RWNotJ9yewWLx+YWhxtukNu8X9r0cZLb5d6WCyuLxrDpvF0wkX2SxO
	d7NaXFzxhcmBz2PnrLvsHptWdbJ53Lm2h81j3slAj74tqxg9ps/7yeTxeZNcAHtUA6NNRmpi
	SmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtDFSgpliTmlQKGA
	xOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaM301djAV/uSuu3u1jbWC8wNHFyMkhIWAi
	8fX9YkYIW0ziwr31bF2MXBxCAtMZJb5O72WCcJqYJDY2fQGrYhPQktj/4gYbiC0iEC1x/Olx
	RpAiZoEeJon3vRvBioQFXCVW7/nKDGKzCKhKzH30ngXE5gWKT/o5nx1inYLEsuUzWScwci9g
	ZFjFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERxtz6R3MK5qsDjEKMDBqMTDmzg1K0SINbGs
	uDL3EKMEB7OSCO+5bqAQb0piZVVqUX58UWlOavEhRlOg7ROZpUST84GJIK8k3tDYxMzI0sjc
	0MLI2FxJnPdgq3WgkEB6YklqdmpqQWoRTB8TB6dUA2OEr//n6R84lj5M3bhV10FtOculn+eb
	+ht/ljZXeGwVuvh+eceMheL3nQ+nrK5ap1XZfHjLvuIH2Z/fJLWnsG6ezCPcyHqns9rguV/O
	Z63b0f31Ghs3H11rZHLJT+xnf5t/IXfQDLfqf0GLhQ+u+8LG89C5jHOuos6ZXatab2holRg8
	jrtVyavEUpyRaKjFXFScCAAMBSZtzAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds Samsung S2MPS13 PMIC device driver in existing S2MPS11 PMIC
driver. The S2MPS13 has just the differnet number of regulator from existing
S2MPS14 PMIC and RTC/CLOCK IP of S2MPS13 is the same with S2MPS14. S2MPS13
PMIC has LDO[1-40] and BUCK[1-10] regulators.

Changes from v1:
- Fix minor issue about coding style and wrong description
- Fix wrong from of third patch(3/5) related to clk driver
- Add acked tag by Mark Brown, Sangbeom Kim, Lee Jones
- Add reviewed tag by Krzysztof Kozlowski

Chanwoo Choi (5):
  mfd: sec-core: Add support for S2MPS13 device
  regulator: s2mps11: Add support S2MPS13 regulator device
  clk: s2mps11: Add the support for S2MPS13 PMIC clock
  rtc: s5m: Add the support for S2MPS13 RTC
  mfd: s2mps11: Add binding documentation for Samsung S2MPS13 PMIC

 Documentation/devicetree/bindings/mfd/s2mps11.txt |  22 +--
 drivers/clk/clk-s2mps11.c                         |  24 +++
 drivers/mfd/sec-core.c                            |  29 ++++
 drivers/mfd/sec-irq.c                             |  23 ++-
 drivers/regulator/Kconfig                         |  10 +-
 drivers/regulator/s2mps11.c                       | 102 +++++++++++-
 drivers/rtc/rtc-s5m.c                             |  15 +-
 include/linux/mfd/samsung/core.h                  |   2 +
 include/linux/mfd/samsung/s2mps13.h               | 186 ++++++++++++++++++++++
 9 files changed, 388 insertions(+), 25 deletions(-)
 create mode 100644 include/linux/mfd/samsung/s2mps13.h

-- 
1.8.5.5

