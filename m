Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449Ab3D2FcG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 01:32:06 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:35534 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068Ab3D2FcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 01:32:04 -0400
X-AuditID: cbfee691-b7fe56d000004b96-e5-517e05d20709
From: Inki Dae <inki.dae@samsung.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, dri-devel@lists.freedesktop.org,
        Inki Dae <inki.dae@samsung.com>
Subject: [PATCH] module: fix mutiple defined issue
Date: Mon, 29 Apr 2013 14:32:01 +0900
Message-id: <1367213521-26795-1-git-send-email-inki.dae@samsung.com>
X-Mailer: git-send-email 1.7.5.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsWyRsSkRPcSa12gwfcXEhZXvr5ns2hevJ7N
	YtL9CSwWmx5fY7W4vGsOmwOrx/65a9g97ncfZ/LYvKTeo2/LKkaPz5vkAlijuGxSUnMyy1KL
	9O0SuDLe9vayFjzlqDi8dDJbA+MS9i5GTg4JAROJGXsuMkLYYhIX7q1n62Lk4hASWMooMav1
	HTNM0c8PJ9ghEosYJSYdamaGcLqYJK7tPs8KUsUmoCoxccV9oHYODhEBG4kLN+1BwswCORJL
	vrwE2yAsYCRxZM9OsKEsQOVL9h8Gs3kFXCTaT69nhVimIPHryCoo+zObxK4neRD1AhLfJh9i
	ARkvISArsekA1G2SEgdX3GCZwCi4gJFhFaNoakFyQXFSepGpXnFibnFpXrpecn7uJkZgeJ7+
	92ziDsb7B6wPMSYDjZvILCWanA8M77ySeENjMyMLUxNTYyNzSzPShJXEedVbrAOFBNITS1Kz
	U1MLUovii0pzUosPMTJxcEo1MPbsmbBkUdb7FZyiUZLv17BsXfroqMF7z9MX6ouczVnviGvX
	Fv2MnRhwL+rQ9BshV1Rnn/I/7aTpdNBhinwta+mOrZxbjkpMXi9uonHbS9vkbtSWfQ/OX3xk
	0DTzXBDf/3M7z6YxvTsjyLrioqSvicAZG75Zf3bPs3+2Kuv7BIXorM3COWqbFA2UWIozEg21
	mIuKEwEwU6sxZQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t9jAd1LrHWBBhceCFpc+fqezaJ58Xo2
	i0n3J7BYbHp8jdXi8q45bA6sHvvnrmH3uN99nMlj85J6j74tqxg9Pm+SC2CNamC0yUhNTEkt
	UkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFarqRQlphTChQKSCwu
	VtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHMeNvby1rwlKPi8NLJbA2MS9i7GDk5JARMJH5+
	OAFli0lcuLeerYuRi0NIYBGjxKRDzcwQTheTxLXd51lBqtgEVCUmrrgPVMXBISJgI3Hhpj1I
	mFkgR2LJl5eMILawgJHEkT07mUFsFqDyJfsPg9m8Ai4S7afXs0IsU5D4dWQV6wRG7gWMDKsY
	RVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgsP/mfQOxlUNFocYBTgYlXh4AzbXBgqxJpYVV+Ye
	YpTgYFYS4Z19GyjEm5JYWZValB9fVJqTWnyIMRlo+0RmKdHkfGBs5pXEGxqbmBlZGpkbWhgZ
	m5MmrCTOe7DVOlBIID2xJDU7NbUgtQhmCxMHp1QD4+JnbuwN1pPW5d26o3a/xttkQ92hszei
	v85/7Tj5VceUufXO7Ko8cVoVi+4Jdr1T685OtrG58ZjzhPoktllnnh0JC53mffvEza/NTDIH
	P22327er9xbTpdf7vVcWrq9c+vvWtzSJN17PvaeySF+tUVqR6lSSsXvOnRvSa98Ima5eoZub
	95jLxV2JpTgj0VCLuag4EQCjmweuwwIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes mutiple defined issue to MODULE_DEVICE_TABLE

The issue could be induced when some framework which includes two
more sub drivers, is built as one moudle because those sub drivers
could have their own MODULE_DEVICE_TABLE.

And 'struct of_device_id' isn't needed to be determined by type
argument because the definition of 'of_device_id' should be fixed.
So this patch makes 'of_devce_id' definition to be fixed and
only its instance name to be defined by type.

Signed-off-by: Inki Dae <inki.dae@samsung.com>
---
 include/linux/module.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 46f1ea0..ac5d79f 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -84,7 +84,7 @@ void trim_init_extable(struct module *m);
 
 #ifdef MODULE
 #define MODULE_GENERIC_TABLE(gtype,name)			\
-extern const struct gtype##_id __mod_##gtype##_table		\
+extern const struct of_device_id __mod_##gtype##_table		\
   __attribute__ ((unused, alias(__stringify(name))))
 
 #else  /* !MODULE */
-- 
1.7.5.4

