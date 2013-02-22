Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102Ab3BVQZq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 11:25:46 -0500
Received: from linux-sh.org ([111.68.239.195]:40305 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757478Ab3BVQZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 11:25:43 -0500
Date: Sat, 23 Feb 2013 01:25:00 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/8] ARM: smp: Remove local timer API
Message-ID: <20130222162458.GA19670@linux-sh.org>
References: <1361518039-16663-1-git-send-email-sboyd@codeaurora.org>
 <1361518039-16663-9-git-send-email-sboyd@codeaurora.org>
 <20130222111545.GA15020@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130222111545.GA15020@e106331-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2013 at 11:15:45AM +0000, Mark Rutland wrote:
> One thing that struck me when I was fiddling with the broadcast mechanism was
> that it should be possible to have a generic dummy timer implementation. As
> long as the architecture calls notifiers at the appropriate times, it should
> look like any other timer driver (apart from not touching any hardware). It just
> needs to depend on ARCH_HAS_TICK_BROADCAST.
> 
> I believe it shouldn't be too difficult to implement, though I may be blind to
> some problems.
> 
It would be nice to have a generic dummy timer driver, quite a few
architectures could use it directly already. If no one beats me to it,
I'll give it a go as I convert the SH stuff over to using
ARCH_HAS_TICK_BROADCAST and killing off the local timer API there.
