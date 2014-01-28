Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbaA1Mg4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 07:36:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754611AbaA1Mgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 07:36:54 -0500
Message-ID: <52E7A45C.3070302@redhat.com>
Date: Tue, 28 Jan 2014 20:36:44 +0800
From: Fu Wei <wefu@redhat.com>
Reply-To: Fu Wei <wefu@redhat.com>
Organization: Red Hat Software (Beijing) Co.,Ltd.Shanghai Branch
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Harry Wei <harryxiyou@gmail.com>
CC: Will Deacon <will.deacon@arm.com>,
        Greg-Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Doc ML <linux-doc@vger.kernel.org>
Subject: [PATCH]Documentation:Chinese translation of Documentation/arm64/tagged-pointers.txt
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a Chinese translated version of Documentation/arm64/tagged-pointers.txt

It is based on the modifications of Documentation/arm64/tagged-pointers.txt in submission:
"d50240a5", "374ed9d1".

Signed-off-by: Fu Wei <wefu@redhat.com>

---
diff --git a/Documentation/zh_CN/arm64/tagged-pointers.txt b/Documentation/zh_CN/arm64/tagged-pointers.txt
new file mode 100644
index 0000000..2664d1b
--- /dev/null
+++ b/Documentation/zh_CN/arm64/tagged-pointers.txt
@@ -0,0 +1,52 @@
+Chinese translated version of Documentation/arm64/tagged-pointers.txt
+
+If you have any comment or update to the content, please contact the
+original document maintainer directly.  However, if you have a problem
+communicating in English you can also ask the Chinese maintainer for
+help.  Contact the Chinese maintainer if this translation is outdated
+or if there is a problem with the translation.
+
+Maintainer: Will Deacon <will.deacon@arm.com>
+Chinese maintainer: Fu Wei <wefu@redhat.com>
+---------------------------------------------------------------------
+Documentation/arm64/tagged-pointers.txt 的中文翻译
+
+如果想评论或更新本文的内容，请直接联系原文档的维护者。如果你使用英文
+交流有困难的话，也可以向中文版维护者求助。如果本翻译更新不及时或者翻
+译存在问题，请联系中文版维护者。
+
+英文版维护者： Will Deacon <will.deacon@arm.com>
+中文版维护者： 傅炜  Fu Wei <wefu@redhat.com>
+中文版翻译者： 傅炜  Fu Wei <wefu@redhat.com>
+中文版校译者： 傅炜  Fu Wei <wefu@redhat.com>
+
+以下为正文
+---------------------------------------------------------------------
+		Linux 在 AArch64 中带标记的虚拟地址
+		=================================
+
+作者: Will Deacon <will.deacon@arm.com>
+日期: 2013 年 06 月 12 日
+
+本文档简述了在 AArch64 地址转换系统中提供的带标记的虚拟地址及其在
+AArch64 Linux 中的潜在用途。
+
+内核提供的地址转换表配置使通过 TTBR0 完成的虚拟地址转换（即用户空间
+映射），其虚拟地址的最高 8 位（63:56）会被转换硬件所忽略。这种机制
+让这些位可供应用程序自由使用，其注意事项如下：
+
+	(1) 内核要求所有传递到 EL1 的用户空间地址带有 0x00 标记。
+	    这意味着任何携带用户空间虚拟地址的系统调用（syscall）
+	    参数 *必须* 在陷入内核前使它们的最高字节被清零。
+
+	(2) 非零标记在传递信号时不被保存。这意味着在应用程序中利用了
+	    标记的信号处理函数无法依赖 siginfo_t 的用户空间虚拟
+	    地址所携带的包含其内部域信息的标记。此规则的一个例外是
+	    当信号是在调试观察点的异常处理程序中产生的，此时标记的
+	    信息将被保存。
+
+	(3) 当使用带标记的指针时需特别留心，因为仅对两个虚拟地址
+	    的高字节，C 编译器很可能无法判断它们是不同的。
+
+此构架会阻止对带标记的 PC 指针的利用，因此在异常返回时，其高字节
+将被设置成一个为 “55” 的扩展符。
