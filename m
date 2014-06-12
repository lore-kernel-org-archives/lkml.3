Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932881AbaFLIkW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 04:40:22 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:34127 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932657AbaFLIkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 04:40:20 -0400
Message-ID: <1402562399.8095.5.camel@jlt4.sipsolutions.net>
Subject: Re: net_timedelta() affected by settimeofday() (was: [patch 12/13]
 net: mac80211: Remove silly timespec dance)
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org,
        Stephen Hemminger <shemminger@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>
Date: Thu, 12 Jun 2014 10:39:59 +0200
In-Reply-To: <1402562114.8095.3.camel@jlt4.sipsolutions.net> (sfid-20140612_103558_525847_209A5C98)
References: <20140611234024.103571777@linutronix.de>
	 <20140611234607.683770899@linutronix.de>
	 <1402555774.4224.1.camel@jlt4.sipsolutions.net>
	 <alpine.DEB.2.10.1406121017500.5170@nanos>
	 <1402562114.8095.3.camel@jlt4.sipsolutions.net>
	 (sfid-20140612_103558_525847_209A5C98)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-12 at 10:35 +0200, Johannes Berg wrote:
> +netdev, Stephen

Well, stupid me. Fixing that netdev address.

> On Thu, 2014-06-12 at 10:19 +0200, Thomas Gleixner wrote:
> > On Thu, 12 Jun 2014, Johannes Berg wrote:
> > 
> > > On Wed, 2014-06-11 at 23:59 +0000, Thomas Gleixner wrote:
> > > 
> > > > +	msrmnt = ktime_to_ms(net_timedelta(skb_arv));
> > > 
> > > This is probably more of a question about net_timedelta(), but is
> > > ktime_get_real() really appropriate for duration measurements? Isn't
> > > that non-monotonic?
> > 
> > Well, it's monotonic, but might be affected by settimeofday().
> 
> Right, but isn't that odd? Suddenly your delay measurement here might be
> minutes, hours, or years if you settimeofday() between timestamping and
> calculating the delta. That seems very strange to me, why would that be
> the right behaviour in any way?
> 
> Now, it seems that there are only two current users of net_timedelta()
> (in DCCP) so perhaps it's not too late to change some of this?
> 
> Maybe in general the skb timestamp should be based on a different clock
> and only adjusted to real time when used in userspace?


