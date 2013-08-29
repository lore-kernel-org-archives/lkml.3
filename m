Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab3H2Nlp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 09:41:45 -0400
Received: from mail.active-venture.com ([67.228.131.205]:61700 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376Ab3H2Nlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 09:41:44 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <521F4F95.5080103@roeck-us.net>
Date: Thu, 29 Aug 2013 06:41:41 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Simon Guinot <simon.guinot@sequanux.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH v3] gpio: add GPIO support for F71882FG and F71889F
References: <1374486633-9737-1-git-send-email-simon.guinot@sequanux.org> <CACRpkda2bH_TkFR6c0cXvjye4SmFWN5xuzQSO=NqBq8mNDgV0g@mail.gmail.com> <20130801134632.GY9916@kw.sim.vm.gnt> <CACRpkdZcEPM-u19pc+v_cRqUSfJBFZ49rJYiewQ1sWWSU5YxEg@mail.gmail.com> <20130829125754.GA8813@srcf.ucam.org>
In-Reply-To: <20130829125754.GA8813@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2013 05:57 AM, Matthew Garrett wrote:
> On Thu, Aug 29, 2013 at 02:39:33PM +0200, Linus Walleij wrote:
>
>> I think Rafael said something about it being possible for us
>> to register our own kernel ACPI PNP IDs (as if: there is no
>> road here, but if someone starts to walk here, a road will
>> soon become, and we take the first step then).
>
> It'd be straightforward to register the LNX PnP prefix and have someone
> take responsibility for assigning numbers, but really a generic vendor
> string should only be used when defining programming models rather than
> specific devices.
>
>> But overall I am a bit confused: I am hearing from one end
>> of the x86 community that ACPI is the way to go for
>> configuring platform devices on x86, yet stuff like this is
>> popping up from independent vendors, and get integrated
>> on boards with no ACPI tables in sight.
>
> ACPI is usually used to describe systems, and the normal ACPI way of
> handling GPIO devices is to expose the device at the other end of the
> GPIO lines and then provide AML for toggling the lines. Attaching an
> actual driver to the device would interfere with that, so nobody writes
> an actual driver.
>
>> Over at ksummit-discuss we have had a thread about
>> whether device tree should be used in such cases, but
>> that is not clear either.
>
> If a vendor doesn't provide any way to autoprobe a device, there's no
> way to autoprobe a device. That usually means that you're not expected
> to use that device.
>

Pretty radical. Following your advice, should we remove all watchdog
and hwmon drivers for all SuperIO chips out there, plus any existing
gpio drivers (drivers/char/pc8736x_gpio.c might be a candidate) ?

Oh, and the parallel port driver also detects super-io chips directly,
so maybe the respective code should be removed as well. I am sure there
is more code that can be removed.

Or is the idea to say "no acpi, no new driver" ? Just wondering -
I have a GPIO driver for Nuvoton chips on my back-burner; that would be
necessary to access some fan controls connected to gpio pins on some boards.
If this is a no-go, I'll happily drop it from my list of things to do,
and just tell the user community that Linux won't support their hardware
due to policy reasons.

Guenter

