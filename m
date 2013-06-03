Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495Ab3FCM0d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 08:26:33 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:53243 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752841Ab3FCM0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 08:26:30 -0400
Message-ID: <1370262387.2025.25.camel@joe-AO722>
Subject: Re: [PATCH v1.1] gpiolib: append SFI helpers for GPIO API
From: Joe Perches <joe@perches.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Ryan Mallon <rmallon@gmail.com>, Linus Walleij <linus.walleij@linaro.org>,
        Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>,
        Grant Likely <grant.likely@secretlab.ca>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, David Cohen <david.a.cohen@intel.com>,
        Grant Likely <grant.likely@linaro.org>
Date: Mon, 03 Jun 2013 05:26:27 -0700
In-Reply-To: <1370247379.29283.240.camel@smile>
References: <CACRpkdZbCytqaWTK7HvfU2aMpPQVZWX2uf-NXL-rUPGJ6DQ-mQ@mail.gmail.com>
	 <1369992439-5421-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <51ABF879.1090509@gmail.com> <1370225170.2096.12.camel@joe-AO722>
	 <1370247379.29283.240.camel@smile>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-03 at 11:16 +0300, Andy Shevchenko wrote:
> On Sun, 2013-06-02 at 19:06 -0700, Joe Perches wrote: 
> > On Mon, 2013-06-03 at 11:59 +1000, Ryan Mallon wrote:
> > > On 31/05/13 19:27, Andy Shevchenko wrote:
> > > > +	sfi_gpio_table = kmalloc(num * sizeof(*pentry), GFP_KERNEL);
> > > Use kcalloc when you have a size and a count.
> > kmalloc_array unless you want zero'ed memory
> One proposed to use kmemdup to clean up a bit. What do you think?

Seems correct to use kmemdup but what validates num?

It seems like a possible error path exists there regardless
of whether kmemdup is used or not.


