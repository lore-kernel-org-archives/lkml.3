Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab3JIQxB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 12:53:01 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:42357 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372Ab3JIQw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 12:52:58 -0400
Date: Wed, 9 Oct 2013 09:52:50 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Chris Murphy <bugzilla@colorremedies.com>,
        Josh Boyer <jwboyer@fedoraproject.org>, khali@linux-fr.org,
        lm-sensors@lm-sensors.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: applesmc oops in 3.10/3.11
Message-ID: <20131009165250.GA15366@roeck-us.net>
References: <524C1FE1.4050207@roeck-us.net>
 <20131002163418.GA4557@polaris.bitmath.org>
 <20131002164718.GA7392@roeck-us.net>
 <20131002172410.GA381@polaris.bitmath.org>
 <525346D3.30500@roeck-us.net>
 <6918F624-B267-4DB5-95A2-7E09448CA3E4@colorremedies.com>
 <20131008154809.GB18402@roeck-us.net>
 <20131008162917.GA7773@polaris.bitmath.org>
 <20131008162905.GA20665@roeck-us.net>
 <20131009082939.GA13963@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131009082939.GA13963@polaris.bitmath.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 09, 2013 at 10:29:39AM +0200, Henrik Rydberg wrote:
> From 18fa0f55b764ad0fe5fc49f81bae281e5110ed56 Mon Sep 17 00:00:00 2001
> From: Henrik Rydberg <rydberg@euromail.se>
> Date: Wed, 2 Oct 2013 19:15:03 +0200
> Subject: [PATCH] hwmon: (applesmc) Always read until end of data
> 
> The crash reported and investigated in commit 5f4513 turned out to be
> caused by a change to the read interface on newer (2012) SMCs.
> 
> Tests by Chris show that simply reading the data valid line is enough
> for the problem to go away. Additional tests show that the newer SMCs
> no longer wait for the number of requested bytes, but start sending
> data right away.  Apparently the number of bytes to read is no longer
> specified as before, but instead found out by reading until end of
> data. Failure to read until end of data confuses the state machine,
> which eventually causes the crash.
> 
> As a remedy, assuming bit0 is the read valid line, make sure there is
> nothing more to read before leaving the read function.
> 
> Tested to resolve the original problem, and runtested on MBA3,1,
> MBP4,1, MBP8,2, MBP10,1, MBP10,2. The patch seems to have no effect on
> machines before 2012.
> 
> Tested-by: Chris Murphy <chris@cmurf.com>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>

Applied. I'll do my usual sanity testing and send it to Linus
either tomorrow or Friday.

Thanks,
Guenter
