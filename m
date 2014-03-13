Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362AbaCMIMz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 04:12:55 -0400
Received: from www.linutronix.de ([62.245.132.108]:47915 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbaCMIMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 04:12:51 -0400
Date: Thu, 13 Mar 2014 09:12:48 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: joeyli <jlee@suse.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Julian Wollrath <jwollrath@web.de>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        John Stultz <john.stultz@linaro.org>, "Ted Ts'o" <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RESEND] Fast TSC calibration fails with v3.14-rc1 and later
In-Reply-To: <1394683958.26565.235.camel@linux-s257.site>
Message-ID: <alpine.DEB.2.02.1403130905130.18573@ionos.tec.linutronix.de>
References: <20140310110410.5b2218f6@ilfaris>  <alpine.DEB.2.02.1403121722030.18573@ionos.tec.linutronix.de>  <alpine.DEB.2.02.1403121729060.18573@ionos.tec.linutronix.de>  <1554867.utJVyPuT6A@vostro.rjw.lan>  <alpine.DEB.2.02.1403130049500.18573@ionos.tec.linutronix.de>
  <1394678307.26565.218.camel@linux-s257.site>  <532121D2.40805@zytor.com>  <1394682954.26565.228.camel@linux-s257.site>  <53212D14.1090906@zytor.com> <1394683958.26565.235.camel@linux-s257.site>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1915672472-1394698370=:18573"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1915672472-1394698370=:18573
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 13 Mar 2014, joeyli wrote:
> 於 三，2014-03-12 於 20:59 -0700，H. Peter Anvin 提到：
> > On 03/12/2014 08:55 PM, joeyli wrote:
> > > 
> > > So do not care "CMOS RTC Not Present", if TAD is present then we use it
> > > instead of CMOS RTC in all kernel code? or we still can use CMOS RTC?
> > > 
> > 
> > Why would we use *both*!?  How would that possibly make sense?
> > 
> > 	-hpa
> > 
> 
> Yes, it does not make sense for using both.
> 
> I switched the code in get_rtc_time() set_rtc_time() to TAD when it
> present, just make sure I'm on the right path.

No, you're not. get/set_rtc_time() is a complete trainwreck and as I
said before it should move into the rtc subsystem.

There is no reason at all to keep that stuff in the arch specific
code. It's there for historical reasons and that does not justify to
add more mess to it.

So the right thing to do is:

 1) Add eventually missing functionality to the RTC subsystem  

 2) Move the arch specific cmos stuff to the rtc subsystem as proper
    drivers 

 3) Add TAD there after #2 has been completed.

Any attempt to add TAD to arch/x86 is NACKed unconditionally.

Thanks,

	tglx
--8323329-1915672472-1394698370=:18573--
