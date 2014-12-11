Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758748AbaLKT3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 14:29:17 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:48370 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757271AbaLKT3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 14:29:15 -0500
Date: Thu, 11 Dec 2014 20:29:11 +0100
From: Djalal Harouni <tixxdz@opendz.org>
To: Marcel Mol <marcel@mesa.nl>
Cc: akpm@linux-foundation.org, adobriyan@gmail.com, ebiederm@xmission.com,
        oleg@redhat.com, luto@amacapital.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make /proc/<pid>/io world readable
Message-ID: <20141211192911.GA3080@dztty>
References: <20141211162228.GA10717@rim.emol.mesa.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141211162228.GA10717@rim.emol.mesa.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Dec 11, 2014 at 05:22:28PM +0100, Marcel Mol wrote:
> /proc/<pid>/io is only readable by the pid owner, while files
> like stat, statm and status are world readable.
> I see no reason why io statistics should be hidden.
> This patch makes io also world readable so process io counts
> can be analysed without root permissions.
As Andy noted this should be the other way around! so unless you have
a real usecase, this will revert previous patch by Vasiliy that closed
some info leaks...
https://lkml.org/lkml/2011/7/27/459

Thanks!

> Signed-off-by: Marcel Mol <marcel@mesa.nl>
> ---
>  fs/proc/base.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 772efa4..7bd8dbe 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -2563,7 +2563,7 @@ static const struct pid_entry tgid_base_stuff[] = {
>  	REG("coredump_filter", S_IRUGO|S_IWUSR, proc_coredump_filter_operations),
>  #endif
>  #ifdef CONFIG_TASK_IO_ACCOUNTING
> -	ONE("io",	S_IRUSR, proc_tgid_io_accounting),
> +	ONE("io",	S_IRUGO, proc_tgid_io_accounting),
>  #endif
>  #ifdef CONFIG_HARDWALL
>  	ONE("hardwall",   S_IRUGO, proc_pid_hardwall),
> @@ -2904,7 +2904,7 @@ static const struct pid_entry tid_base_stuff[] = {
>  	REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
>  #endif
>  #ifdef CONFIG_TASK_IO_ACCOUNTING
> -	ONE("io",	S_IRUSR, proc_tid_io_accounting),
> +	ONE("io",	S_IRUGO, proc_tid_io_accounting),
>  #endif
>  #ifdef CONFIG_HARDWALL
>  	ONE("hardwall",   S_IRUGO, proc_pid_hardwall),
> -- 
> 1.9.3
> 
> 

-- 
Djalal Harouni
http://opendz.org
