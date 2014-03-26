Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137AbaCZWCd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 18:02:33 -0400
Received: from www.linutronix.de ([62.245.132.108]:35114 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755227AbaCZWCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 18:02:31 -0400
Date: Wed, 26 Mar 2014 23:02:36 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Julia Lawall <Julia.Lawall@lip6.fr>,
        "David S. Miller" <davem@davemloft.net>,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] atm: replace del_timer by del_timer_sync
In-Reply-To: <1395871015.12610.254.camel@edumazet-glaptop2.roam.corp.google.com>
Message-ID: <alpine.DEB.2.02.1403262301171.31401@ionos.tec.linutronix.de>
References: <1395869625-15209-1-git-send-email-Julia.Lawall@lip6.fr>  <1395869625-15209-3-git-send-email-Julia.Lawall@lip6.fr> <1395871015.12610.254.camel@edumazet-glaptop2.roam.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2014, Eric Dumazet wrote:
> On Wed, 2014-03-26 at 22:33 +0100, Julia Lawall wrote:
> > From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> > 
> > diff --git a/net/atm/mpc.c b/net/atm/mpc.c
> > index b71ff6b..91dc58f 100644
> > --- a/net/atm/mpc.c
> > +++ b/net/atm/mpc.c
> > @@ -1492,7 +1492,7 @@ static void __exit atm_mpoa_cleanup(void)
> >  
> >  	mpc_proc_clean();
> >  
> > -	del_timer(&mpc_timer);
> > +	del_timer_sync(&mpc_timer);
> >  	unregister_netdevice_notifier(&mpoa_notifier);
> >  	deregister_atm_ioctl(&atm_ioctl_ops);
> >  
> 
> It seems this timer rearms itself, so this patch wont be enough I fear.

That's why you need del_timer_sync() it waits for the timer handler to
complete and then removes it.

Thanks,

	tglx

