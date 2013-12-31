Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465Ab3LaSuk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 13:50:40 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:39386 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756166Ab3LaSuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 13:50:39 -0500
Date: Tue, 31 Dec 2013 10:50:36 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: "Felipe F. Tonello" <eu@felipetonello.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] input: mt: Add helper function to send end events
Message-ID: <20131231185035.GD6897@core.coreip.homeip.net>
References: <1388455601-17033-1-git-send-email-eu@felipetonello.com>
 <52C28DC7.9020003@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52C28DC7.9020003@euromail.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On Tue, Dec 31, 2013 at 10:26:31AM +0100, Henrik Rydberg wrote:
> Hi Felipe,
> 
> > Adds a helper function to send end touch events for active tracking ids.
> > And also implements it in egalax driver.
> 
> What problematic scenario is this supposed to solve?
> 
> The 'release on suspend' is only an approximation to the 'close
> laptop' scenario, it is certainly not correct in the coffee table
> case,

Why would it not be correct for coffee table? Do we expect the touches
to remain valid while the device is asleep?

> for instance. Instead of
> hardcoding this in the kernel, userland can easily detect long intervals
> directly using the event time.

But with slots it is not only problem with old events being sent out
later, it is that we have mix of old (pre-sleep) and new state.

> 
> Unless there is already a reasonable mechanism in your user
> application which deals with cases like this but fails to account for
> your particular problem scenario, the patch will not be applied.
> 

We do that for keys (release them when we transition to system sleep)
and I think it might be worthwhile to do the same for touch data.

Thanks.

-- 
Dmitry
