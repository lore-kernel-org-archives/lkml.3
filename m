Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122AbaA1MOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 07:14:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbaA1MOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 07:14:44 -0500
Message-ID: <52E79F25.9060902@redhat.com>
Date: Tue, 28 Jan 2014 20:14:29 +0800
From: Fu Wei <wefu@redhat.com>
Reply-To: Fu Wei <wefu@redhat.com>
Organization: Red Hat Software (Beijing) Co.,Ltd.Shanghai Branch
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Harry Wei <harryxiyou@gmail.com>
CC: Greg Kroah Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Doc ML <linux-doc@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Fu Wei <tekkamanninja@gmail.com>, Mark Salter <msalter@redhat.com>
Subject: [PATCH]Documentation:Update Documentation/zh_CN/arm64/memory.txt
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a update of Chinese documentation:Documentation/zh_CN/arm64/memory.txt

It is based on the modifications of Documentation/arm64/memory.txt in submission:
"2475ff9d", "847264fb", "aa4a73a0", "e29a074b".

Update maintainer's Email address.

Signed-off-by: Fu Wei <wefu@redhat.com>

---
diff --git a/Documentation/zh_CN/arm64/memory.txt b/Documentation/zh_CN/arm64/memory.txt
index a5f6283..a782704 100644
--- a/Documentation/zh_CN/arm64/memory.txt
+++ b/Documentation/zh_CN/arm64/memory.txt
@@ -7,7 +7,7 @@ help.  Contact the Chinese maintainer if this translation is outdated
 or if there is a problem with the translation.
 
 Maintainer: Catalin Marinas <catalin.marinas@arm.com>
-Chinese maintainer: Fu Wei <tekkamanninja@gmail.com>
+Chinese maintainer: Fu Wei <wefu@redhat.com>
 ---------------------------------------------------------------------
 Documentation/arm64/memory.txt 的中文翻译
 
@@ -16,9 +16,9 @@ Documentation/arm64/memory.txt 的中文翻译
 译存在问题，请联系中文版维护者。
 
 英文版维护者： Catalin Marinas <catalin.marinas@arm.com>
-中文版维护者： 傅炜  Fu Wei <tekkamanninja@gmail.com>
-中文版翻译者： 傅炜  Fu Wei <tekkamanninja@gmail.com>
-中文版校译者： 傅炜  Fu Wei <tekkamanninja@gmail.com>
+中文版维护者： 傅炜  Fu Wei <wefu@redhat.com>
+中文版翻译者： 傅炜  Fu Wei <wefu@redhat.com>
+中文版校译者： 傅炜  Fu Wei <wefu@redhat.com>
 
 以下为正文
 ---------------------------------------------------------------------
@@ -41,7 +41,7 @@ AArch64 Linux 使用页大小为 4KB 的 3 级转换表配置，对于用户和
 TTBR1 中，且从不写入 TTBR0。
 
 
-AArch64 Linux 内存布局：
+AArch64 Linux 在页大小为 4KB 时的内存布局：
 
 起始地址			结束地址			大小		用途
 -----------------------------------------------------------------------
@@ -55,15 +55,42 @@ ffffffbc00000000	ffffffbdffffffff	   8GB		vmemmap
 
 ffffffbe00000000	ffffffbffbbfffff	  ~8GB		[防护页，未来用于 vmmemap]
 
+ffffffbffbc00000	ffffffbffbdfffff	   2MB		earlyprintk 设备
+
 ffffffbffbe00000	ffffffbffbe0ffff	  64KB		PCI I/O 空间
 
-ffffffbbffff0000	ffffffbcffffffff	  ~2MB		[防护页]
+ffffffbffbe10000	ffffffbcffffffff	  ~2MB		[防护页]
 
 ffffffbffc000000	ffffffbfffffffff	  64MB		模块
 
 ffffffc000000000	ffffffffffffffff	 256GB		内核逻辑内存映射
 
 
+AArch64 Linux 在页大小为 64KB 时的内存布局：
+
+起始地址			结束地址			大小		用途
+-----------------------------------------------------------------------
+0000000000000000	000003ffffffffff	   4TB		用户空间
+
+fffffc0000000000	fffffdfbfffeffff	  ~2TB		vmalloc
+
+fffffdfbffff0000	fffffdfbffffffff	  64KB		[防护页]
+
+fffffdfc00000000	fffffdfdffffffff	   8GB		vmemmap
+
+fffffdfe00000000	fffffdfffbbfffff	  ~8GB		[防护页，未来用于 vmmemap]
+
+fffffdfffbc00000	fffffdfffbdfffff	   2MB		earlyprintk 设备
+
+fffffdfffbe00000	fffffdfffbe0ffff	  64KB		PCI I/O 空间
+
+fffffdfffbe10000	fffffdfffbffffff	  ~2MB		[防护页]
+
+fffffdfffc000000	fffffdffffffffff	  64MB		模块
+
+fffffe0000000000	ffffffffffffffff	   2TB		内核逻辑内存映射
+
+
 4KB 页大小的转换表查找：
 
 +--------+--------+--------+--------+--------+--------+--------+--------+
@@ -91,3 +118,10 @@ ffffffc000000000	ffffffffffffffff	 256GB		内核逻辑内存映射
  |                 |    +--------------------------> [41:29] L2 索引 (仅使用 38:29 )
  |                 +-------------------------------> [47:42] L1 索引 (未使用)
  +-------------------------------------------------> [63] TTBR0/1
+
+当使用 KVM 时, 管理程序（hypervisor）在 EL2 中通过相对内核虚拟地址的
+一个固定偏移来映射内核页（内核虚拟地址的高 24 位设为零）:
+
+起始地址			结束地址			大小		用途
+-----------------------------------------------------------------------
+0000004000000000	0000007fffffffff	 256GB		在 HYP 中映射的内核对象
