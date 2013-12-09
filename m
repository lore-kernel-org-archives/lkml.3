Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933045Ab3LILQo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 06:16:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49130 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932387Ab3LILQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 06:16:43 -0500
Date: Mon, 9 Dec 2013 03:18:17 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Ethan Zhao <ethan.kernel@gmail.com>
Cc: konrad.wilk@oracle.com, raghavendra.kt@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xen/debugfs: Check debugfs initialization before using it
Message-ID: <20131209111817.GB6562@kroah.com>
References: <1386583443-568-1-git-send-email-ethan.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386583443-568-1-git-send-email-ethan.kernel@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 06:04:03PM +0800, Ethan Zhao wrote:
> From: "Ethan Zhao" <ethan.kernel@gmail.com>
> 
> Should check debugfs initialization with debugfs_initialized() before using it,
> Because if it isn't initialized, the return value of fake debugfs_create_dir() etc
> functions would be ERR_PTR(-ENODEV), checking with NULL will not work.
> 
> V3: Add warning message about debugfs not configured or disabled. 
> 
> Signed-off-by: Ethan Zhao <ethan.kernel@gmail.com>
> ---
>  arch/x86/xen/debugfs.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/x86/xen/debugfs.c b/arch/x86/xen/debugfs.c
> index c8377fb..033a5dd 100644
> --- a/arch/x86/xen/debugfs.c
> +++ b/arch/x86/xen/debugfs.c
> @@ -9,12 +9,19 @@ static struct dentry *d_xen_debug;
>  
>  struct dentry * __init xen_init_debugfs(void)
>  {
> +	if (!debugfs_initialized()) {
> +		d_xen_debug = NULL;
> +		pr_warning("debugfs is not configured or enabled\n");

No, again, don't say anything, this is useless, just leave the code
as-is, it isn't causing any problems, is it?

gre gk-h
