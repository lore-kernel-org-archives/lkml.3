Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab3FZRXK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 13:23:10 -0400
Received: from mga14.intel.com ([143.182.124.37]:24376 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752004Ab3FZRXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 13:23:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,945,1363158000"; 
   d="scan'208";a="356156245"
Message-ID: <1372267386.8177.87.camel@envy.home>
Subject: Re: [PATCH 6/8] minnowboard-keys: Bind MinnowBoard buttons to arrow
 keys
From: Darren Hart <dvhart@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Olof Johansson <olof@lixom.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, peter.p.waskiewicz.jr@intel.com,
        danders@circuitco.com, vishal.l.verma@intel.com,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        platform-driver-x86@vger.kernel.org
Date: Wed, 26 Jun 2013 10:23:06 -0700
In-Reply-To: <20130626171640.GA14661@kroah.com>
References: <cover.1372211451.git.dvhart@linux.intel.com>
	 <1ded9714150de50fac7fb6ee82166fbcb5621f7d.1372211451.git.dvhart@linux.intel.com>
	 <1372236386.24799.58.camel@smile> <1372264087.8177.80.camel@envy.home>
	 <20130626171640.GA14661@kroah.com>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-26 at 10:16 -0700, Greg Kroah-Hartman wrote:
> On Wed, Jun 26, 2013 at 09:28:07AM -0700, Darren Hart wrote:
> > On Wed, 2013-06-26 at 11:46 +0300, Andy Shevchenko wrote:
> > > On Tue, 2013-06-25 at 18:53 -0700, Darren Hart wrote: 
> > > > Configure the four buttons tied to the E6XX GPIO lines on the
> > > > MinnowBoard as keys using the gpio-keys-polled platform driver. From
> > > > left to right, bind them to LEFT, DOWN, UP, RIGHT, similar to the VI
> > > > directional keys.
> > > > 
> > > > This is separate from the minnowboard driver to provide users with the
> > > > flexibility to write kernel drivers for their own devices using these GPIO
> > > > lines.
> > > 
> > > I'm repeating my comment I did early to you.
> > > 
> > > I think this driver is a wrong approach, since you just use
> > > gpio_keys_polling with custom platform data. So, it should go to the
> > > platform code / board file under arch/x86/platform/minnow/...
> > 
> > 
> > Olof mentinoed something similar. The reason this is separate is that I
> > can easily see someone wanting to use these buttons in a different way
> > when integrating the MinnowBoard into some kind of product. The
> > minnowboard.c driver sets up the fixed functionality GPIO lines, such as
> > the LEDs (which can be easily reconfigured via triggers) while this
> > driver serves as an example of how the GPIO buttons could be used as
> > keys, but if included in the minnowboard driver, users couldn't get the
> > fixed functionality without also tying up these GPIO lines.
> > 
> > I could remedy that with driver command-line options, but I know I've
> > heard Greg KH discourage their use in the past.
> 
> Ick, yes, never do that type of thing as a command-line option, that's
> what device-tree is for :)

I suppose when I convert to ACPI drivers I could merge them and have the
ACPI table include some data that enabled or disabled things like the
minnowboard-keys.... but that seems like more work for the user than it
should be to disable the example keys driver.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Technical Lead - Linux Kernel

