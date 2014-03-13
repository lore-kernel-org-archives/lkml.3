Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbaCMJBF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 05:01:05 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:51282 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389AbaCMJAY (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Thu, 13 Mar 2014 05:00:24 -0400
Subject: Re: [RESEND] Fast TSC calibration fails with v3.14-rc1 and later
From: joeyli <jlee@suse.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Julian Wollrath <jwollrath@web.de>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        John Stultz <john.stultz@linaro.org>, "Ted Ts'o" <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.02.1403130905130.18573@ionos.tec.linutronix.de>
References: <20140310110410.5b2218f6@ilfaris>
	 <alpine.DEB.2.02.1403121722030.18573@ionos.tec.linutronix.de>
	 <alpine.DEB.2.02.1403121729060.18573@ionos.tec.linutronix.de>
	 <1554867.utJVyPuT6A@vostro.rjw.lan>
	 <alpine.DEB.2.02.1403130049500.18573@ionos.tec.linutronix.de>
	 <1394678307.26565.218.camel@linux-s257.site>  <532121D2.40805@zytor.com>
	 <1394682954.26565.228.camel@linux-s257.site>  <53212D14.1090906@zytor.com>
	 <1394683958.26565.235.camel@linux-s257.site>
	 <alpine.DEB.2.02.1403130905130.18573@ionos.tec.linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Mar 2014 16:59:34 +0800
Message-ID: <1394701174.26565.246.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 四，2014-03-13 於 09:12 +0100，Thomas Gleixner 提到：
> On Thu, 13 Mar 2014, joeyli wrote:
> > 於 三，2014-03-12 於 20:59 -0700，H. Peter Anvin 提到：
> > > On 03/12/2014 08:55 PM, joeyli wrote:
> > > > 
> > > > So do not care "CMOS RTC Not Present", if TAD is present then we use it
> > > > instead of CMOS RTC in all kernel code? or we still can use CMOS RTC?
> > > > 
> > > 
> > > Why would we use *both*!?  How would that possibly make sense?
> > > 
> > > 	-hpa
> > > 
> > 
> > Yes, it does not make sense for using both.
> > 
> > I switched the code in get_rtc_time() set_rtc_time() to TAD when it
> > present, just make sure I'm on the right path.
> 
> No, you're not. get/set_rtc_time() is a complete trainwreck and as I
> said before it should move into the rtc subsystem.
> 
> There is no reason at all to keep that stuff in the arch specific
> code. It's there for historical reasons and that does not justify to
> add more mess to it.

Fully understand now. Thanks for your explanation.

> 
> So the right thing to do is:
> 
>  1) Add eventually missing functionality to the RTC subsystem  
> 
>  2) Move the arch specific cmos stuff to the rtc subsystem as proper
>     drivers 
> 
>  3) Add TAD there after #2 has been completed.
> 
> Any attempt to add TAD to arch/x86 is NACKed unconditionally.
> 
> Thanks,
> 
> 	tglx

Does there have any people already start the work of #1 and #2? 


Thanks
Joey Lee


