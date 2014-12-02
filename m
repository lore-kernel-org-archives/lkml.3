Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933140AbaLBNX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 08:23:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35906 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932724AbaLBNXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 08:23:25 -0500
Subject: Re: [PATCH] i8k: Add support for temperature sensor labels
From: Jean Delvare <jdelvare@suse.de>
To: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        linux-kernel@vger.kernel.org,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>
In-Reply-To: <201411291904.07644@pali>
References: <1417277047-15489-1-git-send-email-pali.rohar@gmail.com>
	 <201411291849.44032@pali> <20141129175152.GA32510@kroah.com>
	 <201411291904.07644@pali>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Tue, 02 Dec 2014 14:23:19 +0100
Message-ID: <1417526599.15239.7.camel@chaos.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pali, hi Greg,

Le Saturday 29 November 2014 à 19:04 +0100, Pali Rohár a écrit :
> On Saturday 29 November 2014 18:51:52 Greg Kroah-Hartman wrote:
> > On Sat, Nov 29, 2014 at 06:49:43PM +0100, Pali Rohár wrote:
> > > On Saturday 29 November 2014 18:43:15 Greg Kroah-Hartman wrote:
> > > > No Documentation/ABI/ entry for your new sysfs file?
> > > 
> > > It is standard hwmon sysfs entry which is used by other
> > > hwmon drivers... It is not i8k.ko driver specific.
> > 
> > Ok, then why is this driver not in a "hwmon-standard" location
> > in the kernel tree?
> > 
> > greg k-h
> 
> This is question not for me but for maintainers of hwmon and char 
> trees... I just contributed patch for existing driver.
> 
> But my idea is that because this driver exported temperature data 
> for a long time only via /proc/i8k character file (since 2.4? or 
> earlier?) and only 3 years ago was added standard hwmon interface 
> to existing code (949a9d70020defd7c241607ab3ed037ea88f551c).
> 
> So now there are both interfaces. Standard hwmon and old /proc/.
> 
> CCing Jean Delvare (author of hwmon i8k code)

Yes, that's for historical reasons. Also the i8k driver does more than
just hardware monitoring, it handles function keys and power status too.
And it is heavily platform-specific. So while I agree that drivers/char
isn't necessarily the best place for this driver, I'd rather move it to
drivers/platform/x86 together with other laptop vendor-specific drivers,
than to drivers/hwmon.

Ultimately /proc/i8k should be killed altogether and every function
should use the appropriate standard interface. But I don't have any Dell
laptop around so I won't go into that myself.

-- 
Jean Delvare
SUSE L3 Support

