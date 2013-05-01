Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309Ab3EAO6n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 10:58:43 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:17260 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306Ab3EAO6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 10:58:36 -0400
Date: Wed, 1 May 2013 10:58:10 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: ard@telegraafnet.nl, akpm@linux-foundation.org, hpa@zytor.com,
        len.brown@intel.com, linux-kernel@vger.kernel.org, mchehab@redhat.com,
        rjw@sisk.pl
Subject: Re: initcall ffh_cstate_init+0x0/0x2a returned with error code -1
 throws WARN
Message-ID: <20130501145810.GC6614@phenom.dumpdata.com>
References: <20130501134814.GA5001@phenom.dumpdata.com>
 <1367417381.30667.78.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367417381.30667.78.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 01, 2013 at 10:09:41AM -0400, Steven Rostedt wrote:
> On Wed, 2013-05-01 at 09:48 -0400, Konrad Rzeszutek Wilk wrote:
> > Now with the git commit f91eb62f71b31e69e405663ff8d047bc3b9f7525
> > (init: scream bloody murder if interrupts are enabled too early)
> 
> Perhaps I got a little too aggressive with that patch. The warnings look
> to be caused by:
> 
> @@ -702,9 +697,7 @@ int __init_or_module do_one_initcall(initcall_t fn)
>                 strlcat(msgbuf, "disabled interrupts ", sizeof(msgbuf));
>                 local_irq_enable();
>         }
> -       if (msgbuf[0]) {
> -               printk("initcall %pF returned with %s\n", fn, msgbuf);
> -       }
> +       WARN(msgbuf[0], "initcall %pF returned with %s\n", fn, msgbuf);
>  
>         return ret;
>  }
> 
> I'll just revert that part of the patch, and send that in.

Thank you!
> 
> Thanks,
> 
> -- Steve
> 
> 
> 
