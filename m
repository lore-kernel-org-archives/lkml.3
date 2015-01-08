Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182AbbAHCdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 21:33:15 -0500
Received: from mail113-248.mail.alibaba.com ([205.204.113.248]:46685 "EHLO
	us-alimail-mta2.hst.scl.en.alidc.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755999AbbAHCdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 21:33:13 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;FP=0|-1|-1|-1|0|-1|-1|-1;HT=r46d02013;MF=hillf.zj@alibaba-inc.com;PH=DS;RN=11;RT=11;SR=0;
Reply-To: "Hillf Danton" <hillf.zj@alibaba-inc.com>
From: "Hillf Danton" <hillf.zj@alibaba-inc.com>
To: "'Wang Nan'" <wangnan0@huawei.com>
Cc: <linux@arm.linux.org.uk>, "'Ingo Molnar'" <mingo@redhat.com>,
        <masami.hiramatsu.pt@hitachi.com>, <anil.s.keshavamurthy@intel.com>,
        <davem@davemloft.net>, <ananth@in.ibm.com>, <dave.long@linaro.org>,
        <tixy@linaro.org>, <lizefan@huawei.com>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>
References: <043a01d02a5b$44ec45f0$cec4d1d0$@alibaba-inc.com> <54ACFFB6.3040102@huawei.com> <045301d02a60$ff36e8c0$fda4ba40$@alibaba-inc.com> <54AD0B98.5050103@huawei.com>
In-Reply-To: <54AD0B98.5050103@huawei.com>
Subject: RE: [RFC PATCH 09/11] kprobes: core logic of eraly kprobes
Date: Thu, 08 Jan 2015 10:32:14 +0800
Message-ID: <04d401d02aeb$50c519c0$f24f4d40$@alibaba-inc.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQIEtj9idETv8rQxsVvdEO6VYoonSQMUtq4iAfiAA8ICwu3jzZwN6KPA
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> This macro defines an array and a bitmap, not only declare them. In addition,
> the functions defined by it are used only in this specific .c file.
> 
> If there are not only one .c files use it, I think patch 7 can be improved:
> 
> #define DEFINE_EKPROBE_AREA(__t, __static)				\
> __static __t __ek_##__name##_slots[NR_EARLY_KPROBES_SLOTS];		\
> __static unsigned long __ek_##__name##_bitmap[EARLY_KPROBES_BITMAP_SZ];
> 
> #define DEFINE_EKPROBE_ALLOC_OPS(__t, __name, __static)			\
> DEFINE_EKPROBE_AREA(__t, __static)					\
> __DEFINE_EKPROBE_ALLOC_OPS(__t, __name)					\
> static inline __t *ek_alloc_##__name(void)				\
> {									\
> ...
> 
> In .h file(s):
> DEFINE_EKPROBE_ALLOC_OPS(struct early_kprobe_slot, early_kprobe, extern)
> 
> In .c file:
> DEFINE_EKPROBE_AREA(__t, )
> 
> What do you think?
>
Looks like rocket science;-)


