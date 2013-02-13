Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758382Ab3BMJfH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 04:35:07 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:43523 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab3BMJfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 04:35:00 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-66-511b5e43a078
From: Chanwoo Choi <cw00.choi@samsung.com>
To: gregkh@linuxfoundation.org, sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 0/9] extcon: Update for extcon-max8997/77693
Date: Wed, 13 Feb 2013 18:34:42 +0900
Message-id: <1360748082-21773-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsVy+t8zLV3nOOlAg9uHuCwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG4Tlb2QtO8FU83LKRsYHxJ3cXIyeHhICJxLX9N9ggbDGJC/fW
	A9lcHEICyxgl+k5+YYYrmvGYGSIxHShx+B4jhLOASWLy2c9gVWwCWhL7X0CMEhEwlTj19Do7
	iM0sUCtx+vJdoBoODmEBG4l9XyJAwiwCqhKLV/xgArF5BVwlfv1YxgqxTE7iw55H7BD2HjaJ
	00dqIeoFJL5NPsQCMkZCQFZi0wGo2yQlDq64wTKBUXABI8MqRtHUguSC4qT0XEO94sTc4tK8
	dL3k/NxNjJCAktrBuLLB4hCjAAejEg+vQ4hUoBBrYllxZe4hRgkOZiURXkd/6UAh3pTEyqrU
	ovz4otKc1OJDjMlAyycyS4km5wODPa8k3tDYwNjQ0NLQzNTS1IA0YSVxXsZTTwKEBNITS1Kz
	U1MLUotgtjBxcEo1MDb+/3H2poZTjQ/7hFi1+U9rmSfMjb801S5B7GDy3b3Loqcd+Ke0X2XG
	dYnd6Y7lvUu1ot/XdJUFBfx7NUms53qMxq4Znwvnf7pedvbtnw8ZO7vTPigt3GzuY3aS53Gd
	J/fpbCHWswcPTGs8rV5kLuHdzbNGvX/NA0cfLj6pt1Uzq4uVbp2eeE2JpTgj0VCLuag4EQDM
	Jo4FbAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42I5/e+xoK5TnHSgwd7lNhaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x4/CcrewFJ/gqHm7ZyNjA
	+JO7i5GTQ0LAROLajMfMELaYxIV769m6GLk4hASmM0r0Hb7HCOEsYJKYfPYzWBWbgJbE/hc3
	2EBsEQFTiVNPr7OD2MwCtRKnL98FquHgEBawkdj3JQIkzCKgKrF4xQ8mEJtXwFXi149lrBDL
	5CQ+7HnEPoGRewEjwypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4IB9JrWDcWWDxSFGAQ5G
	JR5ehxCpQCHWxLLiytxDjBIczEoivI7+0oFCvCmJlVWpRfnxRaU5qcWHGJOBtk9klhJNzgdG
	U15JvKGxiZmRpZGZsYm5sTFpwkrivIynngQICaQnlqRmp6YWpBbBbGHi4JRqYGS8UODbJ8Tm
	p8PcyvUu4ODbC/FnlacvOj6/LyXSQmn/ZcEJOhemqqX/+hW5bs3cNdfsHZeVvj7rbnv8pb5u
	Yvi6GsG5z8z9/Kefvnbp5Luse/mC+dtXMrUGipQceuGvMTcjViRY/NK0r1s/bNziH38nbe3/
	rd/i/q6uvc+z6XifrUb4kTW9hxOVWIozEg21mIuKEwEbeyAQnAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset add a few new feature of extcon-max8997
and fix minor issue of extcon-max8997/77693.

Update extcon-max8997 driver
- Consolidate duplicate code
- Set default uart/usb path for internal line of muic device
- Set default ADC debounce time
- Use wq to check cable state after certain delay
- Code clean to move defined constant to header file
- Make max8997_extcon_cable static
Update extcon-max77693 driver
- Convert to devm_input_allocate_device()
- Code clean to remove unnecessary goto statement
- Make max77693_extcon_cable static
Rename extcon-gpio.c filename for kernel naming style

Thanks,
Chanwoo Choi

Chanwoo Choi (9):
  extcon: gpio: Rename filename of extcon-gpio.c according to kernel naming style
  extcon: max77693: Convert to devm_input_allocate_device()
  extcon: max77693: Remove unnecessary goto statement to improve readability
  extcon: max8997: Move defined constant to header file
  extcon: max8997: Remove duplicate code related to set H/W line path
  extcon: max8997: Set default of ADC debounce time during initialization
  extcon: max8997: Consolidate duplicate code for checking ADC/CHG cable type
  extcon: max8997: Set default UART/USB path on probe
  extcon: max8997: Use workqueue to check cable state after completing boot of platform

 drivers/extcon/extcon-gpio.c        |   2 +-
 drivers/extcon/extcon-max77693.c    |  79 ++--
 drivers/extcon/extcon-max8997.c     | 725 ++++++++++++++++++++++++------------
 include/linux/extcon/extcon-gpio.h  |  52 +++
 include/linux/extcon/extcon_gpio.h  |  52 ---
 include/linux/mfd/max8997-private.h |  64 ++++
 include/linux/mfd/max8997.h         |  25 +-
 7 files changed, 662 insertions(+), 337 deletions(-)
 create mode 100644 include/linux/extcon/extcon-gpio.h
 delete mode 100644 include/linux/extcon/extcon_gpio.h

-- 
1.8.0

