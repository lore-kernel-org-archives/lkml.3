Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750978Ab3HSJgX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 05:36:23 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:55513 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab3HSJgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 05:36:22 -0400
MIME-Version: 1.0
In-Reply-To: <5211DD5C.1080306@inria.fr>
References: <51F8F14C.8060507@inria.fr>
	<CAA9_cmcvssPaatgHe8jCaDTfWe4X2GkWVorvMRxaX7tz2s131w@mail.gmail.com>
	<5211DD5C.1080306@inria.fr>
Date: Mon, 19 Aug 2013 02:36:21 -0700
X-Google-Sender-Auth: iTNutUPjCTJXq-Omqr2gULcP7rA
Message-ID: <CAA9_cme13jSvWyBHZb7maRHzzDyw7t6EmwyWZxvrCnQY1BKrTw@mail.gmail.com>
Subject: Re: dmaengine: make dma_channel_rebalance() NUMA aware
From: Dan Williams <djbw@fb.com>
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Vinod Koul <vinod.koul@intel.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +               for_each_online_cpu(cpu)
> +                       per_cpu_ptr(channel_table[cap], cpu)->chan
> +                        = min_chan(cap, cpu);

...this line-wrap strikes me weird.  I think we can afford a few extra
lines and do:

for_each_online_cpu(cpu) {
  chan = min_chan(cap, cpu);
  per_cpu_ptr(channel_table[cap], cpu)->chan = chan;
}
