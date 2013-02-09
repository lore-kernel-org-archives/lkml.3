Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760865Ab3BIWkh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 17:40:37 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:36741 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758543Ab3BIWkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 17:40:36 -0500
Date: Sat, 9 Feb 2013 14:36:53 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: Andreas Larsson <andreas@gaisler.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, software@gaisler.com
Subject: Re: [PATCH] gpio: Add device driver for GRGPIO cores
Message-ID: <20130209223653.GA22874@lizard.sbx05280.losalca.wayport.net>
References: <1359548921-14925-1-git-send-email-andreas@gaisler.com>
 <CACRpkdbAS05dVOrE2E5Uu6qfzfgcoz_KqQmqZxz5Pne9BbCt-g@mail.gmail.com>
 <510F6CF8.3000700@gaisler.com>
 <CACRpkdYbJiBT5u0qJz+Krpky7W0WNqtSsO6Jo2TYZ2LRcyassA@mail.gmail.com>
 <510F8D15.30804@gaisler.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <510F8D15.30804@gaisler.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2013 at 11:27:33AM +0100, Andreas Larsson wrote:
[...]
> >>2) The grgpio_to_irq function is very hardware specific, and there is of
> >>course no gpio_to_irq support in gpio-generic.
> >
> >Well, the idea about gpio-generic is to use the pieces you need
> >IIRC. You may override.
> 
> Ah, I see, bgpio_init is exported, so I might be able use that from
> my driver to get rid of some functions. There is support for BE I
> saw now. It seems broken to me (flips bits, not bytes), but that can
> be fixed.

No, it is not broken. :-) There is a BE-notation of GPIO numbering. BE/LE
issue is also valid for bits. Please don't "fix" this. :)

If you need to introduce byte endianness support in addition, that's fine.

Thanks,

Anton
