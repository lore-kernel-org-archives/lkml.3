Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab3GTRh4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 13:37:56 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34715 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470Ab3GTRhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 13:37:55 -0400
MIME-Version: 1.0
In-Reply-To: <20130704162641.GG27646@sirena.org.uk>
References: <cover.1372211451.git.dvhart@linux.intel.com>
	<a459c0b97ea41148af901fc73dbeff98778c7419.1372211451.git.dvhart@linux.intel.com>
	<CACRpkda8QGdoAvjsUs7Uu+ukUu7ST63g=H9arA7SS7ceWmMTaQ@mail.gmail.com>
	<1372398218.9243.29.camel@envy.home>
	<20130704162641.GG27646@sirena.org.uk>
Date: Sat, 20 Jul 2013 19:37:54 +0200
Message-ID: <CACRpkdbKGti==FTfHm81EkwD++iRfixnXt3kWgBj7CxjM+2znA@mail.gmail.com>
Subject: Re: [PATCH 4/8] minnowboard: Add base platform driver for the MinnowBoard
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@kernel.org>, Lee Jones <lee.jones@linaro.org>
Cc: Darren Hart <dvhart@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "peter.p.waskiewicz.jr" <peter.p.waskiewicz.jr@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        danders <danders@circuitco.com>,
        "vishal.l.verma" <vishal.l.verma@intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Grant Likely <grant.likely@linaro.org>,
        Richard Purdie <richard.purdie@linuxfoundation.org>,
        platform-driver-x86 <platform-driver-x86@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 4, 2013 at 6:26 PM, Mark Brown <broonie@kernel.org> wrote:
> On Thu, Jun 27, 2013 at 10:43:38PM -0700, Darren Hart wrote:
>
>> minnow_hwid() just returns an int that the minnowboard platform driver
>> read from the GPIO. This seems like a proper abstraction to me. Do you
>> object to this one as well?
>
> We should really have a subsystem for this too - the general idea idea
> of identifying boards, fit options and so on by looking at things like
> GPIOs or numbers in flash is really common.

Would it then be a bus following the pattern we chiseled out for
the soc bus? (Greg, Lee & Arnd architectured this.)

There we needed a struct device * on an overarching level to
tie in the sysfs entries reading out the SoC properties. But
it would be the same thing with in-kernel accessors for these
properties.

So it would be the same pattern above with a board bus, in
DT syntax:

board {
     soc {
     };
};

Yours,
Linus Walleij
