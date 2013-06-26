Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976Ab3FZT5O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 15:57:14 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:35540 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788Ab3FZT5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 15:57:12 -0400
MIME-Version: 1.0
In-Reply-To: <1372267386.8177.87.camel@envy.home>
References: <cover.1372211451.git.dvhart@linux.intel.com>
	<1ded9714150de50fac7fb6ee82166fbcb5621f7d.1372211451.git.dvhart@linux.intel.com>
	<1372236386.24799.58.camel@smile>
	<1372264087.8177.80.camel@envy.home>
	<20130626171640.GA14661@kroah.com>
	<1372267386.8177.87.camel@envy.home>
Date: Wed, 26 Jun 2013 21:57:12 +0200
Message-ID: <CACRpkdYc0qLQ4-Gh4zabrTZD1wV0TDEOVZrzNKN_znTOOKPbHw@mail.gmail.com>
Subject: Re: [PATCH 6/8] minnowboard-keys: Bind MinnowBoard buttons to arrow keys
From: Linus Walleij <linus.walleij@linaro.org>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Olof Johansson <olof@lixom.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, peter.p.waskiewicz.jr@intel.com,
        danders@circuitco.com, vishal.l.verma@intel.com,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Grant Likely <grant.likely@linaro.org>,
        platform-driver-x86@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 7:23 PM, Darren Hart <dvhart@linux.intel.com> wrote:
> On Wed, 2013-06-26 at 10:16 -0700, Greg Kroah-Hartman wrote:
>> On Wed, Jun 26, 2013 at 09:28:07AM -0700, Darren Hart wrote:

>> > The reason this is separate is that I
>> > can easily see someone wanting to use these buttons in a different way
>> > when integrating the MinnowBoard into some kind of product. The
>> > minnowboard.c driver sets up the fixed functionality GPIO lines, such as
>> > the LEDs (which can be easily reconfigured via triggers) while this
>> > driver serves as an example of how the GPIO buttons could be used as
>> > keys, but if included in the minnowboard driver, users couldn't get the
>> > fixed functionality without also tying up these GPIO lines.
>> >
>> > I could remedy that with driver command-line options, but I know I've
>> > heard Greg KH discourage their use in the past.
>>
>> Ick, yes, never do that type of thing as a command-line option, that's
>> what device-tree is for :)
>
> I suppose when I convert to ACPI drivers I could merge them and have the
> ACPI table include some data that enabled or disabled things like the
> minnowboard-keys.... but that seems like more work for the user than it
> should be to disable the example keys driver.

So now you make it sound that devicetree is somehow really superior
to ACPI because it can actually be used to do some board-specific
configs, and ACPI tables are too hard to use?

Device tree was what we came up with for ARM go get *away* from
stashing custom config into the kernel, such as boardfiles and even
more horrible things like a command-line switch for every key.

Is x86 now not really presenting anything better? I would have a second
look at augmented ACPI tables, if that is what all of x86 is going to use.

FYI here is how I set up a heartbeat LED and some GPIO key in a
device tree:

        /* The user LED on the board is set up to be used for heartbeat */
        leds {
                compatible = "gpio-leds";
                user-led {
                        label = "user_led";
                        gpios = <&gpio0 2 0x1>;
                        default-state = "off";
                        linux,default-trigger = "heartbeat";
                };
        };

        /* User key mapped in as "escape" */
        gpio-keys {
                compatible = "gpio-keys";
                user-button {
                        label = "user_button";
                        gpios = <&gpio0 3 0x1>;
                        linux,code = <1>; /* KEY_ESC */
                        gpio-key,wakeup;
                };
        };

Yours,
Linus Walleij
