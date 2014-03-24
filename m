Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbaCXH3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 03:29:51 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:58353 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750827AbaCXH3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 03:29:50 -0400
X-IronPort-AV: E=Sophos;i="4.97,719,1389740400"; 
   d="scan'208";a="64376360"
Date: Mon, 24 Mar 2014 08:29:48 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Thomas Gleixner <tglx@linutronix.de>
cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 00/16] timers: Plug debugobject leaks and use del_timer_sync()
 in exit/teardown
In-Reply-To: <alpine.DEB.2.02.1403240027020.18573@ionos.tec.linutronix.de>
Message-ID: <alpine.DEB.2.02.1403240828220.2211@localhost6.localdomain6>
References: <20140323150557.288925975@linutronix.de> <alpine.DEB.2.02.1403232328480.2019@localhost6.localdomain6> <alpine.DEB.2.02.1403240027020.18573@ionos.tec.linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Another thing I saw is 
> 
> 	del_timer(&bla->timer);
> 	....
> 	kfree(&bla);

In one case I saw the following:

        if (isac->dch.timer.function != NULL) {
                del_timer(&isac->dch.timer);
                isac->dch.timer.function = NULL;
        }
        kfree(isac->mon_rx);
        isac->mon_rx = NULL;

Is the assignment isac->dch.timer.function = NULL good enough to solve 
the problem?

julia
