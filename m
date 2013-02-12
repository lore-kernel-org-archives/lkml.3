Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933641Ab3BLSTZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 13:19:25 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:35610 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933580Ab3BLSTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 13:19:22 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] of: Create function for counting number of phandles in a property
To: Andreas Larsson <andreas@gaisler.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
In-Reply-To: <511A08D2.6010104@gaisler.com>
References: <1360540701-23439-1-git-send-email-grant.likely@secretlab.ca> <511A08D2.6010104@gaisler.com>
Date: Tue, 12 Feb 2013 17:28:07 +0000
Message-Id: <20130212172807.AAF993E0B53@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2013 10:18:10 +0100, Andreas Larsson <andreas@gaisler.com> wrote:
> On 2013-02-11 00:58, Grant Likely wrote:
> > This patch creates of_count_phandle_with_args(), a new function for
> > counting the number of phandle+argument tuples in a given property. This
> > is better than the existing method of parsing each phandle individually
> > until parsing fails which is a horribly slow way to do the count.
> >
> > It also converts of_gpio_named_count() to use the new function instead
> > of using the above described horrible method.
> >
> > This also requires the return value of of_gpio_count() &
> > of_gpio_named_count() from 'unsigned int' to 'int' so that it can return
> > an error code. All the users of that function are fixed up to correctly
> > handle a negative return value.
> 
> One more thing: In of_spi_register_master() in drivers/spi.c the error 
> code is put in the unsigned variable nb, leading to a huge nb and 
> master->num_chipselect with following problems when of_gpio_named_count 
> returns an error code.

Also a good catch. Fixed.

g.

