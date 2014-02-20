Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbaBTBja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 20:39:30 -0500
Received: from mail-ve0-f175.google.com ([209.85.128.175]:33171 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbaBTBj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 20:39:28 -0500
MIME-Version: 1.0
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31DCC6F8@ORSMSX106.amr.corp.intel.com>
References: <cover.1387588711.git.luto@amacapital.net> <15eccfa508fd0f55230c4274e3e968f91a123b73.1387588711.git.luto@amacapital.net>
 <20140219151626.GA13973@katana> <CALCETrVBPzGqaXbZVgUZMw7D5U5YnUMJOEsw1r=TceLYjJ39JA@mail.gmail.com>
 <20140220035128.14da0f79.m.chehab@samsung.com> <3908561D78D1C84285E8C5FCA982C28F31DCC6F8@ORSMSX106.amr.corp.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 19 Feb 2014 17:39:07 -0800
Message-ID: <CALCETrVwSj3KGcPqQD2Kd9W5FCHyPWLukCVr0BZLdQc_Fgz4qA@mail.gmail.com>
Subject: Re: [PATCH v6 4/4] i2c, i2c_imc: Add DIMM bus code
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rui Wang <ruiv.wang@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 11:03 AM, Luck, Tony <tony.luck@intel.com> wrote:
>> (I'm c/c Tony here, as he also shared the same concern that I had on a
>> previous feedback about using I2C to talk with the DIMM).
>
> Correct - I've heard the same issues that reads on I2C can be misinterpreted
> as writes ... and oops, you have a brick.

Is this true on DDR3 DIMMs, i.e. anything that's compatible with
LGA2011?  If you plug a DIMM into an LGA2011 board's memory slot,
then, one way or another, it's very likely that there will be TSOD
traffic, if for no other purpose than to determine that there is no
TSOD present.  TSOD traffic consists of reads and writes, both with
and without register numbers.  (Sorry, I can never remember the smbus
terminology here -- the relevant transactions are two-byte reads and
two-byte writes, both with a command specified and without one.  One
of the bits in the iMC SMBUS registers tells the controller which kind
of read to use to probe the thermometer.)

>
> What is the larger context/  What problem are we trying to solve?

NV-DIMM control registers are exposed via i2c, presumably because
trying to access them through the memory pins would be a giant mess.
So, one way or another, something needs to be able to initiate
transactions to access those registers.  BIOS will do some initial
setup, but the OS will need to poke at these registers, too.  (The
actual docs are covered by NDA.  I suspect that this will change if
the manufacturers ever want these things to be widely used, though,
since these things really want a full-featured kernel driver so that
things like pmfs will work cleanly.)

As a secondary benefit, having access to the TSOD and SPD is nice,
albeit far from critical.

AFAICT Intel actively working on NV-DIMM-related things, so maybe
Intel will contribute an engineer who help :)

--Andy

>
> -Tony



-- 
Andy Lutomirski
AMA Capital Management, LLC
