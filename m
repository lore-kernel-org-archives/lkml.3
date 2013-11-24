Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab3KXReS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 12:34:18 -0500
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:29264 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752344Ab3KXReP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 12:34:15 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: small regression: hwmon: (applesmc) Check key count before proceeding - 5f4513864304672e6ea9eac60583eeac32e679f2
From: Chris Murphy <bugzilla@colorremedies.com>
In-Reply-To: <5291CA7B.3080904@euromail.se>
Date: Sun, 24 Nov 2013 09:22:52 -0700
Cc: Michele Baldessari <michele@acksyn.org>, jwboyer@fedoraproject.org,
        Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org, Chris Murphy <chris@cmurf.com>
Content-Transfer-Encoding: 7BIT
Message-Id: <76837691-ED07-4448-BC56-9D16EA321970@colorremedies.com>
References: <20131124092359.4241e633@fante.int.rhx> <5291CA7B.3080904@euromail.se>
To: Henrik Rydberg <rydberg@euromail.se>
X-Mailer: Apple Mail (2.1510)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - slmp-550-94.slc.westdc.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - colorremedies.com
X-Get-Message-Sender-Via: slmp-550-94.slc.westdc.net: authenticated_id: whatever@colorremedies.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 24, 2013, at 2:44 AM, Henrik Rydberg <rydberg@euromail.se> wrote:

> Hi Michele,
> 
>> The issue Chris has seen in Fedora on one MacBookPro4,1
>> (https://bugzilla.redhat.com/show_bug.cgi?id=1033414) is that this
>> machine returns a huge number from read_register_count() so now we will
>> try to allocate an insane amount of memory and we will barf:
>> [    8.603053] applesmc: key count changed from 261 to 1392508929
> 
> I was under the impression that this machine was tested before, and that
> 
> commit 25f2bd7f5add608c1d1405938f39c96927b275ca
> Author: Henrik Rydberg <rydberg@euromail.se>
> Date:   Wed Oct 2 19:15:03 2013 +0200
> 
>    hwmon: (applesmc) Always read until end of data
> 
> resolved this problem? But if the kernel under test is 3.11.8, both patches are
> already present... Chris, could you please sched some light on this before
> moving on?

Well, it seems to be a another one off event. It's the same hardware as before, and it was booting from a USB stick containing Fedora 20 final test candidate 2 which uses kernel 3.11.8. An immediate reboot did not reproduce the problem, nor multiple subsequent reboots. I think I previously mentioned a preponderance of these events happen when booting from USB sticks.

It would be nice to have an identical model for this testing. I suspect most users wouldn't go to the trouble to report the occasional, seemingly one off, events like this. So unfortunately it's  uncertain if the hardware I have has a unique problem, or if it's a model specific behavior.


Chris Murphy