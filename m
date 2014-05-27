Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062AbaE0Soc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 14:44:32 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:38090 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751911AbaE0Sob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 14:44:31 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmoVAGnThFNXQD00/2dsb2JhbABZDoJ5qy8BAQEBAQUBgzyUTAICAYENF3SCJgEFJxMcIxAIAxQyOR4GE4hGAdUzF4VViH0HhEABA5lyAYsXiBCCeEI7
Date: Tue, 27 May 2014 20:44:33 +0200
From: Fabian Frederick <fabf@skynet.be>
To: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix busted pr_info conversion in kernel/workqueue.c
Message-Id: <20140527204433.e22e1cca95d2b4a5dac5f960@skynet.be>
In-Reply-To: <14251.1401215339@turing-police.cc.vt.edu>
References: <14251.1401215339@turing-police.cc.vt.edu>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Valdis,

	I thought Tejun directly reverted that patch (Joe Perches noticed
 the level problem just after submit).Anyway, problem is solved now :)

Thanks,
Fabian

On Tue, 27 May 2014 14:28:59 -0400
Valdis Kletnieks <Valdis.Kletnieks@vt.edu> wrote:

> (resend - first attempt ate the To: line)
> 
> commit 2d916033a318d7e763eb099c69600d5dcd1ccb6b
> Author: Fabian Frederick <fabf@skynet.be>
> Date:   Mon May 12 13:59:35 2014 -0400
> 
>     kernel/workqueue.c: pr_warning/pr_warn & printk/pr_info
> 
> This commit did an incorrect printk->pr_info conversion. If we were
> converting to pr_info() we should lose the log_level parameter. The problem is
> that this is called (indirectly) by show_regs_print_info(), which is called
> with various log_levels (from _INFO clear to _EMERG). So we leave it as
> a printk() call so the desired log_level is applied.
> 
> Not a full revert, as the other half of the patch is correct.
> 
> Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
> 
> --- linux-next/kernel/workqueue.c.dist	2014-05-26 11:18:40.155380772 -0400
> +++ linux-next/kernel/workqueue.c	2014-05-27 12:07:51.464678172 -0400
> @@ -4440,7 +4440,7 @@ void print_worker_info(const char *log_l
>  		probe_kernel_read(desc, worker->desc, sizeof(desc) - 1);
>  
>  	if (fn || name[0] || desc[0]) {
> -		pr_info("%sWorkqueue: %s %pf", log_lvl, name, fn);
> +		printk("%sWorkqueue: %s %pf", log_lvl, name, fn);
>  		if (desc[0])
>  			pr_cont(" (%s)", desc);
>  		pr_cont("\n");
> 
> 
