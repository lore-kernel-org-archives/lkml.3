Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbbAVPtc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 10:49:32 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:51997 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750888AbbAVPta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 10:49:30 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Darren Hart <dvhart@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [RFC PATCH] gpio: support for GPIO forwarding
Date: Thu, 22 Jan 2015 17:12:07 +0100
Message-ID: <4006695.qV8Mor20ru@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CACRpkdZpUU71suzt9JhiBZez2VuJ6-Zm3D1uvmn71bjdn=oU_A@mail.gmail.com>
References: <1418890998-23811-1-git-send-email-heikki.krogerus@linux.intel.com> <4078818.ecVtLF3hjd@vostro.rjw.lan> <CACRpkdZpUU71suzt9JhiBZez2VuJ6-Zm3D1uvmn71bjdn=oU_A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 22, 2015 09:17:38 AM Linus Walleij wrote:
> On Tue, Jan 20, 2015 at 10:25 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> 
> > Yes, it can (in principle).  In fact, we have a plan to refine it, but it is
> > going to take some time.  Once we've done that, we'll see how painful it is to
> > "patch" ACPI tables this way in practice.
> >
> > Also there is an ecosystem problem related to distributing such "patches".
> > Today, distributions don't need to worry about patching buggy platform
> > firmware, because they get workarounds in the kernel, but if we switch over
> > to the model in which platform firmware "overlays" need to be provided in
> > addition to it, then suddenly questions arise about who should be responsible
> > for making them available, how to avoid duplication of efforts between
> > distributions etc.
> >
> > All of that needs to be clarified before we start making hard statements like
> > "No in-kernel workarounds for that!"
> 
> OK so why can't the patching happen in the kernel?
> 
> If the kernel anyway has to supply some kind of workaround for
> the issue, it is more a question of where to place it. Whether it does
> so by patching the ACPI tables or by detecting a bad ACPI thing
> and working around it at runtime in a certain driver doesn't really
> matter, does it?

It needs to know what to patch and how so the result is still consistent.

How do you think the kernel is going to figure that out?

> They are both in-kernel ACPI fixes, just that one
> of the mechanisms is generic.

I'm not following you here, sorry.

> I don't understand why this obsession with userspace having
> to do the ACPI table patching - if kernels should "just work" then
> put this stuff behind Kconfig and have it in the kernel.

This is not an obsession and your suggestion here leads to having custom
per-board kernels which is not supportable in the long term.


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
