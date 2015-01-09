Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbbAIGvq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 01:51:46 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:32456 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbbAIGvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 01:51:45 -0500
Message-ID: <54AF7A79.20500@huawei.com>
Date: Fri, 9 Jan 2015 14:51:37 +0800
From: Wang Nan <wangnan0@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: <masami.hiramatsu.pt@hitachi.com>, <tixy@linaro.org>,
        <linux@arm.linux.org.uk>
CC: <lizefan@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v19 08/11] ARM: kprobes: enable OPTPROBES for ARM 32
References: <1420457284-76923-1-git-send-email-wangnan0@huawei.com> <1420457376-77366-1-git-send-email-wangnan0@huawei.com>
In-Reply-To: <1420457376-77366-1-git-send-email-wangnan0@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.90]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020205.54AF7A87.0103,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 3880913c2de46d35530972a079e31d9d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tixy and other,

Similar to patch 01/11, build robot found a building error in this patch when ARM version
is lower than 4. In such processors 'blx' instruction is unusable.

I have posted a new version of this patch, which has following code change:

diff --git a/arch/arm/probes/kprobes/opt-arm.c b/arch/arm/probes/kprobes/opt-arm.c
index 6a60df3..cb47eff 100644
--- a/arch/arm/probes/kprobes/opt-arm.c
+++ b/arch/arm/probes/kprobes/opt-arm.c
@@ -58,7 +58,12 @@ asm (
 			 */
 			"	and	r4, sp, #4\n"
 			"	sub	sp, sp, r4\n"
+#if __LINUX_ARM_ARCH__ >= 5
 			"	blx	r2\n"
+#else
+			"	mov     lr, pc\n"
+			"	bx	r2\n"
+#endif
 			"	add	sp, sp, r4\n"
 			"	ldr	r1, [sp, #64]\n"
 			"	tst	r1, #"__stringify(PSR_T_BIT)"\n"

http://lists.infradead.org/pipermail/linux-arm-kernel/2015-January/314542.html

Tixy, could you please collect it into your repository and test again?

Thank you!

