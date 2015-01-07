Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637AbbAGC2L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:28:11 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:53038 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932538AbbAGC2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:28:08 -0500
Date: Tue, 6 Jan 2015 20:27:54 -0600
From: David Fries <David@fries.net>
To: Richard Weinberger <richard@nod.at>
Cc: Mariusz Gorski <marius.gorski@gmail.com>,
        Evgeniy Polyakov <zbr@ioremap.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] w1: slaves: w1_therm: Add sysfs entry for current
 temperature
Message-ID: <20150107022754.GA14458@spacedout.fries.net>
References: <1420554596-10250-1-git-send-email-marius.gorski@gmail.com>
 <CAFLxGvwXN0XKQ_fX7pS=dpZf+SoysN_fH8iAgtyMYG9dX+6oAQ@mail.gmail.com>
 <20150106161205.GA2912@firebird>
 <54AC1258.2070004@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54AC1258.2070004@nod.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.9 (SpacedOut.fries.net [127.0.0.1]); Tue, 06 Jan 2015 20:27:55 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 05:50:32PM +0100, Richard Weinberger wrote:
> Am 06.01.2015 um 17:12 schrieb Mariusz Gorski:
> > On Tue, Jan 06, 2015 at 04:01:47PM +0100, Richard Weinberger wrote:
> >> On Tue, Jan 6, 2015 at 3:29 PM, Mariusz Gorski <marius.gorski@gmail.com> wrote:
> >>> DS18B20 and it's brothers are pretty popular in the RaspberryPi world
> >>> when it comes to temperature measurement. All tutorials on the Internet
> >>> use the same way of parsing the output of the w1_slave sysfs file.
> >>> These patches add a dedicated sysfs entry called 'temp' whose only job
> >>> is to output the current temperature.
> >>
> >> And what is the benefit of this patches?
> > 
> > Well, instead of having to parse the output of w1_slave:
> > 
> > $ cat w1_slave 
> > 4d 01 55 00 7f ff 0c 10 fd : crc=fd YES
> > 4d 01 55 00 7f ff 0c 10 fd t=20812
> > 
> > the userspace program gets only the interesting information,
> > which usually is the current temparture:
> 
> A sane user would also check the CRC.

Yes, and more because all 00's will pass a checksum, but be an invalid
reading, because there will be some bit in there outside of the two
temperature return bytes that won't be 0, hence the temperature field
can't be trusted.  All ff's will fail a checksum, but is useful to
know because that pretty much means the sensor is no longer there.

> IMHO it is up to the user to format the output for its needs.
> Some may want "20812", some "20.8", some else maybe "20.8°C".
> Let it up to the user.
> Any trivial awk/cut/etc... oneliner would do it.

I'm not fond of the format of w1_slave printing two sensor readings
and such, it's confusing.  Back in the day (2008) I at least
standardized the t= converted value to millidegrees C.  That was
because DS18B20 gave degrees C where DS18S20 gave millidegrees C, so
it's been worse.

> Thanks,
> //richard

-- 
David Fries <david@fries.net>    PGP pub CB1EE8F0
http://fries.net/~david/
