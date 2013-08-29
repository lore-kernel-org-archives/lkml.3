Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450Ab3H2Mjf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 08:39:35 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:52905 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756419Ab3H2Mje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 08:39:34 -0400
MIME-Version: 1.0
In-Reply-To: <20130801134632.GY9916@kw.sim.vm.gnt>
References: <1374486633-9737-1-git-send-email-simon.guinot@sequanux.org>
	<CACRpkda2bH_TkFR6c0cXvjye4SmFWN5xuzQSO=NqBq8mNDgV0g@mail.gmail.com>
	<20130801134632.GY9916@kw.sim.vm.gnt>
Date: Thu, 29 Aug 2013 14:39:33 +0200
Message-ID: <CACRpkdZcEPM-u19pc+v_cRqUSfJBFZ49rJYiewQ1sWWSU5YxEg@mail.gmail.com>
Subject: Re: [PATCH v3] gpio: add GPIO support for F71882FG and F71889F
From: Linus Walleij <linus.walleij@linaro.org>
To: Simon Guinot <simon.guinot@sequanux.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 1, 2013 at 3:46 PM, Simon Guinot <simon.guinot@sequanux.org> wrote:
> On Mon, Jul 29, 2013 at 05:59:08PM +0200, Linus Walleij wrote:

>> - So we should atleast support ACPI probing with the
>>   port-based detection as a final fallback if all else fails.
>>
>> Why can I not get something like:
>>
>> #include <linux/acpi.h>
>> (...)
>> static const struct acpi_device_id gpio_acpi_match[] = {
>>         { "FOOBAR", 0 },
>
> After some checks on my boards, it appears that there is no PNP ID
> available for the Super-I/O GPIO functionality (or any others). Moreover
> I think this IDs don't have been registered to Microsoft by Fintech
> (the super-I/O manufacturer).
>
> How do you envisage the follow-up ?

Well shall we just apply this as-is then, with ISA-style port
IO probing and all?

I think Rafael said something about it being possible for us
to register our own kernel ACPI PNP IDs (as if: there is no
road here, but if someone starts to walk here, a road will
soon become, and we take the first step then).

But overall I am a bit confused: I am hearing from one end
of the x86 community that ACPI is the way to go for
configuring platform devices on x86, yet stuff like this is
popping up from independent vendors, and get integrated
on boards with no ACPI tables in sight.

Over at ksummit-discuss we have had a thread about
whether device tree should be used in such cases, but
that is not clear either.

Basically I'm a bit confused because the x86 community
is talking with so many voices and I'm not used to it,
and I don't know if they actually have a common vision.

So I'm cc:ing some of my x86 friends to see if they
are OK with this port-probing approach before I merge
the driver.... Rafael, HPA, Matthew?

Yours,
Linus Walleij
