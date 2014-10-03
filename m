Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683AbaJCR7S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 13:59:18 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:37858 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbaJCR7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 13:59:15 -0400
Date: Fri, 3 Oct 2014 10:59:10 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, Bryan Wu <cooloney@gmail.com>,
        Lee Jones <lee.jones@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Aaron Lu <aaron.lu@intel.com>, Darren Hart <dvhart@linux.intel.com>
Subject: Re: [PATCH v3 03/15] ACPI: Allow drivers to match using Device Tree
 compatible property
Message-ID: <20141003175910.GB7507@dtor-ws>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com>
 <1852462.V1jlbi8OPt@vostro.rjw.lan>
 <3582127.hCPY12ZqpT@vostro.rjw.lan>
 <20141003134303.GK26643@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141003134303.GK26643@leverpostej>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2014 at 02:43:03PM +0100, Mark Rutland wrote:
> Hi Rafael,
> 
> On Wed, Oct 01, 2014 at 03:10:40AM +0100, Rafael J. Wysocki wrote:
> > From: Mika Westerberg <mika.westerberg@linux.intel.com>
> > 
> > We have lots of existing Device Tree enabled drivers and allocating
> > separate _HID for each is not feasible. Instead we allocate special
> > _HID "PRP0001" that means that the match should be done using Device
> > Tree compatible property using driver's .of_match_table instead.
> 
> That's hopefully not the precise meaning of "PRP0001" unless we're
> attempting no semblance of OS independence here?
> 
> I'm still of the opinion that marrying ACPI to existing (and often
> ill-defined) DT bindings is a bad idea. While it's expedient, I believe
> this is going to be a long-term maintenance nightmare.
> 
> I'm very concerned with the prospect of model mismatch between the two
> (e.g. DT clocks properties where ACPI has traditionally been in charge
> of clock management). I've not seen any high-level guidelines w.r.t.
> what should live in _DSD properties and what should not (at least not in
> the ACPI spec itself). There are almost certainly properties that only
> make sense if !ACPI, and likely there will be some that only make sense
> if ACPI.
> 
> So I think that in its current level of standardisation, _DSD only makes
> sense for simple device properties, and not relationships between
> devices, except where ACPI already has some kind of a model (which
> currently seems to cover interrupts and GPIOs). I'd also hope that we
> could expose a 'clean' subset of DT bidnings (i.e. those which aren't
> known to be kept around only for compatibility with legacy DTBs).
> 
> I do not believe it makes sense to share such a low-level interface.
> Given the aforementioned model differences, and the fact that we don't
> need to support _every_ device tree binding, I don't see why this can't
> be handled with separate probe paths in the drivers we care about (as we
> already do for DT vs platform data).

Because as a driver writer I do not want to implement N+1 ways of
getting device configuration. I want one API that works independently of
the underlying platform. The DT vs platform data is bad enough already.

Thanks.

-- 
Dmitry
