Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbaCCTqC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 14:46:02 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:50383 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590AbaCCTqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 14:46:00 -0500
MIME-Version: 1.0
In-Reply-To: <1393569464-14904-1-git-send-email-shuox.liu@intel.com>
References: <1393569464-14904-1-git-send-email-shuox.liu@intel.com>
Date: Mon, 3 Mar 2014 11:45:59 -0800
X-Google-Sender-Auth: T4B6KEB0rgMOHKbEt3RRkpYxC-c
Message-ID: <CAGXu5jLFq-FqXsw4SWuhE-JPzCCecvMdUHbF0_B=S-GODFU1pg@mail.gmail.com>
Subject: Re: [PATCH] pstore: reset ftrace_read_cnt at ramoops_pstore_open
From: Kees Cook <keescook@chromium.org>
To: shuox.liu@intel.com
Cc: LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Colin Cross <ccross@android.com>, Anton Vorontsov <anton@enomsg.org>,
        yanmin_zhang@linux.intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 10:37 PM,  <shuox.liu@intel.com> wrote:
> From: Liu ShuoX <shuox.liu@intel.com>
>
> ftrace_read_cnt need to be reset in open to support mutli times
> getting the records.
>
> Signed-off-by: Liu ShuoX <shuox.liu@intel.com>
> ---
>  fs/pstore/ram.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
> index fa8cef2..a5d0cab 100644
> --- a/fs/pstore/ram.c
> +++ b/fs/pstore/ram.c
> @@ -101,6 +101,7 @@ static int ramoops_pstore_open(struct pstore_info *psi)
>
>         cxt->dump_read_cnt = 0;
>         cxt->console_read_cnt = 0;
> +       cxt->ftrace_read_cnt = 0;
>         return 0;
>  }

I think we need a separate function for "clear" for the
ramoops_context struct. IIUC, we're missing a similar initialization
in ramoops_probe, which lacks both console_read_cnt=0 and
ftrace_read_cnt=0. Then both places could call this?

-Kees

-- 
Kees Cook
Chrome OS Security
