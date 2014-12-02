Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303AbaLBE7Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 23:59:16 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:34406 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbaLBE7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 23:59:15 -0500
Message-ID: <547D471B.2070908@hitachi.com>
Date: Tue, 02 Dec 2014 13:59:07 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Wang Nan <wangnan0@huawei.com>
Cc: tixy@linaro.org, linux@arm.linux.org.uk, lizefan@huawei.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v11 1/7] ARM: probes: move all probe code to dedicate
 directory
References: <1417423513-47161-1-git-send-email-wangnan0@huawei.com> <1417423695-47521-1-git-send-email-wangnan0@huawei.com>
In-Reply-To: <1417423695-47521-1-git-send-email-wangnan0@huawei.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/12/01 17:48), Wang Nan wrote:
> In discussion on LKML (https://lkml.org/lkml/2014/11/28/158), Russell
> King suggest to move all probe related code to arch/arm/probes. This
> patch do the work. Due to dependency on 'arch/arm/kernel/patch.h', this
> patch also move patch.h to 'arch/arm/include/asm/patch.h', and related
> '#include' directive are also midified to '#include <asm/patch.h>'.

Moving is good to me, but renaming files are also required I think.

> Signed-off-by: Wang Nan <wangnan0@huawei.com>
> ---
>  arch/arm/Makefile                                |  1 +
>  arch/arm/{kernel => include/asm}/patch.h         |  0
>  arch/arm/kernel/Makefile                         | 16 ++--------------
>  arch/arm/kernel/jump_label.c                     |  2 +-
>  arch/arm/kernel/patch.c                          |  3 +--
>  arch/arm/probes/Makefile                         | 15 +++++++++++++++
>  arch/arm/{kernel => probes}/kprobes-arm.c        |  0
>  arch/arm/{kernel => probes}/kprobes-common.c     |  0
>  arch/arm/{kernel => probes}/kprobes-test-arm.c   |  0
>  arch/arm/{kernel => probes}/kprobes-test-thumb.c |  0
>  arch/arm/{kernel => probes}/kprobes-test.c       |  0
>  arch/arm/{kernel => probes}/kprobes-test.h       |  0
>  arch/arm/{kernel => probes}/kprobes-thumb.c      |  0
>  arch/arm/{kernel => probes}/kprobes.c            |  2 +-
>  arch/arm/{kernel => probes}/kprobes.h            |  0
>  arch/arm/{kernel => probes}/probes-arm.c         |  0
>  arch/arm/{kernel => probes}/probes-arm.h         |  0
>  arch/arm/{kernel => probes}/probes-thumb.c       |  0
>  arch/arm/{kernel => probes}/probes-thumb.h       |  0
>  arch/arm/{kernel => probes}/probes.c             |  0
>  arch/arm/{kernel => probes}/probes.h             |  0
>  arch/arm/{kernel => probes}/uprobes-arm.c        |  0
>  arch/arm/{kernel => probes}/uprobes.c            |  0
>  arch/arm/{kernel => probes}/uprobes.h            |  0

As I did on x86, these would be better renamed as expressing what they do.
I guess most of the files may have emulate-*.c or decode-*.c :)

Thank you,



-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


