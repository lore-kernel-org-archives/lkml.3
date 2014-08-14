Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbaHNARA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 20:17:00 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:17269 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbaHNAQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 20:16:59 -0400
X-AuditID: cbfee68e-b7fab6d000004d4a-bd-53ebfff644ab
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        sw0312.kim@samsung.com, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 0/2] extcon: rt8973a: Add Richtek RT8973A MUIC driver
Date: Thu, 14 Aug 2014 09:16:50 +0900
Message-id: <1407975412-3668-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsWyRsSkUPfb/9fBBhObtCyuf3nOanG26Q27
	xeVdc9gsbjeuYLOYMfklmwOrR9+WVYwenzfJBTBFcdmkpOZklqUW6dslcGWcmvKGseADZ0Xr
	+c9MDYzn2LsYOTkkBEwkJn9+AGWLSVy4t56ti5GLQ0hgKaPErIkLWGGKZh1fA5VYxCjxZ8Fd
	VginiUli1vI3YFVsAloS+1/cYAOxRQQUJDb3PgOLMwuUS6w8so8ZxBYWcJf4/WkaI4jNIqAq
	cXzLMRYQm1fAReLHywY2iG1yEh/2PGIHWSAhcJ1NYuvXM6wQDQIS3yYfAmrgAErISmw6wAxR
	LylxcMUNlgmMggsYGVYxiqYWJBcUJ6UXGekVJ+YWl+al6yXn525iBIbh6X/P+nYw3jxgfYgx
	GWjcRGYp0eR8YBjnlcQbGpsZWZiamBobmVuakSasJM676GFSkJBAemJJanZqakFqUXxRaU5q
	8SFGJg5OqQbGKa8PHJ6cYCce+NbLe9X6hdZzXppZOO1elrWoberBp74bpNZXHb5h1u1xbqfc
	pmVrz54P6RCU3jct6ua2pe2mDRUblNu8HOLX9W5TT1UR6ekQ0GqcucNrTyTPI16rpfte32SM
	OXyqrivuqaBm0+vq9I9ly3ZP+r3S+LzD6TmnM8TD47Utd/RLKbEUZyQaajEXFScCAAB+OdZZ	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsVy+t9jAd1v/18HG9w+oWRx/ctzVouzTW/Y
	LS7vmsNmcbtxBZvFjMkv2RxYPfq2rGL0+LxJLoApqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzje
	Od7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdonZJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd
	35AguB4jAzSQsIYx49SUN4wFHzgrWs9/ZmpgPMfexcjJISFgIjHr+Bo2CFtM4sK99UA2F4eQ
	wCJGiT8L7rJCOE1MErOWv2EFqWIT0JLY/+IGWIeIgILE5t5nYHFmgXKJlUf2MYPYwgLuEr8/
	TWMEsVkEVCWObznGAmLzCrhI/HjZALVNTuLDnkfsExi5FzAyrGIUTS1ILihOSs810itOzC0u
	zUvXS87P3cQIDvJn0jsYVzVYHGIU4GBU4uH1iHodLMSaWFZcmXuIUYKDWUmE1283UIg3JbGy
	KrUoP76oNCe1+BCjKdD2icxSosn5wAjMK4k3NDYxM7I0Mje0MDI2VxLnPdhqHSgkkJ5Ykpqd
	mlqQWgTTx8TBKdXAmKH29JOhp9Pm9Sdu29w/buKiJcNafkPUYY/aw9AK3ikHeNmW9k/Wm76t
	735gWvONm79yDzx6e+Vm03YTn00s5+pEHbVded2ZfreWrcpcczg9n0128YaozILVoVx/wks+
	JMyOdn67+m8gc3Hrs7veCtN/meVrr242mhFy+NLtrivfZ+6WqhLco8RSnJFoqMVcVJwIAOd8
	vNCIAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset add new Richtek RT8973A MUIC (Micro-USB IC) driver.
The RT8973A is a USB port accessory detector and switch that is optimized to
protect low voltage system from abnormal high input voltage (up to 28V) and
supports high speed USB operation. Also, RT8973A support 'auto-configuration'
mode. If auto-configuration mode is enabled, RT8973A would control internal
h/w patch for USB D-/D+ switching.

Changes from v1:
- Fix typo
- Fix coding style by using checkpatch script
- Add I2C dependency to protect build break when I2C=m

Chanwoo Choi (2):
  extcon: rt8973a: Add Richtek RT8973A extcon driver
  dt-bindings: extcon: Add support for Richtek RT8973A MUIC device

 .../devicetree/bindings/extcon/extcon-rt8973a.txt  |  25 +
 drivers/extcon/Kconfig                             |  12 +
 drivers/extcon/Makefile                            |   1 +
 drivers/extcon/extcon-rt8973a.c                    | 740 +++++++++++++++++++++
 drivers/extcon/extcon-rt8973a.h                    | 203 ++++++
 5 files changed, 981 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/extcon/extcon-rt8973a.txt
 create mode 100644 drivers/extcon/extcon-rt8973a.c
 create mode 100644 drivers/extcon/extcon-rt8973a.h

-- 
1.8.0

