Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299AbaDPK1G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:27:06 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:37462 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbaDPK1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:27:03 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-d3-534e5af5a524
From: Sangjung Woo <sangjung.woo@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, Sangjung Woo <sangjung.woo@samsung.com>
Subject: [PATCH 0/8] Resource-managed extcon device register function
Date: Wed, 16 Apr 2014 19:26:55 +0900
Message-id: <1397644023-32516-1-git-send-email-sangjung.woo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsWyRsSkRPdrlF+wwfYmQYvrX56zWlzeNYfN
	4nbjCjaLBXtKHFg8+rasYvT4vEkugCmKyyYlNSezLLVI3y6BK2PdhSksBU1cFUsOfmBtYJzD
	0cXIySEhYCIx++Q/NghbTOLCvfVANheHkMBSRomJS78wwxR1vzjDCpFYxChx+t9MsA4hgTYm
	ibVrdUFsNgFdiScHLoM1iAgES3ScPM4EYjMLeErMndwFVi8s4Cqxbu0ddhCbRUBVYmFnH1g9
	r4CHxL6tH4EWcAAtU5CYM8kGYu91NolzHVkQ5QIS3yYfYoEokZXYdADqNEmJgytusExgFFzA
	yLCKUTS1ILmgOCm9yFSvODG3uDQvXS85P3cTIzDoTv97NnEH4/0D1ocYk4HGTWSWEk3OBwZt
	Xkm8obGZkYWpiamxkbmlGWnCSuK86Y+SgoQE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwzt6W
	9KbchX0+Y0ZosSWHA4vzc/4+J+ljYnY/I3aeObYo5J+U8pX/ixY21Tp6b5nWNDdrW/k/XlXn
	qQF7Hnw1VKy8d+jn0f2Ltea5mc2wEX1zwWiP2a8lP0u+rhIM293Cnhk0469Jd/rRNeePvGZ/
	v0tqsmF0SSvvVpGg/7OmyB2bdvWDfljcQiWW4oxEQy3mouJEAIGwAoBQAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNIsWRmVeSWpSXmKPExsVy+t9jAd2vUX7BBhu/cVpc//Kc1eLyrjls
	FrcbV7BZLNhT4sDi0bdlFaPH501yAUxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6
	hpYW5koKeYm5qbZKLj4Bum6ZOUCLlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZ
	oIGENYwZ6y5MYSlo4qpYcvADawPjHI4uRk4OCQETie4XZ1ghbDGJC/fWs3UxcnEICSxilDj9
	byYbSEJIoI1JYu1aXRCbTUBX4smBy8wgtohAsETHyeNMIDazgKfE3MldYPXCAq4S69beYQex
	WQRUJRZ29oHV8wp4SOzb+hFoGQfQMgWJOZNsJjByL2BkWMUomlqQXFCclJ5rpFecmFtcmpeu
	l5yfu4kRHNTPpHcwrmqwOMQowMGoxMM7M8c3WIg1say4MvcQowQHs5IIb2OkX7AQb0piZVVq
	UX58UWlOavEhxmSg5ROZpUST84ERl1cSb2hsYmZkaWRuaGFkbE6asJI478FW60AhgfTEktTs
	1NSC1CKYLUwcnFINjGVzpfdO2nCyv0WGf7VmZsC05mOaLM8WvL204cid3Y8jtoVwHcoqby5g
	MI9vOKHub3YzSLlcNDLhpf6EQzzmuZFvvzE/u7/W/3333aBXH/1n3VPie771nkt10T3/Hr1H
	L1+J+0lm1ESeTJAP/SnWMltYOsNFYavRc+clTxVmLNrk937B0gqGC0osxRmJhlrMRcWJAF9C
	sJiuAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches add resource-managed extcon device register functions for
developers' convenience and apply them to related device driver files.
This work can make the code more tidy since extcon device is automatically
unregistered on driver detach so tiresome managing codes could be removed.


Sangjung Woo (8):
  extcon: Add resource-managed extcon register function
  extcon: adc-jack: Use devm_extcon_dev_register()
  extcon: gpio: Use devm_extcon_dev_register()
  extcon: max14577: Use devm_extcon_dev_register()
  extcon: max77693: Use devm_extcon_dev_register()
  extcon: max8997: Use devm_extcon_dev_register()
  extcon: palmas: Use devm_extcon_dev_register()
  extcon: arizona: Use devm_extcon_dev_register()

 drivers/extcon/extcon-adc-jack.c |   30 +++++---------
 drivers/extcon/extcon-arizona.c  |   13 ++----
 drivers/extcon/extcon-class.c    |   83 ++++++++++++++++++++++++++++++++++++++
 drivers/extcon/extcon-gpio.c     |   16 ++------
 drivers/extcon/extcon-max14577.c |    9 +----
 drivers/extcon/extcon-max77693.c |    7 +---
 drivers/extcon/extcon-max8997.c  |    4 +-
 drivers/extcon/extcon-palmas.c   |   15 +++----
 include/linux/extcon.h           |    8 ++++
 9 files changed, 118 insertions(+), 67 deletions(-)

-- 
1.7.9.5

