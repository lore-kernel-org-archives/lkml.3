Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670AbaJUDp7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 23:45:59 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:33591 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbaJUDp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 23:45:58 -0400
Message-ID: <5445D6F7.1000805@landley.net>
Date: Mon, 20 Oct 2014 22:45:59 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Josh Triplett <josh@joshtriplett.org>,
        Frank Rowand <frowand.list@gmail.com>, linux-kernel@vger.kernel.org,
        Chuck Ebbert <cebbert.lkml@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH] init: Remove CONFIG_INIT_FALLBACK
References: <20141020144448.59e2e067d632c70353296e56@linux-foundation.org> <a6b3d86db6f5d19f7130b8dba2703dda68cb14d5.1413842560.git.luto@amacapital.net>
In-Reply-To: <a6b3d86db6f5d19f7130b8dba2703dda68cb14d5.1413842560.git.luto@amacapital.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/14 17:04, Andy Lutomirski wrote:
> --- a/init/main.c
> +++ b/init/main.c
> @@ -960,13 +960,8 @@ static int __ref kernel_init(void *unused)
>  		ret = run_init_process(execute_command);
>  		if (!ret)
>  			return 0;
> -#ifndef CONFIG_INIT_FALLBACK
>  		panic("Requested init %s failed (error %d).",
>  		      execute_command, ret);
> -#else
> -		pr_err("Failed to execute %s (error %d).  Attempting defaults...\n",
> -		       execute_command, ret);
> -#endif
>  	}
>  	if (!try_to_run_init_process("/sbin/init") ||
>  	    !try_to_run_init_process("/etc/init") ||
> 

Would you like to remove the try_to_run_init_process() stack of random
hardwired names that we can never reach if we panic, or do you just want
to remove the error message?

Confused,

Rob
