Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322AbaLWVnB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 16:43:01 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:60399 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbaLWVm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 16:42:59 -0500
Date: Tue, 23 Dec 2014 22:42:53 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Amir Vadai <amirv@mellanox.com>, Ariel Elior <ariel.elior@qlogic.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        David Miller <davem@davemloft.net>, Frank Li <Frank.Li@freescale.com>,
        John Stultz <john.stultz@linaro.org>,
        Matthew Vick <matthew.vick@intel.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Mugunthan V N <mugunthanvnm@ti.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH net-next 08/11] net: ixgbe: convert to timecounter
 adjtime.
Message-ID: <20141223214253.GA13937@localhost.localdomain>
References: <cover.1418504883.git.richardcochran@gmail.com>
 <5d83679d541974c164cfc415c0bb171e2b363f16.1418504889.git.richardcochran@gmail.com>
 <1419368839.2470.32.camel@jtkirshe-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419368839.2470.32.camel@jtkirshe-mobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2014 at 01:07:19PM -0800, Jeff Kirsher wrote:
> Just for sanity sake, I will have Phillip test the changes, but there is
> no need to hold this up from being committed in the mean time.

FYI, here is a test that may show the improved behavior when comparing
before/after.

1. Start ptp4l, let it run long enough to find the frequency offset.

2. Stop ptp4l with ^C.

3. Wait a bit, to let the clock drift away.

4. Restart ptp4l, it will now start with the frequency offset learned
   in step 1.

5. Notice the the offsets in states s0 -> s1 -> s2.
   There will likely be less offset error with the patches applied.

Thanks,
Richard
