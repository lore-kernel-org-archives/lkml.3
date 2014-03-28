Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642AbaC1Coo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 22:44:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:7473 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757627AbaC1Col (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 22:44:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,747,1389772800"; 
   d="scan'208";a="508700811"
Date: Fri, 28 Mar 2014 10:43:48 +0800
From: Feng Tang <feng.tang@intel.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Clemens Ladisch <clemens@ladisch.de>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: hpet: Don't default CONFIG_HPET_TIMER to be y for
 X86_64
Message-ID: <20140328024348.GA31111@feng-snb>
References: <1395906309-7519-1-git-send-email-feng.tang@intel.com>
 <53340561.4050708@ladisch.de>
 <53348199.7070207@mit.edu>
 <CANcMJZD7PNf-toZ3FyT-NEUs=YnW5ZZ54cCOkziKDb-wZrOoyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANcMJZD7PNf-toZ3FyT-NEUs=YnW5ZZ54cCOkziKDb-wZrOoyA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2014 at 02:27:26PM -0700, John Stultz wrote:
> On Thu, Mar 27, 2014 at 12:52 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> > On 03/27/2014 04:02 AM, Clemens Ladisch wrote:
> >> Feng Tang wrote:
> >> The help text still says:
> >> | You can safely choose Y here.  [...]
> >> | Choose N to continue using the legacy 8254 timer.
> >>
> >> Are these statements still true for those platforms?
> >
> > They aren't true for modern desktop and server platforms -- the TSC is
> > used regardless of hpet availability.
> 
> While I suspect the comment above is in relation to the non-apic
> timer. But with respect to timekeeping, our point is true assuming the
> TSC isn't mucked up by the BIOS.  My 1yr old i7-3930k single socket
> system still has some wonky BIOS bug that offsets the boot core's TSC.
> And that's intel's bios, so I can only imagine other vendors have
> found other ways to cause trouble.
> 
> So yea, the hpet availability for timekeeping is still important, as
> the TSC can still be problematic.

Yes, agreed. My patch only provides a way to disable HPET for some specific
platforms :)

Thanks,
Feng
