Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934899Ab3CZQIN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 12:08:13 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:64742 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933665Ab3CZQIJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 12:08:09 -0400
MIME-Version: 1.0
In-Reply-To: <20130326154442.GE18316@opensource.wolfsonmicro.com>
References: <201302170046.26569@pali>
	<201303242345.00176@pali>
	<20130324230435.GE18316@opensource.wolfsonmicro.com>
	<201303261602.40219@pali>
	<20130326154442.GE18316@opensource.wolfsonmicro.com>
Date: Tue, 26 Mar 2013 09:08:08 -0700
X-Google-Sender-Auth: fkLgM2PUwUUnzDHWbgejvac7n1c
Message-ID: <CA+55aFwYvq5fZawbDVDPBu0ox2W7DQf5JmmyQHJYpBTOOTu_nQ@mail.gmail.com>
Subject: Re: Driver lis3lv02d_i2c not working on Nokia RX-51
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Eric Piel <eric.piel@tremplin-utc.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 8:44 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Tue, Mar 26, 2013 at 04:02:39PM +0100, Pali Rohár wrote:
>
>> What do you think how to fix this problem? I do not know about any
>> HW regulator for n900 accelerometer and possible solutions could
>> be revert that commit or adding fake regulator to board code...
>
> Reverting the fix is not an option, this is a clear bug in the platform.
>
> There will be a regulator here, the device needs power.

Bullshit.

This is a regression, and it needs to be fixed. The "device needs
power" crap is just that - crap. Nobody cares. OF COURSE all devices
need power, but that is totally irrelevant for a driver. The SSD in my
system "needs power", but I have absolutely zero regulator information
for it NOR DO I F*CKING NEED ANY!

Claiming that we need to know the power regulator for an accelerometer
is total utter idiocy and crap.

I'm going to revert that commit unless you can fix it some other way
(dummy regulators when you can't find a real one or whatever). The
notion that you have to have regulator information in order to use
some random device is insanity. I don't understand how you can even
start to make excuses like that. It's so obviously bogus that it's not
even funny.

Why do I have to explain the "no regressions" to long-time kernel
maintainers EVERY SINGLE RELEASE? What the f*ck is *wrong* with you
people? Seriously?

          Linus
