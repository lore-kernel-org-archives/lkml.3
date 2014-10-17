Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751334AbaJQUzf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 16:55:35 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:56893 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbaJQUzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 16:55:33 -0400
Date: Fri, 17 Oct 2014 13:55:30 -0700
From: Benjamin Poirier <benjamin.poirier@gmail.com>
To: =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        Carles =?iso-8859-1?Q?Pag=E8s?= <page@cubata.homelinux.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Regarding tx-nocache-copy in the Sheevaplug
Message-ID: <20141017205530.GA7367@f1.synalogic.ca>
References: <20141013105246.GD1972@vicerveza.homeunix.net>
 <20141015215701.GA4109@f1.synalogic.ca>
 <1413413127.17186.5.camel@edumazet-glaptop2.roam.corp.google.com>
 <20141016173401.GA16515@f1.synalogic.ca>
 <20141016174628.GL1972@vicerveza.homeunix.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141016174628.GL1972@vicerveza.homeunix.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/10/16 19:46, Lluís Batlle i Rossell wrote:
[...]
> 
> Hello all,
> 
> it seems I was a bit wrong - although enabling back tx-nocache-copy makes the
> tx-errors happen much less often (ssh complaining about HMAC), they still
> happen. It seems that something was introduced in some recent kernels that broke
> the tx offload.
> 
> I have no idea what it can be, but since 2.6 until at least 3.10 the network
> driver worked fine with tx offload in this sheevaplug board.

It's not the most pleasant alternative but if you can be sure enough
whether the problem is occurring or not, you could try bisecting,
possibly limiting the bisection to mv643xx

$ git bisect start v3.16.3 v3.10 -- drivers/net/ethernet/marvell/mv643xx_eth.c
Bisecting: 16 revisions left to test after this (roughly 4 steps)

The problem might be outside of the driver though.
