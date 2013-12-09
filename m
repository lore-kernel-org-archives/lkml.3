Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760888Ab3LIJ6g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 04:58:36 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:55511 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449Ab3LIJ6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 04:58:34 -0500
MIME-Version: 1.0
In-Reply-To: <1386582175-377-1-git-send-email-ethan.kernel@gmail.com>
References: <1386582175-377-1-git-send-email-ethan.kernel@gmail.com>
Date: Mon, 9 Dec 2013 17:58:33 +0800
Message-ID: <CABawtvN+LMcxSZyME-sqAJLcWo_ZvHzuVaHvt9jP90gQ8OJM1A@mail.gmail.com>
Subject: Re: [PATCH v2] xen/debugfs: Check debugfs initialization before using it
From: Ethan Zhao <ethan.kernel@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>, konrad.wilk@oracle.com,
        raghavendra.kt@linux.vnet.ibm.com
Cc: LKML <linux-kernel@vger.kernel.org>, Ethan Zhao <ethan.kernel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All,
  Please ignore this one, sorry, see v3.


Thanks,
Ethan

On Mon, Dec 9, 2013 at 5:42 PM, Ethan Zhao <ethan.kernel@gmail.com> wrote:
> From: "Ethan Zhao" <ethan.kernel@gmail.com>
>
> Should check debugfs initialization with debugfs_initialized() before using it,
> Because if it isn't initialized, the return value of fake debugfs_create_dir() etc
> functions would be ERR_PTR(-ENODEV), checking with NULL will not work.
>
> V2: change to normative author name.
>
> Signed-off-by: Ethan Zhao <ethan.kernel@gmail.com>
> ---
>  arch/x86/xen/debugfs.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/arch/x86/xen/debugfs.c b/arch/x86/xen/debugfs.c
> index c8377fb..85c0e0e 100644
> --- a/arch/x86/xen/debugfs.c
> +++ b/arch/x86/xen/debugfs.c
> @@ -9,12 +9,18 @@ static struct dentry *d_xen_debug;
>
>  struct dentry * __init xen_init_debugfs(void)
>  {
> +       if (!debugfs_initialized()) {
> +               d_xen_debug = NULL;
> +               goto nodebugfs;
> +       }
> +
>         if (!d_xen_debug) {
>                 d_xen_debug = debugfs_create_dir("xen", NULL);
>
>                 if (!d_xen_debug)
>                         pr_warning("Could not create 'xen' debugfs directory\n");
>         }
> +nodebugfs:
>
>         return d_xen_debug;
>  }
> --
> 1.8.3.4 (Apple Git-47)
>
