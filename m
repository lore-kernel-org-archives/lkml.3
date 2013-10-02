Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359Ab3JBUm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 16:42:27 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:39308 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317Ab3JBUmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 16:42:23 -0400
Date: Wed, 2 Oct 2013 13:42:17 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: boris brezillon <b.brezillon@overkiz.com>
Cc: Wim Van Sebroeck <wim@iguana.be>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Yang Wenyou <Wenyou.Yang@atmel.com>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [v2,1/4] watchdog: at91sam9_wdt: better watchdog support
Message-ID: <20131002204217.GA14148@roeck-us.net>
References: <1371799288-3548-1-git-send-email-b.brezillon@overkiz.com>
 <20131002161204.GA15974@roeck-us.net>
 <524C7387.5050108@overkiz.com>
 <20131002193454.GB4695@roeck-us.net>
 <524C79D2.5070708@overkiz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524C79D2.5070708@overkiz.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 09:53:54PM +0200, boris brezillon wrote:
[ ... ]
> >>>>+
> >>>>+	if (!wdt->heartbeat) {
> >>>>+		dev_err(wdt->wdd.parent,
> >>>>+			": sorry, linux timer (%i Hz) cannot handle watchdog timeout (%i ms)\n",
> >>>>+			HZ, ticks_to_ms(value));
> >>>>+		return -EINVAL;
> >>>Isn't that a bit rude ? Why not set it to the minimum ?
> 
> I might have misunderstood your point.
> What is a bit rude ?
>  - the fact that the minimum heartbeat timeout has to be at less or
> equal to one-forth of
>    max heartbeat timeout
>  - the fact that heartbeat expressed in ticks has to be more than 0
>  - something else

That you don't auto-correct the heatbeat to the minimum but return -EINVAL instead.
I prefer to be user-friendly, which in this case would be to accept and handle
the <min, max> timeout values provided to the infrastructure and handle any
deviations / limitaions internally.

Or, in other words, I don't like it if the user ends up having to guess
valid parameter ranges.

Thanks,
Guenter
