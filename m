Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795Ab3CFVjX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 16:39:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48087 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab3CFVjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 16:39:22 -0500
Date: Wed, 6 Mar 2013 13:39:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] sysrq: allow user trigger sysrq by upper-case character
 key
Message-Id: <20130306133921.62b9cc38beca2145269c0182@linux-foundation.org>
In-Reply-To: <5136C106.40308@huawei.com>
References: <5136C106.40308@huawei.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Mar 2013 12:07:34 +0800 "zhangwei(Jovi)" <jovi.zhangwei@huawei.com> wrote:

> See the help text output of /proc/sysrq-trigger:
> 
>    SysRq : HELP : loglevel(0-9) reBoot Crash terminate-all-tasks(E)
>    memory-full-oom-kill(F) kill-all-tasks(I) ...
> 
> Most command is referenced by responding upper-case character,
> this would hint user can trigger sysrq by upper-case character key,
> but that's wrong, sysrq only accept lower-case character currently.
> 
> It's reasonable to let user trigger sysrq by upper-case character key.
> 
> Signed-off-by: zhnagwei(Jovi) <jovi.zhangwei@huawei.com>
> ---
>  drivers/tty/sysrq.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
> index 3687f0c..a88908e 100644
> --- a/drivers/tty/sysrq.c
> +++ b/drivers/tty/sysrq.c
> @@ -471,6 +471,8 @@ static int sysrq_key_table_key2index(int key)
>  		retval = key - '0';
>  	else if ((key >= 'a') && (key <= 'z'))
>  		retval = key + 10 - 'a';
> +	else if ((key >= 'A') && (key <= 'Z'))
> +		retval = key + 10 - 'A';
>  	else
>  		retval = -1;
>  	return retval;

Then fix the help message ;)

We're already using 19 of the 26 letters and this change would rule out
future use of the 26 upper-case letters.

I doubt if anyone is hurting from the inconsistent help message, really.
