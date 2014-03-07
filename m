Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbaCGXq5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 18:46:57 -0500
Received: from r00tworld.com ([212.85.137.150]:52966 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577AbaCGXq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 18:46:56 -0500
X-Greylist: delayed 2992 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Mar 2014 18:46:56 EST
From: "PaX Team" <pageexec@freemail.hu>
To: khali@linux-fr.org, rostedt@goodmis.org, behanw@converseincode.com
Date: Fri, 07 Mar 2014 23:56:04 +0100
MIME-Version: 1.0
Subject: Re: [PATCH] module: LLVMLinux: Remove unused function warning from __param_check macro
Reply-to: pageexec@freemail.hu
CC: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org, dwmw2@infradead.org,
        Mark Charlebois <charlebm@gmail.com>,
        Behan Webster <behanw@converseincode.com>
Message-ID: <531A4E84.9996.3260AF06@pageexec.freemail.hu>
In-reply-to: <1394219327-5591-1-git-send-email-behanw@converseincode.com>
References: <1394219327-5591-1-git-send-email-behanw@converseincode.com>
X-mailer: Pegasus Mail for Windows (4.63)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.150]); Fri, 07 Mar 2014 23:56:06 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 Mar 2014 at 11:08, behanw@converseincode.com wrote:

> diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
> index c3eb102..5ce1f67 100644
> --- a/include/linux/moduleparam.h
> +++ b/include/linux/moduleparam.h
> @@ -346,6 +346,7 @@ static inline void destroy_params(const struct kernel_param *params,
>  /* The macros to do compile-time type checking stolen from Jakub
>     Jelinek, who IIRC came up with this idea for the 2.4 module init code. */
>  #define __param_check(name, p, type) \
> +	static inline type *__check_##name(void) __attribute__ ((unused)); \
>  	static inline type *__check_##name(void) { return(p); }

why can't you have the attr on the definition itself:

static inline __unused type *__check_##name(void) { return(p); }



