Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab3CABcA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 20:32:00 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:59949 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528Ab3CABb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 20:31:59 -0500
Date: Fri, 1 Mar 2013 10:31:56 +0900
From: Simon Horman <horms@verge.net.au>
To: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] kexec: fix wrong types of some local variables
Message-ID: <20130301013156.GA11434@verge.net.au>
References: <512C44E4.70907@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <512C44E4.70907@cn.fujitsu.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 01:15:16PM +0800, Zhang Yanfei wrote:
> The types of the following local variables:
>   - ubytes/mbytes in kimage_load_crash_segment()/kimage_load_normal_segment()
>   - r in vmcoreinfo_append_str()
> are wrong, so fix them.
> 
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Simon Horman <horms@verge.net.au>
> Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

No complaints here.

Reviewed-by: Simon Horman <horms@verge.net.au>

> ---
>  kernel/kexec.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index 2436ffc..3cbfcc7 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -789,7 +789,7 @@ static int kimage_load_normal_segment(struct kimage *image,
>  					 struct kexec_segment *segment)
>  {
>  	unsigned long maddr;
> -	unsigned long ubytes, mbytes;
> +	size_t ubytes, mbytes;
>  	int result;
>  	unsigned char __user *buf;
>  
> @@ -853,7 +853,7 @@ static int kimage_load_crash_segment(struct kimage *image,
>  	 * We do things a page at a time for the sake of kmap.
>  	 */
>  	unsigned long maddr;
> -	unsigned long ubytes, mbytes;
> +	size_t ubytes, mbytes;
>  	int result;
>  	unsigned char __user *buf;
>  
> @@ -1455,7 +1455,7 @@ void vmcoreinfo_append_str(const char *fmt, ...)
>  {
>  	va_list args;
>  	char buf[0x50];
> -	int r;
> +	size_t r;
>  
>  	va_start(args, fmt);
>  	r = vsnprintf(buf, sizeof(buf), fmt, args);
> -- 
> 1.7.1
> 
