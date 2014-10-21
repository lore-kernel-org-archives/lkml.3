Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124AbaJUK2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 06:28:24 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:41061 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835AbaJUK2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 06:28:22 -0400
Message-ID: <1413887300.23173.14.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: RCU stall in af_unix.c, should use spin_lock_irqsave?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexandre FOURNIER <alexandre.fournier@wisp-e.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Gregory =?ISO-8859-1?Q?Cl=E9ment?= 
	<gregory.clement@free-electrons.com>
Date: Tue, 21 Oct 2014 03:28:20 -0700
In-Reply-To: <20141021121011.53686d5f@free-electrons.com>
References: <20141021100313.397f4962@free-electrons.com>
	 <1413885874.23173.11.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20141021121011.53686d5f@free-electrons.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-21 at 12:10 +0200, Thomas Petazzoni wrote:

> Ok. So it's actually safe to mix spin_lock() and spin_lock_irqsave() on
> the same lock, if you know that this lock will never ever be taken in
> an interrupt context?

Sure.

> 
> > mvpp2 is seriously brain damaged : on_each_cpu() cannot be used from
> > a bottom half handler.
> 
> That's what I thought. Back to the drawing board then, to fix mvpp2.
> 
> Do you think there is a place where we can write down those
> assumptions? It isn't easy to spot whether on_each_cpu() is safe to use
> in a bottom half or not.
> 

Really ? kernel/smp.c is full of comments.

Too many comments and people seem to not read them ;)

Take a look at smp_call_function(), which is called from on_each_cpu()


