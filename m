Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038Ab3DYGdL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 02:33:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:11636 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754759Ab3DYGdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 02:33:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,548,1363158000"; 
   d="scan'208";a="301312225"
Date: Thu, 25 Apr 2013 14:30:45 +0800
From: Feng Tang <feng.tang@intel.com>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Kay Sievers <kay@vrfy.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] time: Revert ALWAYS_USE_PERSISTENT_CLOCK compile time
 optimizaitons
Message-ID: <20130425063045.GA2597@feng-snb>
References: <1366828376-18124-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366828376-18124-1-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 11:32:56AM -0700, John Stultz wrote:
> Kay Sievers noted that the ALWAYS_USE_PERSISTENT_CLOCK config,
> which enables some minor compile time optimization to avoid
> uncessary code in mostly the suspend/resume path could cause
> problems for userland.
> 
> In particular, the dependency for RTC_HCTOSYS on
> !ALWAYS_USE_PERSISTENT_CLOCK, which avoids setting the time
> twice and simplifies suspend/resume, has the side effect
> of causing the /sys/class/rtc/rtcN/hctosys flag to always be
> zero, and this flag is commonly used by udev to setup the
> /dev/rtc symlink to /dev/rtcN, which can cause pain for
> older applications.
> 
> While the udev rules could use some work to be less fragile,
> breaking userland should strongly be avoided. Additionally
> the compile time optimizations are fairly minor, and the code
> being optimized is likely to be reworked in the future, so
> lets revert this change.
> 
> I suspect this will miss 3.9-final, so marking it for 3.9-stable.

thanks

Acked-by: Feng Tang <feng.tang@intel.com>

