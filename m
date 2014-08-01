Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248AbaHAUyz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 16:54:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37187 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756147AbaHAUyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 16:54:39 -0400
Date: Fri, 1 Aug 2014 13:54:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH v2 1/2] printk: Add function to return log buffer
 address and size
Message-Id: <20140801135437.8642de4a110e37a371619464@linux-foundation.org>
In-Reply-To: <20140731102920.27954.25076.stgit@hegdevasant.in.ibm.com>
References: <20140731102920.27954.25076.stgit@hegdevasant.in.ibm.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2014 16:00:06 +0530 Vasant Hegde <hegdevasant@linux.vnet.ibm.com> wrote:

> Platforms like IBM Power Systems supports service processor
> assisted dump. It provides interface to add memory region to
> be captured when system is crashed.
> 
> During initialization/running we can add kernel memory region
> to be collected.
> 
> Presently we don't have a way to get the log buffer base address
> and size. This patch adds support to return log buffer address
> and size.
> 
> ...
>
> --- a/include/linux/printk.h
> +++ b/include/linux/printk.h
> @@ -10,6 +10,9 @@
>  extern const char linux_banner[];
>  extern const char linux_proc_banner[];
>  
> +extern void *get_log_buf_addr(void);
> +extern u32 get_log_buf_len(void);
> +
>  static inline int printk_get_level(const char *buffer)
>  {
>  	if (buffer[0] == KERN_SOH_ASCII && buffer[1]) {
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index 13e839d..4049f7b 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -270,6 +270,18 @@ static char __log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
>  static char *log_buf = __log_buf;
>  static u32 log_buf_len = __LOG_BUF_LEN;
>  
> +/* Return log buffer address */
> +void *get_log_buf_addr(void)
> +{
> +	return log_buf;
> +}
> +
> +/* Return log buffer size */
> +u32 get_log_buf_len(void)
> +{
> +	return log_buf_len;
> +}
> +

This is the v1 patch.  The names are the same and get_log_buf_addr() still
returns void*.
