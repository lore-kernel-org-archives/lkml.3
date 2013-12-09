Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933326Ab3LILR1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 06:17:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49135 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932599Ab3LILR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 06:17:26 -0500
Date: Mon, 9 Dec 2013 03:19:00 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Ethan Zhao <ethan.kernel@gmail.com>
Cc: konrad.wilk@oracle.com, raghavendra.kt@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] xen/debugfs: Check debugfs initialization before
 using it
Message-ID: <20131209111900.GC6562@kroah.com>
References: <1386583012-506-1-git-send-email-ethan.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386583012-506-1-git-send-email-ethan.kernel@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 05:56:52PM +0800, Ethan Zhao wrote:
> From: "ethan.zhao" <ethan.kernel@gmail.com>
> 
> Should check debugfs initialization with debugfs_initialized() before using it,
> Because if it isn't initialized, the return value of fake debugfs_create_dir() etc
> functions would be ERR_PTR(-ENODEV), checking with NULL will not work.
> 
> V3: add warning message when debugfs not configured or disabled.

That's not what this patch does...

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
> +	if (!debugfs_initialized()) {
> +		d_xen_debug = NULL;
> +		goto nodebugfs;
> +	}

Again, why is this even needed?

What problem in the existing code are you trying to solve?

