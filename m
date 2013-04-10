Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936916Ab3DJW3O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:29:14 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:55714 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933050Ab3DJW3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:29:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpio / ACPI: Handle ACPI events in accordance with the spec
Date: Thu, 11 Apr 2013 00:36:46 +0200
Message-ID: <11675322.sNW92yfCOJ@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc6+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CACRpkdZ+Tj2tdQsY7dM+ZJHDeO=HdnYtQ8fWVAXRbP0zpG8ijA@mail.gmail.com>
References: <3043137.BtEKcMiXSu@vostro.rjw.lan> <CACRpkdZ+Tj2tdQsY7dM+ZJHDeO=HdnYtQ8fWVAXRbP0zpG8ijA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 10, 2013 11:06:48 PM Linus Walleij wrote:
> On Tue, Apr 9, 2013 at 3:57 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >
> > Commit 0d1c28a (gpiolib-acpi: Add ACPI5 event model support to gpio.)
> > that added support for ACPI events signalled through GPIO interrupts
> > covered only GPIO pins whose numbers are less than or equal to 255.
> > However, there may be GPIO pins with numbers greater than 255 and
> > the ACPI spec (ACPI 5.0, Section 5.6.5.1) requires the _EVT method
> > to be used for handling events corresponding to those pins.
> >
> > Moreover, according to the spec, _EVT is the default mechanism
> > for handling all ACPI events signalled through GPIO interrupts,
> > so if the _Exx/_Lxx method is not present for the given pin,
> > _EVT should be used instead.  If present, though, _Exx/_Lxx take
> > precedence over _EVT which shouldn't be executed in that case
> > (ACPI 5.0, Section 5.6.5.3).
> >
> > Modify acpi_gpiochip_request_interrupts() to follow the spec as
> > described above and add acpi_gpiochip_free_interrupts() needed
> > to free interrupts associated with _EVT.
> >
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Patch applied with Mika's ACK, thanks!
> 
> It's not like I fully understand it, but I totally trust you guys.

Well, thanks! :-)


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
