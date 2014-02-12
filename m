Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbaBLQZi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 11:25:38 -0500
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:12087 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752918AbaBLQZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 11:25:35 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqITAD+f+1JXQAka/2dsb2JhbABaKIJkwDMCAoETF3SCJQEBBAE6HCMFCwgDDgouOR4GE4d9DAHJWReOeQeEOAEDiUaEeIlrAYpPh1KDOi8
Date: Wed, 12 Feb 2014 16:26:53 +0800
From: Fabian Frederick <fabf@skynet.be>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, rdunlap <rdunlap@infradead.org>
Subject: Re: [PATCH 1/1] kernel: panic: display reason at end + pr_emerg
Message-Id: <20140212162653.19dcded1d0249ce48c997db9@skynet.be>
In-Reply-To: <20140211153445.c03bf3b266880ff0a174cee6@linux-foundation.org>
References: <20140208154522.aa927a34df7b018c5eee47ef@skynet.be>
	<20140211153445.c03bf3b266880ff0a174cee6@linux-foundation.org>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Feb 2014 15:34:45 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sat, 8 Feb 2014 15:45:22 +0800 Fabian Frederick <fabf@skynet.be> wrote:
> 
> > Currently, booting without initrd specified on 80x25 screen
> > gives a call trace followed by atkbd : Spurious ACK.
> > Original message ("VFS: Unable to mount root fs") is not available.
> > Of course this could happen in other situations...
> > 
> > -This patch displays panic reason after call trace which could help
> > lot of people even if it's not the very last line on screen.
> 
> Fair enough.  Hate it when that happens!
I was sure I was not the only one :)

> 
> > -Converting all panic.c printk(KERN_EMERG to pr_emerg(
> 
> You missed a couple.
Thanks a lot for addition and patch fix.
What a pleasure to see such professionalism !

> 
> --- a/kernel/panic.c~kernel-panicc-display-reason-at-end-pr_emerg-fix
> +++ a/kernel/panic.c
> @@ -275,8 +275,7 @@ unsigned long get_taint(void)
>  void add_taint(unsigned flag, enum lockdep_ok lockdep_ok)
>  {
>  	if (lockdep_ok == LOCKDEP_NOW_UNRELIABLE && __debug_locks_off())
> -		printk(KERN_WARNING
> -		       "Disabling lock debugging due to kernel taint\n");
> +		pr_warn("Disabling lock debugging due to kernel taint\n");
>  
>  	set_bit(flag, &tainted_mask);
>  }
> @@ -381,8 +380,7 @@ late_initcall(init_oops_id);
>  void print_oops_end_marker(void)
>  {
>  	init_oops_id();
> -	printk(KERN_WARNING "---[ end trace %016llx ]---\n",
> -		(unsigned long long)oops_id);
> +	pr_warn("---[ end trace %016llx ]---\n", (unsigned long long)oops_id);
>  }
>  
>  /*
> _
> 
