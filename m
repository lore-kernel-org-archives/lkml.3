Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291AbaJGPiS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 11:38:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:55480 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753242AbaJGPiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 11:38:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,671,1406617200"; 
   d="scan'208";a="601815381"
Message-ID: <1412696266.7701.5.camel@linux.intel.com>
Subject: Re: [RFC PATCH v2 07/16] gpio: Add support for unified device
 properties interface
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Darren Hart <dvhart@infradead.org>, Len Brown <Len.Brown@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        David Woodhouse <david.woodhouse@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Aaron Lu <aaron.lu@intel.com>
Date: Tue, 07 Oct 2014 18:37:46 +0300
In-Reply-To: <CACRpkdbehhsDxikCV1bJjBm581MCcu2DRSmiQQXHG09EmjLNBQ@mail.gmail.com>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com>
	 <2809308.3y5s7TV5Ip@wuerfel> <D04730D8.A9DB0%dvhart@linux.intel.com>
	 <6744174.JquHLt80n3@wuerfel> <20140926032131.GC40523@vmdeb7>
	 <CACRpkdbehhsDxikCV1bJjBm581MCcu2DRSmiQQXHG09EmjLNBQ@mail.gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.6-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-07 at 15:37 +0200, Linus Walleij wrote:
> On Fri, Sep 26, 2014 at 5:21 AM, Darren Hart <dvhart@infradead.org> wrote:
> > On Wed, Sep 24, 2014 at 11:12:36AM +0200, Arnd Bergmann wrote:
> 
> > So as Mika has pointed out, LEDs aren't the only ones affected. Several drivers
> > will need to walk through non-device child nodes, and it seems to me that having
> > a firmware-independent mechanism to do so benefits the drivers by both making
> > them smaller and by increasing the reusability of new drivers and drivers
> > updated to use the new API across platforms.
> 
> In a recent round of reviews, for the OF case, that led to drivers
> which used device_initcall() without being a module, getting a match
> and handle to the parent device, and then walking over the nodes
> and instantiating child objects (Linux devices usually) in the process.
> 
> It was done as a response to the remark from Rob Herring that
> we were modeling things in the device tree as devices when they
> really weren't, we were just doing it that way because it fits the
> Linux device model and it's easier.
> 
> So we have that case too.
> 
> The question is if it's anything close to generalizable.
> 
> > Grant, Linus W? Thoughts?
> 
> I'm uncertain on the whole subject, I called on the others
> because of that...
> 
> For a while I had Andy Schevenko patch the GPIO and
> SFI core too, but it timed out due to no response from Len
> Brown. (Maybe I should just merge that stuff!) Do you (Intel) also
> want to unify the Medfield SFI thing into this or have you
> given up on it?

I think SFI is quite outdated stuff, though I have still Medfield device
close to me.

I don't think there will be any new platform with SFI (on the other hand
we never know :-) ). Thus, my opinion you may go ahead without worrying
about SFI.

-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

