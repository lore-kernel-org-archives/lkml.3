Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbaHKBNv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 21:13:51 -0400
Received: from gate.crashing.org ([63.228.1.57]:41767 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734AbaHKBNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 21:13:50 -0400
Message-ID: <1407719612.4508.52.camel@pasglop>
Subject: Re: [PATCH v3 1/2] printk: Add function to return log buffer
 address and size
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date: Mon, 11 Aug 2014 11:13:32 +1000
In-Reply-To: <20140809054424.17676.1090.stgit@hegdevasant.in.ibm.com>
References: <20140809054424.17676.1090.stgit@hegdevasant.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-08-09 at 11:15 +0530, Vasant Hegde wrote:

> Ben,
>   - This patchset applies cleanly on powerpc next branch.
>   - Andrew Morton suggested to include this patch in powerpc tree.
>     (https://lists.ozlabs.org/pipermail/linuxppc-dev/2014-August/119802.html)
> 

Ok, Andrew, can I have an Ack ?

Cheers,
Ben.

>  include/linux/printk.h |    3 +++
>  kernel/printk/printk.c |   12 ++++++++++++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/include/linux/printk.h b/include/linux/printk.h
> index 319ff7e..b8c0316 100644
> --- a/include/linux/printk.h
> +++ b/include/linux/printk.h
> @@ -10,6 +10,9 @@
>  extern const char linux_banner[];
>  extern const char linux_proc_banner[];
>  
> +extern char *log_buf_addr_get(void);
> +extern u32 log_buf_len_get(void);
> +
>  static inline int printk_get_level(const char *buffer)
>  {
>  	if (buffer[0] == KERN_SOH_ASCII && buffer[1]) {
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index ea2d5f6..d6a984c 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -270,6 +270,18 @@ static char __log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
>  static char *log_buf = __log_buf;
>  static u32 log_buf_len = __LOG_BUF_LEN;
>  
> +/* Return log buffer address */
> +char *log_buf_addr_get(void)
> +{
> +	return log_buf;
> +}
> +
> +/* Return log buffer size */
> +u32 log_buf_len_get(void)
> +{
> +	return log_buf_len;
> +}
> +
>  /* human readable text of the record */
>  static char *log_text(const struct printk_log *msg)
>  {


