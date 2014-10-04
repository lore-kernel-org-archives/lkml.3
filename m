Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760570AbaJCXmW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:42:22 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:49288 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760556AbaJCXmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 19:42:16 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
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
Subject: Re: [PATCH v3 03/15] ACPI: Allow drivers to match using Device Tree compatible property
Date: Sat, 04 Oct 2014 02:02:17 +0200
Message-ID: <1573401.WKjUTvdzsT@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141003175910.GB7507@dtor-ws>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com> <20141003134303.GK26643@leverpostej> <20141003175910.GB7507@dtor-ws>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 03, 2014 10:59:10 AM Dmitry Torokhov wrote:
> On Fri, Oct 03, 2014 at 02:43:03PM +0100, Mark Rutland wrote:
> > Hi Rafael,
> > 
> > On Wed, Oct 01, 2014 at 03:10:40AM +0100, Rafael J. Wysocki wrote:
> > > From: Mika Westerberg <mika.westerberg@linux.intel.com>
> > > 
> > > We have lots of existing Device Tree enabled drivers and allocating
> > > separate _HID for each is not feasible. Instead we allocate special
> > > _HID "PRP0001" that means that the match should be done using Device
> > > Tree compatible property using driver's .of_match_table instead.
> > 
> > That's hopefully not the precise meaning of "PRP0001" unless we're
> > attempting no semblance of OS independence here?
> > 
> > I'm still of the opinion that marrying ACPI to existing (and often
> > ill-defined) DT bindings is a bad idea. While it's expedient, I believe
> > this is going to be a long-term maintenance nightmare.
> > 
> > I'm very concerned with the prospect of model mismatch between the two
> > (e.g. DT clocks properties where ACPI has traditionally been in charge
> > of clock management). I've not seen any high-level guidelines w.r.t.
> > what should live in _DSD properties and what should not (at least not in
> > the ACPI spec itself). There are almost certainly properties that only
> > make sense if !ACPI, and likely there will be some that only make sense
> > if ACPI.
> > 
> > So I think that in its current level of standardisation, _DSD only makes
> > sense for simple device properties, and not relationships between
> > devices, except where ACPI already has some kind of a model (which
> > currently seems to cover interrupts and GPIOs). I'd also hope that we
> > could expose a 'clean' subset of DT bidnings (i.e. those which aren't
> > known to be kept around only for compatibility with legacy DTBs).
> > 
> > I do not believe it makes sense to share such a low-level interface.
> > Given the aforementioned model differences, and the fact that we don't
> > need to support _every_ device tree binding, I don't see why this can't
> > be handled with separate probe paths in the drivers we care about (as we
> > already do for DT vs platform data).
> 
> Because as a driver writer I do not want to implement N+1 ways of
> getting device configuration. I want one API that works independently of
> the underlying platform. The DT vs platform data is bad enough already.

Well stated, thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
