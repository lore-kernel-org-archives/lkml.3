Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021AbaAHKz4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 05:55:56 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:50577 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755160AbaAHKzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 05:55:53 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sebastian Reichel <sre@debian.org>
Cc: Roger Quadros <rogerq@ti.com>, bcousson@baylibre.com, tony@atomide.com,
        balbi@ti.com, linux-omap@vger.kernel.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, "Kristo, Tero" <t-kristo@ti.com>
Subject: Re: [PATCH v4 1/5] mfd: omap-usb-host: Update DT clock binding information
Date: Wed, 08 Jan 2014 11:55:18 +0100
Message-ID: <3761842.HRY1CDBF4z@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <20140108105244.GA21607@earth.universe>
References: <1389161742-10533-1-git-send-email-rogerq@ti.com> <52CD23E0.8030400@ti.com> <20140108105244.GA21607@earth.universe>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:UlSkV4n1oikUIWw+SM36GyNcZCSHhekn8P5m5GItyWy
 VBYYvFR70HTYzT7N0P8wdQdEQ5tFJyD4uPxJMIS8A7ADgKjpBU
 blH+SO76ex+gB8pWFVc66OoyDkAthWAkddviKCFODNAeqt1afJ
 /473Y8YjIygpyFnoZJAaSp9Y0YVrBb/OqbkH9M2UgSIH1pP1id
 MF+nKmUYKwNZeRnBtpFB/OdL5rQlGAsze8M5uOmQqKqOt6ArAP
 TxaDw1Xcs+RPkGJJTp0uo4ZlskVENGFC5Q/de69+YRmlXANI1n
 rx/tlXYMwk+6BkSwAPCXh5qgLEqY5CWdnfFmFbrcov6MzK9vdh
 OMCvwg1i5IpayG8AYIOA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 January 2014 11:52:44 Sebastian Reichel wrote:
> 
> On Wed, Jan 08, 2014 at 03:39:36PM +0530, Roger Quadros wrote:
> > > What about the other clocks acquired in drivers/mfd/omap-usb-host.c? Shouldn't
> > > all of those be provided by via the DT phandle?
> > 
> > All those clocks are identically named across the OMAP SoCs and are unique for each
> > SoC, so providing DT phandle for all of them is not required.
> > 
> > The init_60m_fclk was renamed to l3init_60m_fclk in OMAP5, and hence the need for
> > this binding.
> 
> I understand the intention of this patch. I was just wondering if
> all the clocks should be referenced from DT even if that is not
> strictly needed at the moment. This would make clocks similar to
> other resources like regulators, gpios, irqs, ...
> 
> Having the clocks referenced from DT looks cleaner to me. It means I
> can check the DT file for any resources used by a driver. It also
> creates some kind of consistency in the kernel.

I think that would be best, yes. AFAIK most other platforms do this
already, OMAP is a bit behind because it started using clocks when the
infrastructure for doing this right was still incomplete.

	Arnd
