Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751348AbaLQFhE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 00:37:04 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:56700 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbaLQFhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 00:37:03 -0500
Message-ID: <54911665.3070601@huawei.com>
Date: Wed, 17 Dec 2014 13:36:37 +0800
From: Wang Nan <wangnan0@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: <tixy@linaro.org>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        <lizefan@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v16 1/8] ARM: probes: move all probe code to dedicate
 directory
References: <1418292276-75255-1-git-send-email-wangnan0@huawei.com> <1418292276-75255-2-git-send-email-wangnan0@huawei.com> <548AC8BD.5090602@hitachi.com>
In-Reply-To: <548AC8BD.5090602@hitachi.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.90]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

Could you please collect this patch and merge it into your repository first? Due
to this is a source tree layout modification, others may work on original files
and experiences unneed conflicts.

Thank you.

On 2014/12/12 18:51, Masami Hiramatsu wrote:
> (2014/12/11 19:04), Wang Nan wrote:
>> In discussion on LKML (https://lkml.org/lkml/2014/11/28/158), Russell
>> King suggests to move all probe related code to arch/arm/probes. This
>> patch does the work. Due to dependency on 'arch/arm/kernel/patch.h', this
>> patch also moves patch.h to 'arch/arm/include/asm/patch.h', and related
>> '#include' directives are also midified to '#include <asm/patch.h>'.
>>
>> Following is an overview of this patch:
>>
>>  ./arch/arm/kernel/               ./arch/arm/probes/
>>  |-- Makefile                     |-- Makefile
>>  |-- probes-arm.c          ==>    |-- decode-arm.c
>>  |-- probes-arm.h          ==>    |-- decode-arm.h
>>  |-- probes-thumb.c        ==>    |-- decode-thumb.c
>>  |-- probes-thumb.h        ==>    |-- decode-thumb.h
>>  |-- probes.c              ==>    |-- decode.c
>>  |-- probes.h              ==>    |-- decode.h
>>  |                                |-- kprobes
>>  |                                |   |-- Makefile
>>  |-- kprobes-arm.c         ==>    |   |-- actions-arm.c
>>  |-- kprobes-common.c      ==>    |   |-- actions-common.c
>>  |-- kprobes-thumb.c       ==>    |   |-- actions-thumb.c
>>  |-- kprobes.c             ==>    |   |-- core.c
>>  |-- kprobes.h             ==>    |   |-- core.h
>>  |-- kprobes-test-arm.c    ==>    |   |-- test-arm.c
>>  |-- kprobes-test.c        ==>    |   |-- test-core.c
>>  |-- kprobes-test.h        ==>    |   |-- test-core.h
>>  |-- kprobes-test-thumb.c  ==>    |   `-- test-thumb.c
>>  |                                `-- uprobes
>>  |                                    |-- Makefile
>>  |-- uprobes-arm.c         ==>        |-- actions-arm.c
>>  |-- uprobes.c             ==>        |-- core.c
>>  |-- uprobes.h             ==>        `-- core.h
>>  |
>>  `-- patch.h               ==>    arch/arm/include/asm/patch.h
>>
>> Signed-off-by: Wang Nan <wangnan0@huawei.com>
> 
> It looks good to me :)
> 
> Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> 
> Thanks!
> 





