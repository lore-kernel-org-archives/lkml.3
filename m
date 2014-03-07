Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077AbaCGSRZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 13:17:25 -0500
Received: from mail-pd0-f195.google.com ([209.85.192.195]:32950 "EHLO
	mail-pd0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbaCGSRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 13:17:23 -0500
Date: Fri, 7 Mar 2014 10:17:18 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Laszlo Papp <lpapp@kde.org>
Cc: Jean Delvare <jdelvare@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        lm-sensors@lm-sensors.org
Subject: Re: Tachometer speed returned rather than absolute fan speed?
Message-ID: <20140307181718.GA1027@roeck-us.net>
References: <CAOMwXhPXPN+21N11cHBENvw0QZ1qPvo9GTbM9V2SwDmgBQZssw@mail.gmail.com>
 <20140307162524.6abd34be@endymion.delvare>
 <CAOMwXhOB=1HA57jwKCx3-hU8A_ypjrm0J3R9huO25xa4B_gw8w@mail.gmail.com>
 <20140307163717.336873f5@endymion.delvare>
 <CAOMwXhPpObWqd1vR3t+ifKd-_ZbnGTm1TNNUakmVAR3CB=pzTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMwXhPpObWqd1vR3t+ifKd-_ZbnGTm1TNNUakmVAR3CB=pzTg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 03:47:08PM +0000, Laszlo Papp wrote:
> On Fri, Mar 7, 2014 at 3:37 PM, Jean Delvare <jdelvare@suse.de> wrote:
> >> > I'm quite confused. While I admit that the term "tachometer speed" is
> >> > awkward, the max6650 driver is reporting fan speeds in RPM as every
> >> > other hwmon driver. So I really have no idea what you think is wrong.
> >> > What did you think "tachometer speed" was, if not the fan speed? Does
> >> > the max6650 driver not return correct fan speeds for you?
> 
> That is some strange behavior. If I do "echo 1 > pwm1_enable; echo 0 >
> pwm1; cat fan1_input", I still see 30 for the connected fan, whereas I
> can see it stopped. Is this an expected behavior? I would expect zero
> as a user.
> 
I seem to recall that I had seen that as well, with no fan connected.
Maybe the tachometer registers always read at least '1'. I would think
it is wrong, but we'll have to understand the chip a bit better
to be able to provide a fix. Unless you already have a fix ready,
of course. I'll try to re-test tonight if I find the time.

Guenter
