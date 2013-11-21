Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab3KUKMj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 05:12:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17783 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913Ab3KUKMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 05:12:37 -0500
Date: Thu, 21 Nov 2013 11:12:34 +0100
From: Miroslav Lichvar <mlichvar@redhat.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Richard Cochran <richardcochran@gmail.com>, linux-kernel@vger.kernel.org,
        Prarit Bhargava <prarit@redhat.com>
Subject: Re: [PATCH RFC] timekeeping: Fix clock stability with nohz
Message-ID: <20131121101234.GB23627@localhost>
References: <1384440640-9482-1-git-send-email-mlichvar@redhat.com>
 <20131116070304.GB4355@netboy>
 <528A8667.7000304@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528A8667.7000304@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 01:28:07PM -0800, John Stultz wrote:
> Also is this brokenness something that has been around for awhile for
> you or more recently cropped up?  I'm wondering as nohz idle has been
> around for quite a few years and I've not seen too many complaints. So
> I'm wondering if I'm looking in the right places, or if something has
> regressed recently, or if its just that accuracy expectations have gone up?

I think the problem was there right from the beginning when the
internal synchronization loop was introduced, but before PTP hardware
clocks there might not had been a reference which could be used to
evaluate the stability of the system clock at this level. The quantum
mechanical property of the problem that it disappears when you
increase sampling doesn't help much either :).

IIRC the first time I noticed something wasn't quite alright was in
2009 when I wrote a PPS refclock driver for chrony. With a GPS
receiver connected to serial port the synchronization seemed to work
better when the system was loaded. My explanation at the time was that
it's a HW limitation, the interrupt latency/jitter is worse when the
CPU is idle. I had no idea there could be a problem in the kernel
timekeeping.

-- 
Miroslav Lichvar
