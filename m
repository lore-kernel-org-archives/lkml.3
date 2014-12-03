Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046AbaLCJZh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 04:25:37 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:62378 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbaLCJZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 04:25:32 -0500
From: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Reply-To: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
To: Jean Delvare <jdelvare@suse.de>, Guenter Roeck <linux@roeck-us.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        linux-kernel@vger.kernel.org,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>
Subject: Re: [PATCH] i8k: Add support for temperature sensor labels
X-Mailer: Modest 3.90.7
References: <1417277047-15489-1-git-send-email-pali.rohar@gmail.com>
	 <201411291849.44032@pali> <20141129175152.GA32510@kroah.com>
	 <201411291904.07644@pali> <1417526599.15239.7.camel@chaos.site>
	 <547DCC15.70300@roeck-us.net>  <20141203100928.14d23c9f@endymion.delvare>
In-Reply-To: <20141203100928.14d23c9f@endymion.delvare>
Content-Type: text/plain; charset=utf-8
Content-ID: <1417598726.14672.5.camel@Pali-Nokia-N900>
Date: Wed, 03 Dec 2014 10:25:26 +0100
Message-Id: <1417598726.14672.6.camel@Pali-Nokia-N900>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed Dec   3 10:09:28 2014 Jean Delvare <jdelvare@suse.de> wrote:
> Hi Guenter,
> 
> On Tue, 02 Dec 2014 06:26:29 -0800, Guenter Roeck wrote:
> > On 12/02/2014 05:23 AM, Jean Delvare wrote:
> > > Ultimately /proc/i8k should be killed altogether and every function
> > > should use the appropriate standard interface. But I don't have any
> > > Dell laptop around so I won't go into that myself.
> > 
> > The only function not covered by hwmon, as far as I can see, is reading
> > the "Fn key" status, whatever that is, and reporting the power status
> > (AC or battery).
> > 
> > The first seems to be covered by the already existing dell drivers in
> > platform/x86. The latter must be covered as well; Linux does
> > display the correct power status on all my Dell laptops.
> 
> How old are they? The i8k driver is ancestral, so I could imagine that
> i8k is the only way to report power status on very old Dell laptop
> models. Or maybe not, I just don't know.
> 

It was also for laptops around year 2000. So maybe yes, those laptops probably do not have working acpi power status...

> > Changing the ABI is not supposed to happen, so I am not sure if we can
> > just drop the /proc interface.
> 
> Dropping deprecated interfaces after a transition period is not so
> uncommon. AFAIK the proc interface of i8k is only used by the i8kutils
> user-space package, which FWIW is no longer part of openSUSE.

There are some forks of this package which some users use. And openSUSE is not only one linux distribution. E.g. In Ubuntu and Debian i8kutils package is still available.

> The dell-laptop and dell-wmi drivers are almost 6 years old, that looks
> like an already very comfortable transition period to me.
> 

dell-laptop is using another Dell SMM interface (this one documented), but it does not support temperature and fan control status. It is not acpi driver.

dell-wmi is using acpi/wmi for receiving events (nothing more).

I would like to see i8k driver not integrated into dell-laptop becuase it use totally different interface...

Anyway, what does i8k mean? That dell interface is somehow called DELLDIAG, so I do not know what i8k means...

> That being said, that's only my opinion and I'm not going to fight for
> this. If the hwmon interface is moved to dell-laptop and i8k is killed,
> I'm happy. If the i8k driver is moved to drivers/hwmon and stripped
> down, I'm happy. But if none of this happens, I don't really care, to
> be honest.
> 

For new laptops Fn key status is not supported by i8k (al least on my E6440) and power status is reported by acpi.

So what would be probably better is to split driver into two: One which provides only /proc/i8k interface (unchanged) and other one which provides hwmon interface.

Users of new laptops do not need /proc/i8k anymore (only if they use i8kutils), so would be able to compile only hwmon...

Anyway, do we need to touch /proc/i8k code? It supports only one (first) temperature sensor, one fan control... And i think it is already separated from hwmon code (which doing some detection of more sensors, fans, ...), so what about moving hwmon interface into separate module? We just need some common code for executing SMM function.

> -- 
> Jean Delvare
> SUSE L3 Support

-- 
Pali Rohár
pali.rohar@gmail.com

