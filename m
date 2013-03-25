Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758919Ab3CYVXH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 17:23:07 -0400
Received: from mail1.windriver.com ([147.11.146.13]:65383 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab3CYVXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 17:23:05 -0400
Message-ID: <5150C01A.3030602@windriver.com>
Date: Mon, 25 Mar 2013 16:22:34 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        <kgdb-bugreport@lists.sourceforge.net>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, Tim Bird <tim.bird@am.sony.com>
Subject: Re: [PATCH 03/15] KDB: up the default LINES value
References: <20130325185007.321022858@gulag1.americas.sgi.com> <20130325185007.776886654@gulag1.americas.sgi.com>
In-Reply-To: <20130325185007.776886654@gulag1.americas.sgi.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2013 01:50 PM, Mike Travis wrote:
> Currently the default for the # of lines displayed by the KDB pager
> is 24.  This does not allow all of the lines for the entry messages,
> reg dump and process trace.  Increase it to something more reasonable.
> 


Unfortunately this is something that breaks compatibility with the
standard VGA console, so this patch will not be merged.

Is it the case that your hardware specifies how many lines and columns
there are in the display?  We have some hooks into the console VT code
to properly detect this but perhaps something is wrong there, or it is
only called in the KMS (kernel mode setting case).  Example:
drivers/tty/vt/vt.c - look at con_debug_enter()

Another option might be to add a variable which allows you to change
the default at compile time, but I would prefer to get the auto detect
code working properly if it is an option.

Jason.



> Cc: Tim Bird <tim.bird@am.sony.com>
> Reviewed-by: Dimitri Sivanich <sivanich@sgi.com>
> Signed-off-by: Mike Travis <travis@sgi.com>
> ---
>  kernel/debug/kdb/kdb_io.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux.orig/kernel/debug/kdb/kdb_io.c
> +++ linux/kernel/debug/kdb/kdb_io.c
> @@ -586,7 +586,7 @@ int vkdb_printf(const char *fmt, va_list
>  
>  	diag = kdbgetintenv("LINES", &linecount);
>  	if (diag || linecount <= 1)
> -		linecount = 24;
> +		linecount = 60;
>  
>  	diag = kdbgetintenv("COLUMNS", &colcount);
>  	if (diag || colcount <= 1)
> 
> -- 
> 

