Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938AbaLWLoo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 06:44:44 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:56422 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566AbaLWLol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 06:44:41 -0500
X-AuditID: cbfee68d-f79296d000004278-3c-549955a69b3a
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, mark.rutland@arm.com,
        a.kesavan@samsung.com, tomasz.figa@gmail.com, k.kozlowski@samsung.com,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [RFC PATCH 0/4] devfreq: Add generic exynos memory-bus frequency driver
Date: Tue, 23 Dec 2014 20:44:33 +0900
Message-id: <1419335077-31020-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsWyRsSkSHdZ6MwQgxPLBSwer1nMZHH9y3NW
	i/lHzrFaTLo/gcXi9QtDi94FV9kszja9YbfY9Pgaq8XlXXPYLD73HmG0mHF+H5PF0usXmSxu
	N65gs3i84i27xapdfxgd+D3WzFvD6LFz1l12j8V7XjJ5bF5S79G3ZRWjx+dNcgFsUVw2Kak5
	mWWpRfp2CVwZ00+eZSu4yVtxYV1mA+MNri5GTg4JAROJVevXM0LYYhIX7q1nA7GFBJYySnzc
	VwtTc3vHCfYuRi6g+HRGiQXvNzNCOE1MEhe33gbrYBPQktj/4gaYLSIgI3F143YWkCJmgUZm
	iS/L/jOBJIQFAiQevvvKDmKzCKhK3Fg6DyzOK+AqcXD/MhaIdQoSy5bPZAVplhDYxy5xu/MM
	M0SDgMS3yYeAijiAErISmw4wQ9RLShxccYNlAqPgAkaGVYyiqQXJBcVJ6UWGesWJucWleel6
	yfm5mxiB0XD637PeHYy3D1gfYhTgYFTi4V1wZkaIEGtiWXFl7iFGU6ANE5mlRJPzgTGXVxJv
	aGxmZGFqYmpsZG5ppiTOqyj1M1hIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDo6Vo3Z4vKrsW
	f9m25YxH+JXPAfvUS5VPTp7VLD253aOnh8+h8rLh5Lg17Dd9DrPMUJD9s3Wa3OlLGrKKu4uL
	nt39eD9x7+QyPvYZRy5pXnixMHLtfNb6bzOevA1yNQtRXXZOUe3TsS3n4s+2nH6/lKc/oiCh
	jNHw4KSj9llTXu4zWrKUo2u5QZsSS3FGoqEWc1FxIgCVBpxqgQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t9jQd1loTNDDO59ZbN4vGYxk8X1L89Z
	LeYfOcdqMen+BBaL1y8MLXoXXGWzONv0ht1i0+NrrBaXd81hs/jce4TRYsb5fUwWS69fZLK4
	3bgCqH/FW3aLVbv+MDrwe6yZt4bRY+esu+wei/e8ZPLYvKTeo2/LKkaPz5vkAtiiGhhtMlIT
	U1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4BOVlIoS8wpBQoF
	JBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBmTD95lq3gJm/FhXWZDYw3uLoYOTkkBEwk
	bu84wQ5hi0lcuLeerYuRi0NIYDqjxIL3mxkhnCYmiYtbb7OBVLEJaEnsf3EDzBYRkJG4unE7
	C0gRs0Ajs8SXZf+ZQBLCAgESD999BRvLIqAqcWPpPLA4r4CrxMH9y1gg1ilILFs+k3UCI/cC
	RoZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMHR9kxqB+PKBotDjAIcjEo8vAvOzAgRYk0s
	K67MPcQowcGsJMKrHDgzRIg3JbGyKrUoP76oNCe1+BCjKdD2icxSosn5wESQVxJvaGxiZmRp
	ZG5oYWRsriTOq2TfFiIkkJ5YkpqdmlqQWgTTx8TBKdXAuCtlTbpU/qdHdzbv42B7cieGWa16
	0aecFTGdRVavD1/QKy1UuK12x5J58e2P74O2fbjD6tC1q96b9YzpcUvtSrlzqm9uXX/RovBs
	Tk62Uc6b5sOLFQ1/t69OSJ1uwC7XudnTpHBiLqOLwgYZrcNz7h38VNz0I6/CdV2GlU643WZT
	JeWYP/sPK7EUZyQaajEXFScCAL38UiHMAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patch-set adds the generic exynos bus frequency driver for memory bus
with DEVFREQ framework. The Samsung Exynos SoCs have the common architecture
for memory bus between DRAM memory and MMC/sub IP in SoC. This driver can
support the memory bus frequency driver for Exynos SoCs.

Each memory bus block has a clock for memory bus speed and frequency
table which is changed according to the utilization of memory bus on runtime.
And then each memory bus group has the one more memory bus blocks and
OPP table (including frequency and voltage), regulator, devfreq-event
devices.

There are a little difference about the number of memory bus because each Exynos
SoC have the different sub-IP and different memory bus speed. In spite of this
difference among Exynos SoCs, we can support almost Exynos SoC by adding
unique data of memory bus to devicetree file.

Chanwoo Choi (4):
  devfreq: exynos: Add generic exynos memory bus frequency driver
  devfreq: exynos: Add documentation for generic exynos memory bus frequency driver
  ARM: dts: Add memory bus node for Exynos3250
  ARM: dts: Add memory bus node for Exynos3250-based Rinato board

 .../devicetree/bindings/devfreq/exynos-busfreq.txt | 184 +++++++
 arch/arm/boot/dts/exynos3250-rinato.dts            |  12 +
 arch/arm/boot/dts/exynos3250.dtsi                  | 137 +++++
 drivers/devfreq/Kconfig                            |  15 +
 drivers/devfreq/Makefile                           |   1 +
 drivers/devfreq/exynos-busfreq.c                   | 586 +++++++++++++++++++++
 6 files changed, 935 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/devfreq/exynos-busfreq.txt
 create mode 100644 drivers/devfreq/exynos-busfreq.c

-- 
1.8.5.5

