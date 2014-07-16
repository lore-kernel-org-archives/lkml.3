Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933493AbaGPMaG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 08:30:06 -0400
Received: from smtprelay02.ispgateway.de ([80.67.31.40]:40777 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933140AbaGPMaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 08:30:03 -0400
X-Greylist: delayed 3337 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Jul 2014 08:30:03 EDT
Message-ID: <53C6633D.9080905@ladisch.de>
Date: Wed, 16 Jul 2014 13:34:21 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        Peter Zijlstra <peterz@infradead.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: firewire: CLOCK_MONOTONIC_RAW exposure
References: <alpine.DEB.2.10.1407161151450.24854@nanos>
In-Reply-To: <alpine.DEB.2.10.1407161151450.24854@nanos>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> I wonder why firewire exposed CLOCK_MONOTONIC_RAW to user space.
>
> What's the purpose of that? CLOCK_MONOTONIC_RAW is the raw time based
> on the initial frequency setup of the clocksource. That can be quite
> off from the NTP corrected frequency which is exposed by
> CLOCK_MONOTONIC.

The purpose is to get a stable clock, i.e., to avoid clock rate changes
caused by NTP corrections.

ALSA is adding CLOCK_MONOTONIC_RAW for the same reason.


Regards,
Clemens
