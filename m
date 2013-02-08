Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946160Ab3BHI6L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 03:58:11 -0500
Received: from TYO201.gate.nec.co.jp ([210.143.35.51]:46328 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946134Ab3BHI6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 03:58:10 -0500
X-Greylist: delayed 21871 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Feb 2013 03:58:10 EST
Date: Fri, 8 Feb 2013 17:49:44 +0900
From: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
To: mitsuhiro.tanino.gm@hitachi.com
Cc: vgoyal@redhat.com, kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com
Subject: Re: [PATCH 2/2 v2] kexec: Export PG_hwpoison flag into vmcoreinfo
Message-Id: <20130208174944.96a3b50952e45e1219a94819@mxc.nes.nec.co.jp>
In-Reply-To: <50913011.2030900@hitachi.com>
References: <508FDEF3.8030601@hitachi.com>
	<20121030143750.GF2290@redhat.com>
	<50913011.2030900@hitachi.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, 31 Oct 2012 23:05:05 +0900
Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com> wrote:

> This patch exports a PG_hwpoison into vmcoreinfo when
> CONFIG_MEMORY_FAILURE is defined.
> "makedumpfile" needs to read information of memory, such as
> 'mem_section', 'zone', 'pageflags' from vmcore.
> 
> We introduce a function into "makedumpfile" to exclude
> hwpoison page from vmcore dump.
> In order to introduce this function, PG_hwpoison flag have
> to export into vmcoreinfo.
> 
> Signed-off-by: Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com>

I'm curious to know the status of this patch because I'll release
makedumpfile-1.5.2 with the feature to exclude hwpoison page soon.


Thanks
Atsushi Kumagai

> ---
>  kernel/kexec.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index 0668d58..0d5d6bc 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -1513,6 +1513,9 @@ static int __init crash_save_vmcoreinfo_init(void)
>         VMCOREINFO_NUMBER(PG_lru);
>         VMCOREINFO_NUMBER(PG_private);
>         VMCOREINFO_NUMBER(PG_swapcache);
> +#ifdef CONFIG_MEMORY_FAILURE
> +       VMCOREINFO_NUMBER(PG_hwpoison);
> +#endif
> 
>         arch_crash_save_vmcoreinfo();
>         update_vmcoreinfo_note();
> --
> 1.7.10.1
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
