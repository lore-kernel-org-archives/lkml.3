Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbaCaCRs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 22:17:48 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:34784 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbaCaCRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 22:17:47 -0400
Message-ID: <5338D037.5090207@huawei.com>
Date: Mon, 31 Mar 2014 10:17:27 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jovi Zhangwei <jovi.zhangwei@gmail.com>
CC: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v2 16/29] ktap: add amalgamation build(kernel/trace/ktap/amalg.c)
References: <1396017924-7754-1-git-send-email-jovi.zhangwei@gmail.com> <1396017924-7754-17-git-send-email-jovi.zhangwei@gmail.com>
In-Reply-To: <1396017924-7754-17-git-send-email-jovi.zhangwei@gmail.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/3/28 22:45, Jovi Zhangwei wrote:
> This compiles the ktapvm as one huge C file and allows
> GCC to generate faster and shorter code.
> 
> No amalgamation build in x86_64:
> ktapvm.ko: 3.1M
> 
> amalgamation build in x86_64:
> ktapvm.ko: 1.1M
> 
> User can set use amalgamation build or not in Makefile.
> 
> (Need to analyze further why have so big differences)
> 

Let's drop this patch for now to make the patchset smaller ?

> Signed-off-by: Jovi Zhangwei <jovi.zhangwei@gmail.com>
> ---
>  kernel/trace/ktap/amalg.c | 37 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
>  create mode 100644 kernel/trace/ktap/amalg.c
> 
> diff --git a/kernel/trace/ktap/amalg.c b/kernel/trace/ktap/amalg.c
> new file mode 100644
> index 0000000..9935ccf
> --- /dev/null
> +++ b/kernel/trace/ktap/amalg.c
> @@ -0,0 +1,37 @@
> +/*
> + * amalg.c - ktapvm kernel module amalgamation.
> + *
> + * This file is part of ktap by Jovi Zhangwei.
> + *
> + * Copyright (C) 2012-2014 Jovi Zhangwei <jovi.zhangwei@gmail.com>.
> + *
> + * ktap is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * ktap is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program; if not, write to the Free Software Foundation, Inc.,
> + * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
> + */
> +
> +#include "ktap.c"
> +#include "kp_obj.c"
> +#include "kp_bcread.c"
> +#include "kp_str.c"
> +#include "kp_mempool.c"
> +#include "kp_tab.c"
> +#include "kp_transport.c"
> +#include "kp_vm.c"
> +#include "kp_events.c"
> +#include "lib_base.c"
> +#include "lib_ansi.c"
> +#include "lib_kdebug.c"
> +#include "lib_timer.c"
> +#include "lib_table.c"
> +#include "lib_net.c"
> +
> 

