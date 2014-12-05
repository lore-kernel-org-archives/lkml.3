Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933734AbaLEEMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 23:12:37 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:61062 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933657AbaLEEMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 23:12:32 -0500
MIME-Version: 1.0
In-Reply-To: <20141204183406.GK7944@katana>
References: <1417610126-7957-1-git-send-email-harinik@xilinx.com>
	<1417610126-7957-4-git-send-email-harinik@xilinx.com>
	<20141204183406.GK7944@katana>
Date: Fri, 5 Dec 2014 09:42:30 +0530
Message-ID: <CAFcVECL0ShFp-qSHmO8era3okebA4oO85iz+QRWP6fKAEMiN7A@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] i2c: cadence: Check for errata condition involving
 master receive
From: Harini Katakam <harinikatakamlinux@gmail.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vishnum@xilinx.com" <vishnum@xilinx.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Dec 5, 2014 at 12:04 AM, Wolfram Sang <wsa@the-dreams.de> wrote:
>
>> +             /*
>> +              * This controller does not give completion interrupt after a
>> +              * master receive transfer if HOLD bit is set (repeated start),
>> +              * resulting in SW timeout. Hence, if a receive transfer is
>> +              * followed by any other transfer, an error is returned
>> +              * indicating that this sequence is not supported.
>> +              */
>> +             for (count = 0; count < num-1; count++) {
>> +                     if (msgs[count].flags & I2C_M_RD)
>> +                             return -EOPNOTSUPP;
>> +             }
>
> Yeah, a lot better. Probably it would be good to inform the user with a
> warning what went wrong?
>

Sure. I'll add that.

Regards,
Harini
