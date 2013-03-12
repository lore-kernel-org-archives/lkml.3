Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933513Ab3CLUUg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 16:20:36 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:55963 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933483Ab3CLUUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 16:20:34 -0400
Date: Tue, 12 Mar 2013 13:20:28 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Johan Hovold <jhovold@gmail.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Imre Kaloz <kaloz@openwrt.org>, Krzysztof Halasa <khc@pm.waw.pl>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Daniel Mack <zonque@gmail.com>,
        Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] ARM: w1-gpio: fix erroneous gpio requests
Message-ID: <20130312202028.GA6060@kroah.com>
References: <1363116094-8630-1-git-send-email-jhovold@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363116094-8630-1-git-send-email-jhovold@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 08:21:34PM +0100, Johan Hovold wrote:
> Fix regression introduced by commit d2323cf773 ("onewire: w1-gpio: add
> ext_pullup_enable pin in platform data") which added a gpio entry to the
> platform data, but did not add the required initialisers to the board
> files using it. Consequently, the driver would request gpio 0 at probe,
> which could break other uses of the corresponding pin.
> 
> On AT91 requesting gpio 0 changes the pin muxing for PIOA0, which, for
> instance, breaks SPI0 on at91sam9g20.
> 
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Johan Hovold <jhovold@gmail.com>
> ---
> 
> Not sure whose tree this should go in through, so adding relevant maintainers
> and authors as CC.

As I took the offending patch, I might as well take this fix for it as
well.

Unless anyone else objects?

thanks,

greg k-h
