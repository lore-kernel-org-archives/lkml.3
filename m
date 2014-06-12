Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192AbaFLTEI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 15:04:08 -0400
Received: from smtprelay0129.hostedemail.com ([216.40.44.129]:37040 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751181AbaFLTEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 15:04:05 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3867:3868:3871:4321:4605:5007:7652:10004:10400:10848:11026:11658:11914:12043:12296:12438:12517:12519:12740:13019:13972:14093:14097,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: shake99_7ac3ffd8deb50
X-Filterd-Recvd-Size: 2916
Message-ID: <1402599841.12385.20.camel@joe-AO725>
Subject: Re: [PATCH 1/1] kernel/debug/debug_core.c: Logging clean-up
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Jason Wessel <jason.wessel@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 12 Jun 2014 12:04:01 -0700
In-Reply-To: <1402598918-5729-1-git-send-email-fabf@skynet.be>
References: <1402598918-5729-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-12 at 20:48 +0200, Fabian Frederick wrote:
> -Convert printk( to pr_foo()
> -Add pr_fmt
> -Coalesce formats

Might as well add missing newlines
and maybe remove unnecessary periods.

> diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
[]
> @@ -196,8 +199,8 @@ int __weak kgdb_validate_break_address(unsigned long addr)
>  		return err;
>  	err = kgdb_arch_remove_breakpoint(&tmp);
>  	if (err)
> -		printk(KERN_ERR "KGDB: Critical breakpoint error, kernel "
> -		   "memory destroyed at: %lx", addr);
> +		pr_err("Critical breakpoint error, kernel memory destroyed at: %lx",
> +		       addr);

Add '\n' newline

[]

> @@ -256,8 +259,8 @@ int dbg_activate_sw_breakpoints(void)
>  		error = kgdb_arch_set_breakpoint(&kgdb_break[i]);
>  		if (error) {
>  			ret = error;
> -			printk(KERN_INFO "KGDB: BP install failed: %lx",
> -			       kgdb_break[i].bpt_addr);
> +			pr_info("BP install failed: %lx",
> +				kgdb_break[i].bpt_addr);

here too



> @@ -964,8 +966,7 @@ int kgdb_register_io_module(struct kgdb_io *new_dbg_io_ops)
>  	if (dbg_io_ops) {
>  		spin_unlock(&kgdb_registration_lock);
>  
> -		printk(KERN_ERR "kgdb: Another I/O driver is already "
> -				"registered with KGDB.\n");
> +		pr_err("Another I/O driver is already registered with KGDB.\n");

Maybe remove period

		pr_err("Another I/O driver is already registered with KGDB\n");

> @@ -981,8 +982,7 @@ int kgdb_register_io_module(struct kgdb_io *new_dbg_io_ops)
>  
>  	spin_unlock(&kgdb_registration_lock);
>  
> -	printk(KERN_INFO "kgdb: Registered I/O driver %s.\n",
> -	       new_dbg_io_ops->name);
> +	pr_info("Registered I/O driver %s.\n", new_dbg_io_ops->name);

here too

> @@ -1017,8 +1017,7 @@ void kgdb_unregister_io_module(struct kgdb_io *old_dbg_io_ops)
>  
>  	spin_unlock(&kgdb_registration_lock);
>  
> -	printk(KERN_INFO
> -		"kgdb: Unregistered I/O driver %s, debugger disabled.\n",
> +	pr_info("Unregistered I/O driver %s, debugger disabled.\n",
>  		old_dbg_io_ops->name);

and here


