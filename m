Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab3FGTu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 15:50:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6097 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab3FGTu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 15:50:26 -0400
X-Authority-Analysis: v=2.0 cv=BcJaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=1zmUxmkzHqYA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=870DaT8apj8A:10 a=i0EeH86SAAAA:8 a=PbuX-FOqpHMND3aeZCIA:9 a=QEXdDO2ut3YA:10 a=hPjdaMEvmhQA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1370634624.9844.93.camel@gandalf.local.home>
Subject: Re: [PATCH] ftrace: Remove ftrace_regex_lseek()
From: Steven Rostedt <rostedt@goodmis.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 07 Jun 2013 15:50:24 -0400
In-Reply-To: <51B1A1BD.40905@huawei.com>
References: <51B1A1BD.40905@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-07 at 17:02 +0800, Li Zefan wrote:
> This is a leftover after ftrace_regex_lseek() was renamed to
> ftrace_filter_lseek() and then ftrace_filter_lseek() was moved
> out side of CONFIG_DYNAMIC_FTRACE.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Thanks! I queued this up for 3.11, as it's not important enough for a
later -rc release.

-- Steve

> ---
>  include/linux/ftrace.h | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index 99d0fbc..e48ed1d 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -566,10 +566,6 @@ static inline ssize_t ftrace_filter_write(struct file *file, const char __user *
>  			    size_t cnt, loff_t *ppos) { return -ENODEV; }
>  static inline ssize_t ftrace_notrace_write(struct file *file, const char __user *ubuf,
>  			     size_t cnt, loff_t *ppos) { return -ENODEV; }
> -static inline loff_t ftrace_regex_lseek(struct file *file, loff_t offset, int whence)
> -{
> -	return -ENODEV;
> -}
>  static inline int
>  ftrace_regex_release(struct inode *inode, struct file *file) { return -ENODEV; }
>  #endif /* CONFIG_DYNAMIC_FTRACE */


