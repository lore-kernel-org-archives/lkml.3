Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbaELUSy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 16:18:54 -0400
Received: from lvk-gate.cs.msu.ru ([188.44.42.233]:59364 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751509AbaELUSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 16:18:53 -0400
X-Greylist: delayed 470 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 May 2014 16:18:53 EDT
X-Spam-ASN: 
Date: Tue, 13 May 2014 00:10:57 +0400
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: John Stultz <john.stultz@linaro.org>
Cc: George Spelvin <linux@horizon.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ntp: make is_error_status() use its argument
Message-ID: <20140513001057.7deed538@tornado.gnet>
In-Reply-To: <53710AD5.504@linaro.org>
References: <20140512133548.31421.qmail@ns.horizon.com>
	<53710AD5.504@linaro.org>
Organization: LVK
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8bit
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No objections from me, of course. Good catch.

В Mon, 12 May 2014 10:54:29 -0700
John Stultz <john.stultz@linaro.org> пишет:

> On 05/12/2014 06:35 AM, George Spelvin wrote:
> > It's an inline function always called with the global time_status
> > as an argument, so there's zero functional difference, but the
> > non-CONFIG_SMP version uses the passed-in argument, while the
> > CONFIG_SMP one ignores its argument and uses the global.
> 
> CONFIG_NTP_PPS not CONFIG_SMP, right?
> 
> Good catch though, looks like the check code was re-factored out, but
> someone forgot to use the local variable.
> 
> Adding Alexander since he submitted the pps logic.
> 
> If there's no objections, I'll queue this (with a more verbose commit
> message) for 3.16
> 
> thanks
> -john
> 
> 
> >     
> > Make it use the argument always; shorter variable names are good.
> >
> > Signed-off-by: George Spelvin <linux@horizon.com>
> > ---
> > While poking about in the code, I came across this rather odd bit.
> > It looked worth fixing, on general principles.
> >
> > diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
> > index 419a52cecd..1a2aad3fff 100644
> > --- a/kernel/time/ntp.c
> > +++ b/kernel/time/ntp.c
> > @@ -165,21 +165,21 @@ static inline void pps_set_freq(s64 freq)
> >  
> >  static inline int is_error_status(int status)
> >  {
> > -	return (time_status & (STA_UNSYNC|STA_CLOCKERR))
> > +	return (status & (STA_UNSYNC|STA_CLOCKERR))
> >  		/* PPS signal lost when either PPS time or
> >  		 * PPS frequency synchronization requested
> >  		 */
> > -		|| ((time_status & (STA_PPSFREQ|STA_PPSTIME))
> > -			&& !(time_status & STA_PPSSIGNAL))
> > +		|| ((status & (STA_PPSFREQ|STA_PPSTIME))
> > +			&& !(status & STA_PPSSIGNAL))
> >  		/* PPS jitter exceeded when
> >  		 * PPS time synchronization requested */
> > -		|| ((time_status & (STA_PPSTIME|STA_PPSJITTER))
> > +		|| ((status & (STA_PPSTIME|STA_PPSJITTER))
> >  			== (STA_PPSTIME|STA_PPSJITTER))
> >  		/* PPS wander exceeded or calibration error when
> >  		 * PPS frequency synchronization requested
> >  		 */
> > -		|| ((time_status & STA_PPSFREQ)
> > -			&& (time_status &
> > (STA_PPSWANDER|STA_PPSERROR)));
> > +		|| ((status & STA_PPSFREQ)
> > +			&& (status &
> > (STA_PPSWANDER|STA_PPSERROR))); }
> >  
> >  static inline void pps_fill_timex(struct timex *txc)
> 



-- 
  Alexander
