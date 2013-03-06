Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab3CFTav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 14:30:51 -0500
Received: from casper.infradead.org ([85.118.1.10]:55128 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532Ab3CFTat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 14:30:49 -0500
Message-ID: <51379986.4080800@infradead.org>
Date: Wed, 06 Mar 2013 11:31:18 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] sysrq: allow user trigger sysrq by upper-case character
 key
References: <5136C106.40308@huawei.com>
In-Reply-To: <5136C106.40308@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/13 20:07, zhangwei(Jovi) wrote:
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

Since the sysrq_key_table[] is basically full and we don't have a path (plan)
for how to expand it, would it be reasonable to map upper case characters
to different functions from their corresponding lower case characters,
or is that just too confusing?

The help text can be fixed:

SysRq: HELP : loglevel(0-9) reboot(b) crash(c) terminate-all-tasks(e)
memory-full-oom-kill(f) kill-all-tasks(i) ...


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
> 


-- 
~Randy
