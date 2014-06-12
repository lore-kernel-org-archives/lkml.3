Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932871AbaFLITk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 04:19:40 -0400
Received: from www.linutronix.de ([62.245.132.108]:38016 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932727AbaFLITg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 04:19:36 -0400
Date: Thu, 12 Jun 2014 10:19:08 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Johannes Berg <johannes@sipsolutions.net>
cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [patch 12/13] net: mac80211: Remove silly timespec dance
In-Reply-To: <1402555774.4224.1.camel@jlt4.sipsolutions.net>
Message-ID: <alpine.DEB.2.10.1406121017500.5170@nanos>
References: <20140611234024.103571777@linutronix.de>  <20140611234607.683770899@linutronix.de> <1402555774.4224.1.camel@jlt4.sipsolutions.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2014, Johannes Berg wrote:

> On Wed, 2014-06-11 at 23:59 +0000, Thomas Gleixner wrote:
> 
> > +	msrmnt = ktime_to_ms(net_timedelta(skb_arv));
> 
> This is probably more of a question about net_timedelta(), but is
> ktime_get_real() really appropriate for duration measurements? Isn't
> that non-monotonic?

Well, it's monotonic, but might be affected by settimeofday().

Thanks,

	tglx
