Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932729Ab3CLKxn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 06:53:43 -0400
Received: from linux-sh.org ([111.68.239.195]:52074 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753933Ab3CLKxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 06:53:42 -0400
Date: Tue, 12 Mar 2013 19:52:30 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Alex Courbot <acourbot@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Mike Frysinger <vapier@gentoo.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ralf Baechle <ralf@linux-mips.org>, Jonas Bonn <jonas@southpole.se>,
        Josh Boyer <jwboyer@gmail.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Vitaly Bordug <vitb@kernel.crashing.org>,
        Marcelo Tosatti <marcelo@kvack.org>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 09/17] sh: replace CONFIG_GENERIC_GPIO by CONFIG_GPIOLIB
Message-ID: <20130312105228.GA23752@linux-sh.org>
References: <1363083150-30964-1-git-send-email-acourbot@nvidia.com>
 <1363083150-30964-10-git-send-email-acourbot@nvidia.com>
 <20130312103515.GD3553@linux-sh.org>
 <513F06DF.3040105@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513F06DF.3040105@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 07:43:43PM +0900, Alex Courbot wrote:
> On 03/12/2013 07:35 PM, Paul Mundt wrote:
> >On Tue, Mar 12, 2013 at 07:12:22PM +0900, Alexandre Courbot wrote:
> >>SH GPIO drivers all use gpiolib and CONFIG_GENERIC_GPIO is only selected
> >>through CONFIG_GPIOLIB, yet some compilation units depended on
> >>CONFIG_GENERIC_GPIO. Make them depend on CONFIG_GPIOLIB instead since it
> >>is more accurate and prepares us for the future removal of
> >>CONFIG_GENERIC_GPIO.
> >>
> >>Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> >
> >Note that the bulk of the GENERIC_GPIO use for SH has shifted to
> >drivers/pinctrl/sh-pfc/. If GPIOLIB is forced then a good chunk of the
> >Kconfig/Makefile bits there ought to be refactored too.
> 
> Yes, that is the case for many other drivers actually. This series
> just makes sure that GENERIC_GPIO is set through GPIOLIB *only*,
> thus making both options equivalent. If nobody shoots me for this, I
> will refactor individual drivers and ultimately remove GENERIC_GPIO
> completely.
> 
Ok, just wanted to make sure you were aware of this. I don't have any
strong opinions on this one way or the other, the entire GPIO Kconfig
mess is too ugly for words, so any effort to clean that up is probably
worth the added bloat.

Acked-by: Paul Mundt <lethal@linux-sh.org>
