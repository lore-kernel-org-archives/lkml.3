Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbaCXGWw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 02:22:52 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:36899 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbaCXGWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 02:22:50 -0400
Date: Mon, 24 Mar 2014 07:22:45 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Julia Lawall <Julia.Lawall@lip6.fr>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ursula Braun <ursula.braun@de.ibm.com>,
        s390 <linux-s390@vger.kernel.org>
Subject: Re: [patch 03/16] s390: net: lcs: Add missing
 destroy_timer_on_stack()
Message-ID: <20140324062245.GD4487@osiris>
References: <20140323150557.288925975@linutronix.de>
 <20140323150752.843705144@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140323150752.843705144@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032406-3548-0000-0000-0000087D606A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 23, 2014 at 03:09:25PM -0000, Thomas Gleixner wrote:
> Otherwise we leak a tracking object when DEBUG_OBJECTS is enabled.


>  drivers/s390/net/lcs.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: tip/drivers/s390/net/lcs.c
> ===================================================================
> --- tip.orig/drivers/s390/net/lcs.c
> +++ tip/drivers/s390/net/lcs.c
> @@ -899,6 +899,7 @@ lcs_send_lancmd(struct lcs_card *card, s
>  	add_timer(&timer);
>  	wait_event(reply->wait_q, reply->received);
>  	del_timer_sync(&timer);
> +	destroy_timer_on_stack(&timer);

Applied, thanks.

