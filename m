Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245AbaJ2JkG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 05:40:06 -0400
Received: from www.linutronix.de ([62.245.132.108]:55197 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932137AbaJ2JkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 05:40:03 -0400
Date: Wed, 29 Oct 2014 10:40:00 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
cc: Heena Sirwani <heenasirwani@gmail.com>, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org
Subject: Re: [PATCH v7] timekeeping: Added a function to return tv_sec portion
 of ktime_get_ts64()
In-Reply-To: <3371590.dCyFlG7rJg@wuerfel>
Message-ID: <alpine.DEB.2.11.1410291039010.5308@nanos>
References: <20141029091317.GA1138@heena-HP-Compaq-8200-Elite-MT-PC> <alpine.DEB.2.11.1410291020140.5308@nanos> <3371590.dCyFlG7rJg@wuerfel>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2014, Arnd Bergmann wrote:

> On Wednesday 29 October 2014 10:21:18 Thomas Gleixner wrote:
> > On Wed, 29 Oct 2014, Heena Sirwani wrote:
> > > +time64_t ktime_get_seconds(void)
> > > +{
> > > +     time64_t seconds;
> > > +     struct timekeeper *tk = &tk_core.timekeeper;
> > > +     unsigned int seq;
> > > +
> > > +     WARN_ON(timekeeping_suspended);
> > 
> > You want to have the same 64bit logic as you did for
> > ktime_get_real_seconds. So on 64bit it boils down to return
> > tk->ktime_sec.
> > 
> > > +
> > > +     do {
> > > +             seq = read_seqcount_begin(&tk_core.seq);
> > > +             seconds = tk->ktime_sec;
> > > +
> > > +     } while (read_seqcount_retry(&tk_core.seq, seq));
> > 
> 
> I wonder if we should just make tk->ktime_sec 'unsigned long' and
> avoid the lock for 32-bit as well. Are there any theoretical
> cases where the monotonic time could overflow a 32-bit integer?

136 years uptime :) I think we discussed that 32bit thing before, but
I forgot again.
 
> As a minor optimization 's64 nsec_offset' could also be 'long',
> since that only stores a number that is known to be less than
> 1000000000.

Indeed.

Thanks,

	tglx
