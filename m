Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbaBXOs6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 09:48:58 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:8886 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461AbaBXOs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 09:48:57 -0500
X-IronPort-AV: E=Sophos;i="4.97,535,1389744000"; 
   d="scan'208";a="103549747"
Message-ID: <530B5BD6.2000301@citrix.com>
Date: Mon, 24 Feb 2014 14:48:54 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Xen <xen-devel@lists.xenproject.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Xen-devel] [patch 23/26] xen: Add proper irq accounting for
 HYPERCALL vector
References: <20140223212703.511977310@linutronix.de> <20140223212738.808648133@linutronix.de>
In-Reply-To: <20140223212738.808648133@linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/02/14 21:40, Thomas Gleixner wrote:
> --- tip.orig/drivers/xen/events/events_base.c
> +++ tip/drivers/xen/events/events_base.c
> @@ -1239,6 +1239,7 @@ void xen_evtchn_do_upcall(struct pt_regs
>  #ifdef CONFIG_X86
>  	exit_idle();
>  #endif
> +	inc_irq_stat(irq_hv_callback_count);
>  
>  	__xen_evtchn_do_upcall();

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

David
