Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab3BCUJk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 15:09:40 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:34197 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450Ab3BCUJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 15:09:37 -0500
Date: Sun, 3 Feb 2013 12:05:57 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bq27x00_battery: Fix reporting battery temperature
Message-ID: <20130203200557.GA15430@lizard.gateway.2wire.net>
References: <1359799569-5322-1-git-send-email-pali.rohar@gmail.com>
 <20130203034451.GH25016@lizard.sbx00618.mountca.wayport.net>
 <201302032101.54487@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201302032101.54487@pali>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 03, 2013 at 09:01:54PM +0100, Pali Rohár wrote:
> On Sunday 03 February 2013 04:44:51 Anton Vorontsov wrote:
> > On Sat, Feb 02, 2013 at 11:06:09AM +0100, Pali Rohár wrote:
> > > Reported temperature can be also negative, so cache value in
> > > non negative Kelvin degree.
> > > 
> > > Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> > > ---
> > 
> > Applied, thanks!
> 
> Now I looked at bq27x00_battery and rx51_battery drivers and I 
> see that both drivers reporting temperature in different units. 
> bq27x00_battery in 1/10 °C and rx51_battery in 1/100 °C. What is 
> correct degree for kernel power power supply API? Maybe other 
> kernel drivers have different units too... Note that my above 
> patch did not changed anything units, only fixed reporting 
> (possible) negative temperature.

Per Documentation/power/power_supply_class.txt and power_supply.h:

/*
 * All voltages, currents, charges, energies, time and temperatures in uV,
 * µA, µAh, µWh, seconds and tenths of degree Celsius unless otherwise
 * stated. It's driver's job to convert its raw values to units in which
 * this class operates.
 */

Feel free to fix the offending drivers.

Thanks,

Anton
