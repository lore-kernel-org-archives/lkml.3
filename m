Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964876AbaD2OZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 10:25:11 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:57509 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932284AbaD2OZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 10:25:08 -0400
Date: Tue, 29 Apr 2014 10:25:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, <stable-rt@vger.kernel.org>
Subject: Re: [PATCH RT 2/4] net: gianfar: do not try to cleanup TX packets
 if they are not done
Message-ID: <20140429102505.1d52f93c@gandalf.local.home>
In-Reply-To: <535FB453.2060100@windriver.com>
References: <20140427143119.898655303@goodmis.org>
	<20140427143140.384915886@goodmis.org>
	<535DF744.60606@linutronix.de>
	<535FB453.2060100@windriver.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2014 10:16:51 -0400
Paul Gortmaker <paul.gortmaker@windriver.com> wrote:

 
> Sanity boot tested the 3.10 rc1 on a sbc8548 (UP PPC with gianfar), with
> the one-liner added as follows:
> 
> diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
> index 8aecc1d81395..b87a8c919c3e 100644
> --- a/drivers/net/ethernet/freescale/gianfar.c
> +++ b/drivers/net/ethernet/freescale/gianfar.c
> @@ -2574,6 +2574,7 @@ static int gfar_clean_tx_ring(struct gfar_priv_tx_q *tx_queue)
>         tx_queue->dirty_tx = bdp;
>  
>         netdev_tx_completed_queue(txq, howmany, bytes_sent);
> +       return howmany;

That's the change I added to 3.10-rc2. I'll post it soon if you want to
test it.

-- Steve

>  }
>  
>  static void gfar_schedule_cleanup(struct gfar_priv_grp *gfargrp)
