Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796AbaBRSkH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 13:40:07 -0500
Received: from www.linutronix.de ([62.245.132.108]:44888 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbaBRSkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 13:40:06 -0500
Date: Tue, 18 Feb 2014 19:40:10 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Preeti Murthy <preeti.lkml@gmail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: Re: [GIT Pull] timer fixes for 3.14
In-Reply-To: <CAM4v1pNDbiC54Ot6J2Tpc9t4BgT3fY7jgZkb6Fem4OfedwvV-w@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1402181938140.4468@ionos.tec.linutronix.de>
References: <alpine.DEB.2.02.1402152005210.21991@ionos.tec.linutronix.de> <CAM4v1pNDbiC54Ot6J2Tpc9t4BgT3fY7jgZkb6Fem4OfedwvV-w@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Feb 2014, Preeti Murthy wrote:

> Hi Thomas,
> 
> With regard to the patch: "tick: Clear broadcast pending bit when
> switching to oneshot"
> isn't BROADCAST_EXIT called atleast after initializing the high
> resolution timers while
> handling the broadcast IPI and before re-entering idle? This should
> clear the cpu bit
> in the pending mask right?
> 
> idle()
> |__BROADCAST_ENTER
>     |__halt()
>       |__broadcast_ipi
>           |__init_highres()->clear oneshot mask
>               |__return from interrupt->BROADCAST_EXIT (clear pending mask)

Unfortunately not:

     if (cpumask_test_and_clear_cpu(cpu, tick_broadcast_oneshot_mask)) {
     	  clear pending mask;
     }

>                    |__re-enter idle

Go figure :)
 
Thanks,

	tglx
