Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab3FCIQc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 04:16:32 -0400
Received: from mga14.intel.com ([143.182.124.37]:19078 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818Ab3FCIQ1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 04:16:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,791,1363158000"; 
   d="scan'208";a="249913679"
Message-ID: <1370247379.29283.240.camel@smile>
Subject: Re: [PATCH v1.1] gpiolib: append SFI helpers for GPIO API
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Joe Perches <joe@perches.com>
Cc: Ryan Mallon <rmallon@gmail.com>, Linus Walleij <linus.walleij@linaro.org>,
        Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>,
        Grant Likely <grant.likely@secretlab.ca>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, David Cohen <david.a.cohen@intel.com>,
        Grant Likely <grant.likely@linaro.org>
Date: Mon, 03 Jun 2013 11:16:19 +0300
In-Reply-To: <1370225170.2096.12.camel@joe-AO722>
References: <CACRpkdZbCytqaWTK7HvfU2aMpPQVZWX2uf-NXL-rUPGJ6DQ-mQ@mail.gmail.com>
	 <1369992439-5421-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <51ABF879.1090509@gmail.com> <1370225170.2096.12.camel@joe-AO722>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-06-02 at 19:06 -0700, Joe Perches wrote: 
> On Mon, 2013-06-03 at 11:59 +1000, Ryan Mallon wrote:
> > On 31/05/13 19:27, Andy Shevchenko wrote:
> > Some trivial coding style comment below.

Thank you, Joe, for commenting this.

> > > +	for (i = 0; i < sfi_gpio_num_entry; i++, pentry++) {
> > > +		if (!strncmp(name, pentry->pin_name, SFI_NAME_LEN))
> > > +			return pentry->pin_no;
> > > +	}
> > 
> > Nitpick - Don't need the braces on the for loop.
> 
> I'm not Andy but I think it's preferable to keep the braces
> when there's an if in the for loop.

This is my point too.

> > > +	sfi_gpio_table = kmalloc(num * sizeof(*pentry), GFP_KERNEL);
> > 
> > Use kcalloc when you have a size and a count.
> 
> kmalloc_array unless you want zero'ed memory

One proposed to use kmemdup to clean up a bit. What do you think?

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
