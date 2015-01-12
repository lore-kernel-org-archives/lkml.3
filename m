Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbbALRZr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 12:25:47 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:55873 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbbALRZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 12:25:44 -0500
Date: Mon, 12 Jan 2015 09:25:37 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Jim Davis <jim.epost@gmail.com>
Cc: linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, jdelvare@suse.de,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, lm-sensors@lm-sensors.org,
        devicetree <devicetree@vger.kernel.org>, Nishanth Menon <nm@ti.com>,
        Eduardo Valentin <edubezval@gmail.com>
Subject: Re: randconfig build error with next-20150112, in
 drivers/hwmon/gpio-fan.c
Message-ID: <20150112172537.GA19868@roeck-us.net>
References: <CA+r1Zhh4EXQ_0pYZfL4jB=F8unP7+jzp7LVL2RRL+urU3srj3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+r1Zhh4EXQ_0pYZfL4jB=F8unP7+jzp7LVL2RRL+urU3srj3A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020201.54B40397.031E,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 3
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 09:53:05AM -0700, Jim Davis wrote:
> Building with the attached random configuration file,
> 
> drivers/built-in.o: In function `gpio_fan_remove':
> gpio-fan.c:(.text+0x6efea): undefined reference to
> `thermal_cooling_device_unregister'
> drivers/built-in.o: In function `gpio_fan_probe':
> gpio-fan.c:(.text+0x6f376): undefined reference to
> `thermal_cooling_device_register'
> make: *** [vmlinux] Error 1

Hi Jim,

thanks for the note.

Hmm .. turns out those functions don't define dummies if CONFIG_THERMAL
is not configured. How annoying.

Nishant, please fix your gpio-fan patch. I am going to drop it for now.
Please keep in mind that there is a secondary dependency: The thermal
code can be built as module. In that case, the gpio-fan driver must
either also be built as module, or its thermal registration must be
disabled.

Guenter
