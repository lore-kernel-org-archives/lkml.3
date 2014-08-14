Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbaHNAWF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 20:22:05 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:50702 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbaHNAVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 20:21:07 -0400
X-AuditID: cbfee68e-b7fab6d000004d4a-67-53ec00f08b29
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 4/4] extcon: sm5502: Add I2C dependency to fix build break
Date: Thu, 14 Aug 2014 09:21:00 +0900
Message-id: <1407975660-3993-5-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1407975660-3993-1-git-send-email-cw00.choi@samsung.com>
References: <1407975660-3993-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsWyRsSkWPcDw5tgg0sT1Cyuf3nOanG26Q27
	xeVdc9gsbjeuYHNg8ejbsorR4/MmuQCmKC6blNSczLLUIn27BK6MT2f2sRXc5a04vGYLawNj
	A08XIyeHhICJxMlHr1kgbDGJC/fWs3UxcnEICSxllJg69xorTNG625MZIRLTGSVWrznHBOE0
	MUls77rMBFLFJqAlsf/FDTYQW0RAQWJz7zOwbmaBeImz3d2MILawgI/Ehu5FzCA2i4CqxKml
	EBt4BVwkfhw/ww6xTU7iw55HYDangKvE1BOfwOqFgGqer5gLdp6EwGs2ieczVrBDDBKQ+Db5
	ENAPHEAJWYlNB5gh5khKHFxxg2UCo/ACRoZVjKKpBckFxUnpRUZ6xYm5xaV56XrJ+bmbGIHB
	evrfs74djDcPWB9iTAYaN5FZSjQ5HxjseSXxhsZmRhamJqbGRuaWZqQJK4nzLnqYFCQkkJ5Y
	kpqdmlqQWhRfVJqTWnyIkYmDU6qBseJehbG4zpdjV2dF9iz395U8aV3LM1dm/Znf4vaWt3ef
	WvDyip9oW9mvnmDVlLPFkT58GsHvTL96PF+voTZhxuU1mzuXTuVoD5APCM+o1rs6x9lmZ/jn
	ucZ/5otI5z+JDHD8e4T5hoip7/UyyRzzRTujt7D2HqmY3+dSMl+tf56ijPTZfS3zlFiKMxIN
	tZiLihMBs8aKgmwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42I5/e+xoO4HhjfBBg0zZSyuf3nOanG26Q27
	xeVdc9gsbjeuYHNg8ejbsorR4/MmuQCmqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwND
	XUNLC3MlhbzE3FRbJRefAF23zBygTUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqM
	DNBAwhrGjE9n9rEV3OWtOLxmC2sDYwNPFyMnh4SAicS625MZIWwxiQv31rN1MXJxCAlMZ5RY
	veYcE4TTxCSxvesyE0gVm4CWxP4XN9hAbBEBBYnNvc9YQWxmgXiJs93dYJOEBXwkNnQvYgax
	WQRUJU4tvQZWwyvgIvHj+Bl2iG1yEh/2PAKzOQVcJaae+ARWLwRU83zFXLYJjLwLGBlWMYqm
	FiQXFCel5xrqFSfmFpfmpesl5+duYgTHwjOpHYwrGywOMQpwMCrx8HpEvQ4WYk0sK67MPcQo
	wcGsJMLrtxsoxJuSWFmVWpQfX1Sak1p8iNEU6KqJzFKiyfnAOM0riTc0NjEzsjQyN7QwMjZX
	Euc90GodKCSQnliSmp2aWpBaBNPHxMEp1cDoZJDP13ph84fQ+GWNvuYCb22/HCzakrrppJps
	VUZTQP36HrHuLbWR5j3c0WdubXNTVT1We0Uq5QCPRGnXS40vf57OE7scv3y73lOPi51W+57P
	eHVmyRHHp92sKS7ZF2S3ReaurXOQVm1UXlx+asN+3Qlzrx031eP5uTTjzzZBvzv1wkeNFBiV
	WIozEg21mIuKEwHgoWdymwIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add I2C configuration dependency to fix following build break.
If specific kernel build I2C as module, extcon-sm5502 have to depend on
I2C configuration.

	drivers/built-in.o: In function `regmap_smbus_byte_reg_read':
	regmap-i2c.c:(.text+0x5030a): undefined reference to `i2c_smbus_read_byte_data'
	drivers/built-in.o: In function `regmap_smbus_byte_reg_write':
	regmap-i2c.c:(.text+0x50338): undefined reference to `i2c_smbus_write_byte_data'
	drivers/built-in.o: In function `regmap_smbus_word_reg_read':
	regmap-i2c.c:(.text+0x50356): undefined reference to `i2c_smbus_read_word_data'
	drivers/built-in.o: In function `regmap_smbus_word_reg_write':
	regmap-i2c.c:(.text+0x50384): undefined reference to `i2c_smbus_write_word_data'
	drivers/built-in.o: In function `regmap_i2c_read':
	regmap-i2c.c:(.text+0x503cf): undefined reference to `i2c_transfer'
	drivers/built-in.o: In function `regmap_i2c_gather_write':
	regmap-i2c.c:(.text+0x50442): undefined reference to `i2c_transfer'
	drivers/built-in.o: In function `regmap_i2c_write':
	regmap-i2c.c:(.text+0x50474): undefined reference to `i2c_master_send'
	drivers/built-in.o: In function `sm5502_muic_i2c_init':
	extcon-sm5502.c:(.init.text+0x6630): undefined reference to `i2c_register_driver'

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/extcon/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/extcon/Kconfig b/drivers/extcon/Kconfig
index 6f2f472..764f3a1 100644
--- a/drivers/extcon/Kconfig
+++ b/drivers/extcon/Kconfig
@@ -72,6 +72,7 @@ config EXTCON_PALMAS
 
 config EXTCON_SM5502
 	tristate "SM5502 EXTCON support"
+	depends on I2C
 	select IRQ_DOMAIN
 	select REGMAP_I2C
 	select REGMAP_IRQ
-- 
1.8.0

