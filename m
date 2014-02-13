Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbaBMJ57 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 04:57:59 -0500
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:56344 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753382AbaBMJ54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 04:57:56 -0500
Message-ID: <1392285474.30853.28.camel@x220>
Subject: Re: [PATCH] Blackfin: bf537: rename "CONFIG_ADT7310" and friends
From: Paul Bolle <pebolle@tiscali.nl>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Guenter Roeck <linux@roeck-us.net>, Steven Miao <realmz6@gmail.com>,
        adi-buildroot-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Date: Thu, 13 Feb 2014 10:57:54 +0100
In-Reply-To: <51507126.2040002@metafoo.de>
References: <1364211831.1390.285.camel@x61.thuisdomein>
	 <20130325152258.GA17467@roeck-us.net> <51507126.2040002@metafoo.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Feb 2014 09:57:55.0052 (UTC) FILETIME=[10E882C0:01CF28A2]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Replaced previous maintainer and list with current maintainer and
list.]

On Mon, 2013-03-25 at 16:45 +0100, Lars-Peter Clausen wrote:
> On 03/25/2013 04:22 PM, Guenter Roeck wrote:
> > On Mon, Mar 25, 2013 at 12:43:51PM +0100, Paul Bolle wrote:
> >> The Kconfig symbol ADT7310 got removed in commit
> >> 2b0c856ad9571013db8fc369194b7108dff3c18e ("staging:iio: Consolidate
> >> adt7310 and adt7410 driver"). That commit did not touch the references
> >> to CONFIG_ADT7310 and CONFIG_ADT7310_MODULE in the BF537-STAMP code.
> >> Convert these now, to their ADT7410 equivalents.
> >>
> >> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> >> ---
> >> 0) Untested. This took a bit of guesswork. I guessed that multiple AD
> >> drivers can be enabled at the same time in this code. And I also guessed
> >> that the "adt7310" modalias is still correct.
> >>
> >> 1) If this passes testing it could go in stable (3.8.y).
> >>
> >>  arch/blackfin/mach-bf537/boards/stamp.c | 4 ++--
> >>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
> >> index 95114ed..23bb55d 100644
> >> --- a/arch/blackfin/mach-bf537/boards/stamp.c
> >> +++ b/arch/blackfin/mach-bf537/boards/stamp.c
> >> @@ -700,7 +700,7 @@ static struct bfin5xx_spi_chip ad7816_spi_chip_info = {
> >>  };
> >>  #endif
> >>  
> >> -#if defined(CONFIG_ADT7310) || defined(CONFIG_ADT7310_MODULE)
> >> +#if defined(CONFIG_ADT7410) || defined(CONFIG_ADT7410_MODULE)
> > 
> > It might be easier and more future-proof to just drop the conditional.
> > If the driver isn't there, it won't be loaded anyway. It would also make
> > back-porting much easier.
> > 
> > Guenter
> 
> 
> The situation is unfortunately really messy. The issue is that these are
> add-on board and the same SPI chip select pin is used for multiple devices.
> If we add the spi_board_info for all devices unconditionally the SPI core
> will scream at us because we tried to register multiple devices with the
> same chip select pin and none of the devices gets actually registered.

This issue is still present in v3.14-rc2. Guenter's suggestion is the
easiest way out. Should I submit a trivial patch that just removes the
dead code depending on never defined CONFIG_ADT7310 and
CONFIG_ADT7310_MODULE?


Paul Bolle

