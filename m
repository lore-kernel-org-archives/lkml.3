Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbaLRLoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 06:44:12 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:41874 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbaLRLoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 06:44:10 -0500
Message-ID: <5492BE01.7040705@hitachi.com>
Date: Thu, 18 Dec 2014 20:44:01 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Seth Jennings <sjenning@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.cz>, Miroslav Benes <mbenes@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>, live-patching@vger.kernel.org,
        x86@kernel.org, kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv7 1/3] kernel: add TAINT_LIVEPATCH
References: <1418752700-14649-1-git-send-email-sjenning@redhat.com> <1418752700-14649-2-git-send-email-sjenning@redhat.com>
In-Reply-To: <1418752700-14649-2-git-send-email-sjenning@redhat.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/12/17 2:58), Seth Jennings wrote:
> This adds a new taint flag to indicate when the kernel or a kernel
> module has been live patched.  This will provide a clean indication in
> bug reports that live patching was used.
> 
> Additionally, if the crash occurs in a live patched function, the live
> patch module will appear beside the patched function in the backtrace.
> 
> Signed-off-by: Seth Jennings <sjenning@redhat.com>

Looks good to me.

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thanks!

> ---
>  Documentation/oops-tracing.txt  | 2 ++
>  Documentation/sysctl/kernel.txt | 1 +
>  include/linux/kernel.h          | 1 +
>  kernel/panic.c                  | 2 ++
>  4 files changed, 6 insertions(+)
> 
> diff --git a/Documentation/oops-tracing.txt b/Documentation/oops-tracing.txt
> index beefb9f..f3ac05c 100644
> --- a/Documentation/oops-tracing.txt
> +++ b/Documentation/oops-tracing.txt
> @@ -270,6 +270,8 @@ characters, each representing a particular tainted value.
>  
>   15: 'L' if a soft lockup has previously occurred on the system.
>  
> + 16: 'K' if the kernel has been live patched.
> +
>  The primary reason for the 'Tainted: ' string is to tell kernel
>  debuggers if this is a clean kernel or if anything unusual has
>  occurred.  Tainting is permanent: even if an offending module is
> diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
> index 75511ef..83ab256 100644
> --- a/Documentation/sysctl/kernel.txt
> +++ b/Documentation/sysctl/kernel.txt
> @@ -843,6 +843,7 @@ can be ORed together:
>  8192 - An unsigned module has been loaded in a kernel supporting module
>         signature.
>  16384 - A soft lockup has previously occurred on the system.
> +32768 - The kernel has been live patched.
>  
>  ==============================================================
>  
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 5449d2f..d03e3de 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -471,6 +471,7 @@ extern enum system_states {
>  #define TAINT_OOT_MODULE		12
>  #define TAINT_UNSIGNED_MODULE		13
>  #define TAINT_SOFTLOCKUP		14
> +#define TAINT_LIVEPATCH			15
>  
>  extern const char hex_asc[];
>  #define hex_asc_lo(x)	hex_asc[((x) & 0x0f)]
> diff --git a/kernel/panic.c b/kernel/panic.c
> index 4d8d6f9..8136ad7 100644
> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -226,6 +226,7 @@ static const struct tnt tnts[] = {
>  	{ TAINT_OOT_MODULE,		'O', ' ' },
>  	{ TAINT_UNSIGNED_MODULE,	'E', ' ' },
>  	{ TAINT_SOFTLOCKUP,		'L', ' ' },
> +	{ TAINT_LIVEPATCH,		'K', ' ' },
>  };
>  
>  /**
> @@ -246,6 +247,7 @@ static const struct tnt tnts[] = {
>   *  'O' - Out-of-tree module has been loaded.
>   *  'E' - Unsigned module has been loaded.
>   *  'L' - A soft lockup has previously occurred.
> + *  'K' - Kernel has been live patched.
>   *
>   *	The string is overwritten by the next call to print_tainted().
>   */
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


