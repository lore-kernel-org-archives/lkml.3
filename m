Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab3GVD15 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 23:27:57 -0400
Received: from mga14.intel.com ([143.182.124.37]:18049 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755454Ab3GVD1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 23:27:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,715,1367996400"; 
   d="scan'208";a="271377875"
Message-ID: <1374463673.3436.68.camel@dvhart-mobl1.amr.corp.intel.com>
Subject: Re: [PATCH 4/8] minnowboard: Add base platform driver for the
 MinnowBoard
From: Darren Hart <dvhart@linux.intel.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: Mark Brown <broonie@kernel.org>, Linus Walleij <linus.walleij@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "peter.p.waskiewicz.jr" <peter.p.waskiewicz.jr@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        danders <danders@circuitco.com>,
        "vishal.l.verma" <vishal.l.verma@intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Richard Purdie <richard.purdie@linuxfoundation.org>,
        platform-driver-x86 <platform-driver-x86@vger.kernel.org>
Date: Sun, 21 Jul 2013 20:27:53 -0700
In-Reply-To: <CACxGe6vOOMAj18LSzNHfgsDeJr1V7_d2CcB08jx_ZekOZ61jRQ@mail.gmail.com>
References: <cover.1372211451.git.dvhart@linux.intel.com>
	 <a459c0b97ea41148af901fc73dbeff98778c7419.1372211451.git.dvhart@linux.intel.com>
	 <CACRpkda8QGdoAvjsUs7Uu+ukUu7ST63g=H9arA7SS7ceWmMTaQ@mail.gmail.com>
	 <1372398218.9243.29.camel@envy.home> <20130704162641.GG27646@sirena.org.uk>
	 <CACxGe6vOOMAj18LSzNHfgsDeJr1V7_d2CcB08jx_ZekOZ61jRQ@mail.gmail.com>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.3 (3.8.3-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-22 at 01:09 +0100, Grant Likely wrote:
> On Thu, Jul 4, 2013 at 5:26 PM, Mark Brown <broonie@kernel.org> wrote:
> > On Thu, Jun 27, 2013 at 10:43:38PM -0700, Darren Hart wrote:
> >
> >> minnow_hwid() just returns an int that the minnowboard platform driver
> >> read from the GPIO. This seems like a proper abstraction to me. Do you
> >> object to this one as well?
> >
> > We should really have a subsystem for this too - the general idea idea
> > of identifying boards, fit options and so on by looking at things like
> > GPIOs or numbers in flash is really common.
> 
> And yet this is a platform with ACPI. I would expect the ACPI to
> identify the board, not a custom driver. The newest ACPI spec adds a
> lot of nice useful things like GPIO and SPI bindings. Talk to Al Stone
> about the progress his team has made on adding GPIO support to ACPICA.
> 
> This driver shouldn't be merged into mainline. Keep it as an
> out-of-tree patch until the proper solution is implemented. That
> shouldn't be too onerous since we now have available not one, but two
> mechanisms for describing exactly what you want to do; ACPI or FDT.

Yes, that is the current plan. I have isolated the necessary patches for
bug fixes (merged, serial support (merged) and networking support (under
review). I am exploring different options with ACPI for how to best
handle the GPIO (LEDs and Keys) and the Lure device descriptions.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel


