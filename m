Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbaJDLAQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 07:00:16 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:59575 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbaJDLAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 07:00:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Aaron Lu <aaron.lu@intel.com>, Darren Hart <dvhart@linux.intel.com>
Subject: Re: [PATCH v3 04/15] ACPI: Document ACPI device specific properties
Date: Sat, 04 Oct 2014 12:59:59 +0200
Message-ID: <8634377.yRllsv0gms@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <6568619.UkU5qISONv@vostro.rjw.lan>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com> <20141003143547.GP26643@leverpostej> <6568619.UkU5qISONv@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:y9+i0Y7QMpDCgUThij1cnY3+VniWzWqMf71hlB5moxf
 Pa16EwxAZ/42rIwoEZAxRAZ7NrxrId3kW76qBKEFRU4TFBE998
 Cdu7ad/U7HVH2Ld1zCGE8w4uc903zMHHGYVSaZsBCrnVb31eus
 cJg3ncGuUE1IVQk7WwVA5hTPmntBbJJiSu0QLdhHa+rxj2zFLy
 Fy6igvXKb8mxa+oH4oz2GpEkQsqDbftwlW2vdssqyO2LfQeG7j
 SlrR8Id+Q83RIq1CJmjS+bC/qxglX+OjO2dmWPMm03j08iXxNk
 lKeyzTZarnv3ah6/B63o9tmpG5yPsuuKkKxeB0L4DIbf5jhKGV
 fhUHSz+NkH/3U1rvFVNE=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 04 October 2014 02:13:23 Rafael J. Wysocki wrote:
> > Because people get the format wrong regardless of documentation. The
> > format:
> > 
> > Package () {
> >       Package () { ^ref1, data, data },
> >       Package () { ^ref2, data },
> >       Package () { ^ref3, data, data, data },
> > }
> > 
> > Is superior to the format:
> > 
> > Package () { ^ref1, data, data, ^ref2, data, ^ref3, data, data, data }
> > 
> > Because in the former you have delimiters that can be used to verify
> > each tuple. Imagine someone misses a data element for one of these
> > tuples. In the former layout you can detect this easily while in the
> > latter you cannot.
> 
> I agree with this particular thing (although other people seem to have
> problems with too many package nesting levels) but I'm not sure what that
> has to do with the example given above (let me quote again):
> 
> > Putting everything to a single package results this:
> > 
> >       Package () { "pwms", Package () {"led-red", ^PWM0, 0, 10, "led-green", ^PWM0, 1, 10 }}
> > 
> > But I think the below looks better:
> > 
> >       Package () { "pwms", Package () {^PWM0, 0, 10, ^PWM0, 1, 10 }}
> >       Package () { "pwm-names", Package () {"led-red", "led-green"}}
> > 
> > and it is trivial to match with the corresponding DT fragment.
> 
> that I was commenting.  Both cases contains the
> 
>         Package () { ^ref1, data, data, ^ref2, data, ^ref3, data, data, data }
> 
> format that you don't like, don't they?
> 

There are two independent issues:

a) avoiding the need for "pwm-names" by embedding the name in the
   "pwms" property

b) avoiding the need for "#pwm-cells" by having explicit separators between
   entries in a "pwms" property.

It would be possible to do one but not the other.

	Arnd
