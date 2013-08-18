Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab3HRJFU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 05:05:20 -0400
Received: from www.linutronix.de ([62.245.132.108]:44488 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab3HRJFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 05:05:18 -0400
Date: Sun, 18 Aug 2013 11:05:03 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Fan Du <fan.du@windriver.com>
cc: Steffen Klassert <steffen.klassert@secunet.com>,
        David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Daniel Borkmann <dborkman@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCHv3 linux-next] hrtimer: Add notifier when clock_was_set
 was called
In-Reply-To: <520B4552.2000607@windriver.com>
Message-ID: <alpine.DEB.2.02.1308181102230.4089@ionos.tec.linutronix.de>
References: <1375866296-15079-1-git-send-email-fan.du@windriver.com> <1375866296-15079-2-git-send-email-fan.du@windriver.com> <52021177.6020306@redhat.com> <520213F2.5090401@windriver.com> <520214C6.6000307@redhat.com> <520B4552.2000607@windriver.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Aug 2013, Fan Du wrote:

> From e3929d4fdfad5b40fd8cad0e217597670d1aef54 Mon Sep 17 00:00:00 2001
> From: Fan Du <fan.du@windriver.com>
> Date: Wed, 14 Aug 2013 16:39:23 +0800
> Subject: [PATCHv3 linux-next] hrtimer: Add notifier when clock_was_set was
> called
> 
> When clock_was_set is called in case of system wall time change
> or host resume from suspend state, use this notifier for places
> where interested in this action, e.g Ipsec SA lifetime management.

Sigh. These notifiers have been proposed in the past and we always
rejected them. Why do you need this? There should be nothing except
the core timekeeping code which needs to know about clock_was_set.

Can you please explain what kind of users you have in mind and WHY
they need to know about it.

Thanks,

	tglx
