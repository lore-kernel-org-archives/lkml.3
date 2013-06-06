Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932487Ab3FFKB6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 06:01:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51330 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932104Ab3FFKBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 06:01:55 -0400
Date: Thu, 6 Jun 2013 12:01:38 +0200
From: Borislav Petkov <bp@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Stratos Karafotis <stratosk@semaphore.gr>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] cpufreq: ondemand: Change the calculation of
 target frequency
Message-ID: <20130606100138.GC21181@pd.tnic>
References: <51AF60D5.3080605@semaphore.gr>
 <20130605161703.GA29958@pd.tnic>
 <51AF71B6.6030408@semaphore.gr>
 <105446113.ZumbZWCbSi@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <105446113.ZumbZWCbSi@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 10:35:05PM +0200, Rafael J. Wysocki wrote:
> On Wednesday, June 05, 2013 08:13:26 PM Stratos Karafotis wrote:
> > Hi Borislav,
> > 
> > On 06/05/2013 07:17 PM, Borislav Petkov wrote:
> > > On Wed, Jun 05, 2013 at 07:01:25PM +0300, Stratos Karafotis wrote:
> > >> Ondemand calculates load in terms of frequency and increases it only
> > >> if the load_freq is greater than up_threshold multiplied by current
> > >> or average frequency. This seems to produce oscillations of frequency
> > >> between min and max because, for example, a relatively small load can
> > >> easily saturate minimum frequency and lead the CPU to max. Then, the
> > >> CPU will decrease back to min due to a small load_freq.
> > >
> > > Right, and I think this is how we want it, no?
> > >
> > > The thing is, the faster you finish your work, the faster you can become
> > > idle and save power.
> > 
> > This is exactly the goal of this patch. To use more efficiently middle
> > frequencies to finish faster the work.

Hold on, you say above "easily saturate minimum frequency and lead the
CPU to max". I read this as we jump straight to max P-state where we
even boost.

"CPU to max" finishes the work faster than middle frequencies, if you're
CPU-bound.

> > > If you switch frequencies in a staircase-like manner, you're going to
> > > take longer to finish, in certain cases, and burn more power while doing
> > > so.
> > 
> > This is not true with this patch. It switches to middle frequencies
> > when the load < up_threshold.

This is worth investigating wrt hightened power consumption, as Rafael
suggested.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
