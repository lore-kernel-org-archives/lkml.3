Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479AbaK1XZh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 18:25:37 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:46306 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbaK1XZf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 18:25:35 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [RFC] i2c: omap: TEST: do IP reset during probe.
From: Alexander Kochetkov <al.kochet@gmail.com>
In-Reply-To: <20141128221350.GW2817@atomide.com>
Date: Sat, 29 Nov 2014 02:25:29 +0300
Cc: Kevin Hilman <khilman@kernel.org>, linux-omap@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Wolfram Sang <wsa@the-dreams.de>
Content-Transfer-Encoding: 8BIT
Message-Id: <E4A4FA05-0752-41CB-B86B-84035C6EAF05@gmail.com>
References: <1416685634-5864-3-git-send-email-al.kochet@gmail.com> <1417028722-29306-1-git-send-email-al.kochet@gmail.com> <7hzjbdd57j.fsf@deeprootsystems.com> <20141128221350.GW2817@atomide.com>
To: Tony Lindgren <tony@atomide.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Tony!

I just want to know, is multimaster i2c feature is interesting for TI SOC,
so I could send another patches?

Or it's better to leave the thing without changes, as current single master version
well tested and work?

Also I have a draft version of mixed multimaster/slave version. But it could introduce new bugs.
Are we ready for that? Thats because IP behavior, sometimes, doesn't correspond to TRMs[4][5].
It's the one of strange IP I ever seen on TI SOC. And TRM not as detailed as DSP TRMs.

Yes, I test the patch. But  IP handling is really tricky.
So, I doubt.

Looks, like you haven't seen my response in another thread[1].
So, duplicate it here.

24.11.2014 22:47, Tony Lindgren <tony@atomide.com> *:

> If you post a patch, I can test boot with it. Looks like the failing
> ones have i2c rev3.3 on 34xx vs rev4.4 on 36xx.

> So I doubt we just want to change the test for for a higher rev number
> for  OMAP_I2C_REV_ON_3430_3530.

You 100% right here.
My fault.
Thank you for giving right directions.
Thanks Kevin for running test, so I could debug the reason.

Functional mode bits are unimplemented in the SYSTEST register on omap3530.
"10:5 Reserved Write 0s for future compatibility. Read returns 0."
That was the reason. SYSTEST always 0.

It is possible (and I could do it) to implement the bus check using SYSTEST SDA/SCL loopback mode.

One more problem, I found that BB-check from the patch[2] sometimes (very rarely) doesn't work
as expected. Sometimes the master start transfer while bus is in use by another master. 
It happens if another master continuously read from eeprom array of 0xff.

So, one of problems on the way of running IP in a multimaster mode, is BB-bit behavior.
I reported the problem to ti forum[3] and expect some response.

Regards,
Alexander.

[1] http://www.spinics.net/lists/linux-i2c/msg17797.html
[2] http://www.spinics.net/lists/linux-i2c/msg17678.html
[3] http://e2e.ti.com/support/dsp/davinci_digital_media_processors/f/537/t/383876.aspx
[4] omap3530 - TRM - spruf98y
[5] AM-DM37x Multimedia Device Silicon Revision 1.x  - sprugn4r

