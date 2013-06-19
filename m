Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965097Ab3FSSrc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:47:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40344 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964978Ab3FSSrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:47:24 -0400
Message-ID: <51C1FCA7.6050501@zytor.com>
Date: Wed, 19 Jun 2013 13:47:03 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        joe@perches.com, trivial@kernel.org, tglx@linutronix.de
CC: tip-bot for Joe Perches <tipbot@zytor.com>,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/asm] x86/vdso: Convert use of typedef ctl_table to struct
 ctl_table
References: <a756fa0060e8eea25e8c1863c2764e86c2823617.1371177118.git.joe@perches.com> <tip-f07d91ede6f346cbe31bb814cefe2584940b96f3@git.kernel.org>
In-Reply-To: <tip-f07d91ede6f346cbe31bb814cefe2584940b96f3@git.kernel.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shouldn't this actually remove the typedef?

	-hpa

On 06/19/2013 01:43 PM, tip-bot for Joe Perches wrote:
> Commit-ID:  f07d91ede6f346cbe31bb814cefe2584940b96f3
> Gitweb:     http://git.kernel.org/tip/f07d91ede6f346cbe31bb814cefe2584940b96f3
> Author:     Joe Perches <joe@perches.com>
> AuthorDate: Thu, 13 Jun 2013 19:37:33 -0700
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Wed, 19 Jun 2013 15:06:09 +0200
> 
> x86/vdso: Convert use of typedef ctl_table to struct ctl_table
> 
> This typedef is unnecessary and should just be removed.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> Cc: Jiri Kosina <trivial@kernel.org>
> Link: http://lkml.kernel.org/r/a756fa0060e8eea25e8c1863c2764e86c2823617.1371177118.git.joe@perches.com
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> ---
>  arch/x86/vdso/vdso32-setup.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
> index 0faad64..d6bfb87 100644
> --- a/arch/x86/vdso/vdso32-setup.c
> +++ b/arch/x86/vdso/vdso32-setup.c
> @@ -372,7 +372,7 @@ subsys_initcall(sysenter_setup);
>  /* Register vsyscall32 into the ABI table */
>  #include <linux/sysctl.h>
>  
> -static ctl_table abi_table2[] = {
> +static struct ctl_table abi_table2[] = {
>  	{
>  		.procname	= "vsyscall32",
>  		.data		= &sysctl_vsyscall32,
> @@ -383,7 +383,7 @@ static ctl_table abi_table2[] = {
>  	{}
>  };
>  
> -static ctl_table abi_root_table2[] = {
> +static struct ctl_table abi_root_table2[] = {
>  	{
>  		.procname = "abi",
>  		.mode = 0555,
> 

