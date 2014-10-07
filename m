Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895AbaJGXhH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 19:37:07 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:57789 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755795AbaJGXhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 19:37:05 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Len Brown <Len.Brown@intel.com>, Arnd Bergmann <arnd@arndb.de>,
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
Subject: Re: [RFC PATCH v2 07/16] gpio: Add support for unified device properties interface
Date: Wed, 08 Oct 2014 01:57:11 +0200
Message-ID: <2748359.x48UaePcbM@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CACRpkdbehhsDxikCV1bJjBm581MCcu2DRSmiQQXHG09EmjLNBQ@mail.gmail.com>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com> <20140926032131.GC40523@vmdeb7> <CACRpkdbehhsDxikCV1bJjBm581MCcu2DRSmiQQXHG09EmjLNBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 07, 2014 03:37:04 PM Linus Walleij wrote:
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

Well, OK.

Can you please have a look at these patchse in v4:

https://patchwork.kernel.org/patch/5040161/
https://patchwork.kernel.org/patch/5040081/
https://patchwork.kernel.org/patch/5040061/

We now have an ACK from Dmitry on the gpio_keys_polled thing and Bryan
said he was OK with the leds changes already in v2 (IIRC).

Also Alexandre is saying that he's not opposed to the changes in
https://patchwork.kernel.org/patch/5040161/, although there may be a better
way.

And we have AKCs from Greg on the driver core changes, so it looks like
GPIO really is the only missing thing and we need that code to support
our hardware.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
