Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab3FCCGX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 22:06:23 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:52504 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755538Ab3FCCGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 22:06:17 -0400
Message-ID: <1370225170.2096.12.camel@joe-AO722>
Subject: Re: [PATCH v1.1] gpiolib: append SFI helpers for GPIO API
From: Joe Perches <joe@perches.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>,
        Grant Likely <grant.likely@secretlab.ca>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, David Cohen <david.a.cohen@intel.com>,
        Grant Likely <grant.likely@linaro.org>
Date: Sun, 02 Jun 2013 19:06:10 -0700
In-Reply-To: <51ABF879.1090509@gmail.com>
References: <CACRpkdZbCytqaWTK7HvfU2aMpPQVZWX2uf-NXL-rUPGJ6DQ-mQ@mail.gmail.com>
	 <1369992439-5421-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <51ABF879.1090509@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-03 at 11:59 +1000, Ryan Mallon wrote:
> On 31/05/13 19:27, Andy Shevchenko wrote:
> Some trivial coding style comment below.
[]
> > +	for (i = 0; i < sfi_gpio_num_entry; i++, pentry++) {
> > +		if (!strncmp(name, pentry->pin_name, SFI_NAME_LEN))
> > +			return pentry->pin_no;
> > +	}
> 
> Nitpick - Don't need the braces on the for loop.

I'm not Andy but I think it's preferable to keep the braces
when there's an if in the for loop.

> > +	sfi_gpio_table = kmalloc(num * sizeof(*pentry), GFP_KERNEL);
> 
> Use kcalloc when you have a size and a count.

kmalloc_array unless you want zero'ed memory

> > +	for (i = 0; i < num; i++, pentry++)
> > +		pr_debug("[%2d] chip = %16.16s, name = %16.16s, pin=%d\n", i,
> > +			 pentry->controller_name, pentry->pin_name,
> > +			 pentry->pin_no);
> 
> Why "%16.16s" here? "%16s" will right justify with leading spaces, or
> "%-16s" will left justify with trailing spaces.

This limits the emitted length to 16 regardless of
strlen(pentry->controller_name) / strlen(pentry->pin_name)


