Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933760AbaJUVuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 17:50:11 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:58082 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933656AbaJUVuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 17:50:09 -0400
Date: Tue, 21 Oct 2014 14:50:19 -0700
From: Darren Hart <dvhart@infradead.org>
To: Grant Likely <grant.likely@linaro.org>
Cc: Darren Hart <dvhart@linux.intel.com>, Mark Rutland <mark.rutland@arm.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v4 00/13] Add ACPI _DSD and unified device properties?
 support
Message-ID: <20141021215019.GG20951@vmdeb7>
References: <2660541.BycO7TFnA2@vostro.rjw.lan>
 <1413378271.2762.77.camel@infradead.org>
 <20141015131551.GC20034@leverpostej>
 <1413379736.2762.79.camel@infradead.org>
 <20141015134209.GD20034@leverpostej>
 <db4038336b5e165b8b61eda064b10eeb.squirrel@twosheds.infradead.org>
 <543E88CF.5060504@linux.intel.com>
 <20141015151702.GG20034@leverpostej>
 <543E9605.6020502@linux.intel.com>
 <20141018083549.99F1AC408A6@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141018083549.99F1AC408A6@trevor.secretlab.ca>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18, 2014 at 10:35:49AM +0200, Grant Likely wrote:
> On Wed, 15 Oct 2014 17:43:01 +0200
> , Darren Hart <dvhart@linux.intel.com>
>  wrote:
> > 
> > 
> > On 10/15/14 17:17, Mark Rutland wrote:
> > > On Wed, Oct 15, 2014 at 03:46:39PM +0100, Darren Hart wrote:
> > 
> > >> Mark, what would you propose we do differently to enable this driver to
> > >> be firmware-type agnostic?
> > > 
> > > For this particular driver, all I'm asking for is that the
> > > "used-by-rtas" property is not moved over from of_find_property to
> > > device_get_property. It is irrelevant for all ACPI systems. Evidently my
> > > comment was unclear; I apologise for that.
> > 
> > So my objection here is that by keeping the of_* terms in the driver we
> > are required to include of, although it does safely convert to returning
> > NULL if !CONFIG_OF I suppose.
> 
> This shouldn't be that controversial. There will be things that only make
> sense for DT or only ACPI. Allowing the property to be processed when
> the other interface is being used may tempt firmware authors to use the
> property because it just happens to have a side effect that looks right
> to them.
> 
> I don't see any problem with factoring out those bits into a function
> that is only called (or built) when the associated firmware interface is
> used. In these situations, the driver isn't 100% generic, so having
> small per-firmware hooks is absolutely okay and not a burden to
> maintain.

Hrm... well, I suppose this isn't a hill I want to die on. I can disagree and
commit here :-)

-- 
Darren Hart
Intel Open Source Technology Center
