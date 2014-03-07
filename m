Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbaCGVZR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 16:25:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44055 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbaCGVZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 16:25:15 -0500
Date: Fri, 7 Mar 2014 13:25:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Liu ShuoX <shuox.liu@intel.com>
Cc: Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>, Colin Cross <ccross@android.com>,
        Anton Vorontsov <anton@enomsg.org>, yanmin_zhang@linux.intel.com
Subject: Re: [PATCH] pstore: reset ftrace_read_cnt at ramoops_pstore_open
Message-Id: <20140307132514.b6c596879f78478cad190e65@linux-foundation.org>
In-Reply-To: <20140307025842.GA6435@lskakaxi-intel>
References: <1393569464-14904-1-git-send-email-shuox.liu@intel.com>
	<CAGXu5jLFq-FqXsw4SWuhE-JPzCCecvMdUHbF0_B=S-GODFU1pg@mail.gmail.com>
	<20140304014002.GA10071@lskakaxi-intel>
	<CAGXu5j+5CXKJ7+vaWgZXVJgFGHFzcwO6-D1iE+wyDcpr+g8jdw@mail.gmail.com>
	<20140307025842.GA6435@lskakaxi-intel>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Mar 2014 10:58:43 +0800 Liu ShuoX <shuox.liu@intel.com> wrote:

> 
> ftrace_read_cnt need to be reset in open to support mutli times
> getting the records.
> 
> Signed-off-by: Liu ShuoX <shuox.liu@intel.com>
> ---
>   fs/pstore/ram.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
> index fa8cef2..9fe5b13 100644
> --- a/fs/pstore/ram.c
> +++ b/fs/pstore/ram.c
> @@ -86,6 +86,7 @@ struct ramoops_context {
>   	struct persistent_ram_ecc_info ecc_info;
>   	unsigned int max_dump_cnt;
>   	unsigned int dump_write_cnt;
> +	/* _read_cnt need clear on ramoops_pstore_open */
>   	unsigned int dump_read_cnt;
>   	unsigned int console_read_cnt;
>   	unsigned int ftrace_read_cnt;
> @@ -101,6 +102,7 @@ static int ramoops_pstore_open(struct pstore_info *psi)
>   
>   	cxt->dump_read_cnt = 0;
>   	cxt->console_read_cnt = 0;
> +	cxt->ftrace_read_cnt = 0;
>   	return 0;
>   }
>   
> @@ -428,7 +430,6 @@ static int ramoops_probe(struct platform_device *pdev)
>   	if (pdata->ftrace_size && !is_power_of_2(pdata->ftrace_size))
>   		pdata->ftrace_size = rounddown_pow_of_two(pdata->ftrace_size);
>   
> -	cxt->dump_read_cnt = 0;
>   	cxt->size = pdata->mem_size;
>   	cxt->phys_addr = pdata->mem_address;
>   	cxt->record_size = pdata->record_size;

The dump_read_cnt changes appear to be unrelated to the actual bugfix?

If so, please send this along as a separate patch.  With a full
changelog - this one doesn't explain the dump_read_cnt changes at all.

