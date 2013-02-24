Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759357Ab3BXRNe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 12:13:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757952Ab3BXRNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 12:13:33 -0500
Message-ID: <512A4A19.2090800@redhat.com>
Date: Sun, 24 Feb 2013 12:12:57 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Matt Fleming <matt.fleming@intel.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, linux-efi@vger.kernel.org,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [RFE PATCH 1/2] x86, rtc, ntp, Do full rtc synchronization with
 ntp
References: <1360861375-24131-1-git-send-email-prarit@redhat.com> <1360861375-24131-2-git-send-email-prarit@redhat.com> <5127D853.6030703@linaro.org>
In-Reply-To: <5127D853.6030703@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/22/2013 03:42 PM, John Stultz wrote:
> 
> 
> This looks reasonable to me.
> 
> Though I want to make sure we get this thoroughly tested by the various distros
> so we don't surprise anyone, since it has to potential to cause problems where
> folks are dualbooting windows (using a localtime RTC) and do not have their OS
> setup to trigger warp_clock to adjust for the localtime rtc (instead getting a
> time correction later via NTP).
> 
> I'll queue it and see about getting it merged to -tip & -next. Then we'll have
> to decide if 3.10 or 3.11 is the right time frame to land it.
> 

cc'ing Alessandro as well.

John, I've been testing this across various systems (including those known to
have some wonkiness with the RTC in BIOS ... see comment below) to see if this
code impacts anything.

I've tested mainly using Fedora 18 (with the latest kernel -tip obviously), but
I also installed Ubuntu on a system to see if there was any noticeable impact
there too.  I have not seen any unusual testing failures on AMD or Intel systems.

On the one system which I know to have "weak" battery such that the RTC doesn't
"stick" on the system shutdown the clock resets itself in BIOS reboot to "Jan 1
1970".  When I tested previously I could not get the RTC written to the current
date; after my changes, the RTC does at least reflect the current date through a
reboot.  It should be noted that if I do replace the battery on this system I
can get the RTC to properly "stick" through a reboot.

Given the test results I think this should go in earlier rather than later;  I'd
like to target 3.10 for the full sync, and possibly 3.11 for the HCTOSYS stuff.

... unless anyone has a strenuous objection ;)

P.
