Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912AbbAIC3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 21:29:17 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:2875 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbbAIC3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 21:29:14 -0500
Message-ID: <54AF3CDF.9000004@huawei.com>
Date: Fri, 9 Jan 2015 10:28:47 +0800
From: Wang Nan <wangnan0@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: <masami.hiramatsu.pt@hitachi.com>, <tixy@linaro.org>,
        <linux@arm.linux.org.uk>
CC: <lizefan@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v19 01/11] ARM: probes: move all probe code to dedicate
 directory
References: <1420457284-76923-1-git-send-email-wangnan0@huawei.com> <1420457350-77053-1-git-send-email-wangnan0@huawei.com>
In-Reply-To: <1420457350-77053-1-git-send-email-wangnan0@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.90]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/5 19:29, Wang Nan wrote:
> In discussion on LKML (https://lkml.org/lkml/2014/11/28/158), Russell
> King suggests to move all probe related code to arch/arm/probes. This
> patch does the work. Due to dependency on 'arch/arm/kernel/patch.h', this
> patch also moves patch.h to 'arch/arm/include/asm/patch.h', and related
> '#include' directives are also midified to '#include <asm/patch.h>'.
> 
> Following is an overview of this patch:
> 
>  ./arch/arm/kernel/               ./arch/arm/probes/
>  |-- Makefile                     |-- Makefile
>  |-- probes-arm.c          ==>    |-- decode-arm.c
>  |-- probes-arm.h          ==>    |-- decode-arm.h
>  |-- probes-thumb.c        ==>    |-- decode-thumb.c
>  |-- probes-thumb.h        ==>    |-- decode-thumb.h
>  |-- probes.c              ==>    |-- decode.c
>  |-- probes.h              ==>    |-- decode.h
>  |                                |-- kprobes
>  |                                |   |-- Makefile
>  |-- kprobes-arm.c         ==>    |   |-- actions-arm.c
>  |-- kprobes-common.c      ==>    |   |-- actions-common.c
>  |-- kprobes-thumb.c       ==>    |   |-- actions-thumb.c
>  |-- kprobes.c             ==>    |   |-- core.c
>  |-- kprobes.h             ==>    |   |-- core.h
>  |-- kprobes-test-arm.c    ==>    |   |-- test-arm.c
>  |-- kprobes-test.c        ==>    |   |-- test-core.c
>  |-- kprobes-test.h        ==>    |   |-- test-core.h
>  |-- kprobes-test-thumb.c  ==>    |   `-- test-thumb.c
>  |                                `-- uprobes
>  |                                    |-- Makefile
>  |-- uprobes-arm.c         ==>        |-- actions-arm.c
>  |-- uprobes.c             ==>        |-- core.c
>  |-- uprobes.h             ==>        `-- core.h
>  |
>  `-- patch.h               ==>    arch/arm/include/asm/patch.h
> 
> Signed-off-by: Wang Nan <wangnan0@huawei.com>
> Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Hi,

Thanks to Tixy and his test robot, a bug is found in this patch: I forgot to change
arch/arm/kernel/kgdb.c, which also includes patch.h. A small code modification
is required.

I have posted a new version of this patch by replying.

Tixy, could you please collect it into your git repository and help me test it
again?

http://lists.infradead.org/pipermail/linux-arm-kernel/2015-January/314520.html

Thanks.


