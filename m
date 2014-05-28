Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529AbaE1Jk5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 05:40:57 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:49761 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbaE1Jjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 05:39:51 -0400
X-AuditID: cbfee690-b7fb56d000003439-e2-5385aee3a4e7
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 0/4] extcon: sm5502: Add support SM5502 MUIC driver
Date: Wed, 28 May 2014 18:39:32 +0900
Message-id: <1401269976-12754-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsWyRsSkUPfxutZgg4u32Cyuf3nOanG26Q27
	xeVdc9gsbjeuYHNg8ejbsorR4/MmuQCmKC6blNSczLLUIn27BK6Mo1NmMBVc5Kj4tuAjawPj
	WbYuRk4OCQETiU2XpzFB2GISF+6tB4pzcQgJLGWU2HT3BgtM0YOLJ6ES0xkl+r88YYZwmpgk
	Jr2+yg5SxSagJbH/xQ2wsSICChKbe5+xgtjMAvESZ7u7GUFsYQFniRu9D8FsFgFVicYDC8F6
	eQVcJZrfXmSH2CYn8WHPI3aQBRICl9kklsx7yQLRICDxbfIhIJsDKCErsekAM0S9pMTBFTdY
	JjAKLmBkWMUomlqQXFCclF5kolecmFtcmpeul5yfu4kRGHyn/z2bsIPx3gHrQ4zJQOMmMkuJ
	JucDgzevJN7Q2MzIwtTE1NjI3NKMNGElcV61R0lBQgLpiSWp2ampBalF8UWlOanFhxiZODil
	Ghh7s1zPrTxi9+GlfSZ3dFdJmAZnscN774704Herlip/+XNcp57tk5EN30sDF82+FY0hkSy/
	nh7qzjzz79CixB97yp6/Wjz/Pc8ExcIPQr6Z/jXejVMOlt5iOLhlYoi+VRG/o5b4woDTLE5m
	38LPpocu3MO7+MZX7Q9+lotsDPN/M/ybECi0k0OJpTgj0VCLuag4EQCg4VMFVAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHIsWRmVeSWpSXmKPExsVy+t9jQd1H61qDDVZes7G4/uU5q8XZpjfs
	Fpd3zWGzuN24gs2BxaNvyypGj8+b5AKYohoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwM
	dQ0tLcyVFPISc1NtlVx8AnTdMnOANikplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0Jgusx
	MkADCWsYM45OmcFUcJGj4tuCj6wNjGfZuhg5OSQETCQeXDwJZYtJXLi3Hsjm4hASmM4o0f/l
	CTOE08QkMen1VXaQKjYBLYn9L26AdYgIKEhs7n3GCmIzC8RLnO3uZgSxhQWcJW70PgSzWQRU
	JRoPLATr5RVwlWh+e5EdYpucxIc9j9gnMHIvYGRYxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7
	iREc2s+kdjCubLA4xCjAwajEw3tgcUuwEGtiWXFl7iFGCQ5mJRFep6WtwUK8KYmVValF+fFF
	pTmpxYcYk4G2T2SWEk3OB8ZdXkm8obGJmZGlkbmhhZGxOWnCSuK8B1qtA4UE0hNLUrNTUwtS
	i2C2MHFwSjUwRm/lTug4vaz32Mlza4wDnDcYz5PzrljvxzpztafbB80lRxvmX43oT9F59cp7
	m77CovxjwW8y52/2bFmr8tk4r1FY7wujiULwUr0cgTn/8iPLjwi6v/g8NVddr+egPtOSiv5r
	DVNvX+bczbjvh8W6TTuqft/ay5gf9NezrPLwpu6gzV/z752vUWIpzkg01GIuKk4EAOYV7UOx	AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset add new SM5502 MUIC (Micro-USB Interface Controller) device driver
using EXTCON (External Connector) subsystem. SM5502 can detect various type
of cable and control OVP (Over Voltage Protection) / OCP (Over Current Protection).

Chanwoo Choi (4):
  extcon: sm5502: Add support new SM5502 extcon device driver
  extcon: sm5502: Detect cable state after completing platform booting
  extcon: sm5502: Change internal hardware switch according to cable type
  dt-bindings: extcon: Add support for SM5502 MUIC device

 .../devicetree/bindings/extcon/extcon-sm5502.txt   |  23 +
 drivers/extcon/Kconfig                             |   7 +
 drivers/extcon/Makefile                            |   1 +
 drivers/extcon/extcon-sm5502.c                     | 726 +++++++++++++++++++++
 include/linux/extcon/sm5502.h                      | 287 ++++++++
 5 files changed, 1044 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/extcon/extcon-sm5502.txt
 create mode 100644 drivers/extcon/extcon-sm5502.c
 create mode 100644 include/linux/extcon/sm5502.h

-- 
1.8.0

