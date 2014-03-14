Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656AbaCNP0K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 11:26:10 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59005 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727AbaCNP0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 11:26:06 -0400
Date: Fri, 14 Mar 2014 10:23:04 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Bjorn Andersson <bjorn@kryo.se>, Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Suman Anna <s-anna@ti.com>, Tony Lindgren <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv4 4/7] hwspinlock/core: add common OF helpers
Message-ID: <20140314152304.GS18529@joshc.qualcomm.com>
References: <1389658764-39199-1-git-send-email-s-anna@ti.com>
 <1389658764-39199-5-git-send-email-s-anna@ti.com>
 <CAJAp7Oi7wD+VsMAd37gT04yZ4TH4ygXFmheDhvmWuanUjpBmVQ@mail.gmail.com>
 <52F92524.3080402@ti.com>
 <CAK=WgbY0wDtGCm71E8VXi2g5+VcGogHEy8jdekTRg8xtp6-3rQ@mail.gmail.com>
 <CAJAp7Ohf43hbKatCwS5Y1+OfEkJYWOkuhZhW-E_=t_9mfM+UaA@mail.gmail.com>
 <CAK=WgbYS+eJSTBXF=OeWjuL6iSbH+Y1RYewARKh9yAXHKKZ_cA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK=WgbYS+eJSTBXF=OeWjuL6iSbH+Y1RYewARKh9yAXHKKZ_cA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 03:12:26PM +0200, Ohad Ben-Cohen wrote:
> On Sun, Mar 2, 2014 at 10:19 PM, Bjorn Andersson <bjorn@kryo.se> wrote:
> > When introducing the ability to reference a hwspin lock via a phandle
> > in device tree it makes a big difference to be able to differ between
> > the case of "initialization failed" or "device not yet probed"; so
> > that the client knows if it should fail or retry later.
> 
> I'm not convinced.
> 
> The only advantage this brings is to avoid retrying in case a fatal
> error has occurred. Such fatal errors are extremely rare, and when
> they show up - extremely painful, and I suspect that optimizing them
> wouldn't be a big win.

So, are you suggesting that because fatal errors should be "extremely
rare", a consuming driver should just assume that if NULL is returned
from a hwspin_lock_request*() function that it was the "device not yet
probed" case that was hit?

Note that having the consumer/hwspinlock device relationship modeled in
devicetree introduces more potential failure cases...

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
