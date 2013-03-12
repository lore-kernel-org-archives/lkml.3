Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933553Ab3CLVR4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 17:17:56 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:39600 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755685Ab3CLVRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 17:17:54 -0400
Date: Tue, 12 Mar 2013 22:17:02 +0100
From: Johan Hovold <jhovold@gmail.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johan Hovold <jhovold@gmail.com>, Evgeniy Polyakov <zbr@ioremap.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Imre Kaloz <kaloz@openwrt.org>, Krzysztof Halasa <khc@pm.waw.pl>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Daniel Mack <zonque@gmail.com>,
        Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] ARM: w1-gpio: fix erroneous gpio requests
Message-ID: <20130312211702.GG8797@localhost>
References: <1363116094-8630-1-git-send-email-jhovold@gmail.com>
 <20130312202028.GA6060@kroah.com>
 <FE853F2C-A85A-4D0E-BF0E-80698F3E6567@jcrosoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FE853F2C-A85A-4D0E-BF0E-80698F3E6567@jcrosoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 04:24:20AM +0800, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On Mar 13, 2013, at 4:20 AM, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > On Tue, Mar 12, 2013 at 08:21:34PM +0100, Johan Hovold wrote:
> >> Fix regression introduced by commit d2323cf773 ("onewire: w1-gpio: add
> >> ext_pullup_enable pin in platform data") which added a gpio entry to the
> >> platform data, but did not add the required initialisers to the board
> >> files using it. Consequently, the driver would request gpio 0 at probe,
> >> which could break other uses of the corresponding pin.
> >> 
> >> On AT91 requesting gpio 0 changes the pin muxing for PIOA0, which, for
> >> instance, breaks SPI0 on at91sam9g20.
> 
> not only on AT91, 0 is a valid gpio

AT91 (and 9g20) was just an example of what the implications could be
like.

I discovered the change after having debugged broken MMC on a custom
at91sam9g45 board.

Johan
