Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760993Ab3LIJ7j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 04:59:39 -0500
Received: from mail-ve0-f174.google.com ([209.85.128.174]:52357 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760903Ab3LIJ7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 04:59:38 -0500
MIME-Version: 1.0
In-Reply-To: <1386583012-506-1-git-send-email-ethan.kernel@gmail.com>
References: <1386583012-506-1-git-send-email-ethan.kernel@gmail.com>
Date: Mon, 9 Dec 2013 17:59:37 +0800
Message-ID: <CABawtvMZYZE8fhD6hDw-LmT6rnTxextWg5unvZcxN=gO836Xrw@mail.gmail.com>
Subject: Re: [PATCH v3] xen/debugfs: Check debugfs initialization before using it
From: Ethan Zhao <ethan.kernel@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>, konrad.wilk@oracle.com,
        raghavendra.kt@linux.vnet.ibm.com
Cc: LKML <linux-kernel@vger.kernel.org>, "ethan.zhao" <ethan.kernel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

    How about the V3 ?


Thanks,
Ethan

On Mon, Dec 9, 2013 at 5:56 PM, Ethan Zhao <ethan.kernel@gmail.com> wrote:
> From: "ethan.zhao" <ethan.kernel@gmail.com>
>
> Should check debugfs initialization with debugfs_initialized() before using it,
> Because if it isn't initialized, the return value of fake debugfs_create_dir() etc
> functions would be ERR_PTR(-ENODEV), checking with NULL will not work.
>
> V3: add warning message when debugfs not configured or disabled.
>
> Signed-off-by: ethan.zhao <ethan.kernel@gmail.com>
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
