Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564AbaJCN4R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 09:56:17 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:64568 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751282AbaJCN4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 09:56:15 -0400
Date: Fri, 3 Oct 2014 14:56:10 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
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
Message-ID: <20141003135610.GM26643@leverpostej>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com>
 <3986527.L7rDZAb4g5@wuerfel>
 <20141002143809.GQ1786@lahna.fi.intel.com>
 <2072038.Vir4futZot@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2072038.Vir4futZot@wuerfel>
Thread-Topic: [PATCH v3 04/15] ACPI: Document ACPI device specific properties
Accept-Language: en-GB, en-US
Content-Language: en-US
acceptlanguage: en-GB, en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 03:55:56PM +0100, Arnd Bergmann wrote:
> On Thursday 02 October 2014 17:38:09 Mika Westerberg wrote:
> > On Thu, Oct 02, 2014 at 04:29:03PM +0200, Arnd Bergmann wrote:
> > > Is this a limitation in the way that the AML syntax and compiler works,
> > > or is this a decision you made specifically for the _DSD syntax and that
> > > could still be changed if there is an overwhelming interest?
> > 
> > It is only limitation of the _DSD device property UUID specification and
> > our implementation. It can be changed if needed.
> 
> Ok, I see. I think it would be nice if this could be changed in order
> to avoid having to copy the #xxx-cells and xxx-names properties from
> DT, by providing a more natural syntax.

I'd certainly not like to see #foo-cells in _DSD given it should be
possible with a package to have a package description like the
following:

	Package () {
		Package () { ^ref1, data, data }, 
		Package () { ^ref2, dta, data, data },
	}

Where the #foo-cells is implicit in each instance. That makes variadic
properties possible, and makes it possible to perform validation on each
tuple even in the binary format, which we can't do with a DTB

I'm not so sure on foo-names unless we made names an explicit
requirement from the start (which I wish was the case on the DT side).
Even then we might need other parallel properties anyway (think
clock-indicies).

Mark.

