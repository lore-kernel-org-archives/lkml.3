Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418Ab3EaMZO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:25:14 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:61608 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756350Ab3EaMZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:25:05 -0400
MIME-Version: 1.0
In-Reply-To: <1369993501-24309-1-git-send-email-srinivas.kandagatla@st.com>
References: <1369993439-24216-1-git-send-email-srinivas.kandagatla@st.com> <1369993501-24309-1-git-send-email-srinivas.kandagatla@st.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 31 May 2013 20:24:43 +0800
Message-ID: <CAGsJ_4z65+SOCQM2XKmrda+5Hu9wRuZviSvW3As1ROa0SmdXqw@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] ARM:prima2: move sirfsoc_of_rstc_init to .init_early
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: Barry Song <baohua.song@csr.com>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/5/31 Srinivas KANDAGATLA <srinivas.kandagatla@st.com>:
> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
>
> This patch moves sirfsoc_of_rstc_init from early_initcall to .init_early
> in machine descriptor, doing this way a multi_v7 kernel will not crash
> on non-prima2 SOCs.
>
> Without this patch the multi_v7 kernel panics if we boot it on any non
> prima2 parts with below log:
>
> Kernel panic - not syncing: unable to find compatible rstc node in dtb
>
> CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.0-rc3-00535-gc3cc4ac #62
> [<c001387c>] (unwind_backtrace+0x0/0xf8) from [<c00111cc>]
> (show_stack+0x10/0x14)
> [<c00111cc>] (show_stack+0x10/0x14) from [<c03417f4>] (panic+0x90/0x1e4)
> [<c03417f4>] (panic+0x90/0x1e4) from [<c04256d0>]
> (sirfsoc_of_rstc_init+0x24/0x5c)
> [<c04256d0>] (sirfsoc_of_rstc_init+0x24/0x5c) from [<c041f854>]
> (do_one_initcall+0x90/0x150)
> [<c041f854>] (do_one_initcall+0x90/0x150) from [<c041f978>]
> (kernel_init_freeable+0x64/0x1c4)
> [<c041f978>] (kernel_init_freeable+0x64/0x1c4) from [<c033d344>]
> (kernel_init+0x8/0xe4)
> [<c033d344>] (kernel_init+0x8/0xe4) from [<c000ded8>]
> (ret_from_fork+0x14/0x3c)
>
> Initially detected when booting Stih415 SOC with multi_v7_defconfig.
>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>

hi Sriniva,
i think my "arm: prima2: move to generic reset controller driver
framework" fixs this too:
http://www.spinics.net/lists/arm-kernel/msg246206.html

Arnd, will you ack that one so that i will send a pull request with that.

-barry
