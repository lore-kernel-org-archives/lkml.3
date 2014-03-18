Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757765AbaCRTkF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 15:40:05 -0400
Received: from www.linutronix.de ([62.245.132.108]:56594 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757691AbaCRTkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 15:40:02 -0400
Date: Tue, 18 Mar 2014 20:40:10 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Marc Kleine-Budde <mkl@pengutronix.de>
cc: LKML <linux-kernel@vger.kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Markus Pargmann <mpa@pengutronix.de>,
        Benedikt Spranger <b.spranger@linutronix.de>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [patch 03/12] can: c_can: Make it SMP safe
In-Reply-To: <5328947F.7070902@pengutronix.de>
Message-ID: <alpine.DEB.2.02.1403182037580.18573@ionos.tec.linutronix.de>
References: <20140318171007.528610837@linutronix.de> <20140318171126.844179673@linutronix.de> <5328947F.7070902@pengutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2014, Marc Kleine-Budde wrote:

> On 03/18/2014 06:19 PM, Thomas Gleixner wrote:
> > The hardware has two message control interfaces, but the code only
> > uses the first one. So on SMP the following can be observed:
> > 
> > CPU0 	       	CPU1
> > rx_poll()
> >   write IF1	xmit()
> > 		write IF1
> >   write IF1			
> > 
> > That results in corrupted message object configurations. The TX/RX is
> > not globally serialized it's only serialized on a core.
> > 
> > Simple solution: Let RX use IF1 and TX use IF2 and all is good.
> 
> Do both c_can and d_can have two control interfaces?

According to the manual it has.

Thanks,

	tglx
