Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366AbaCORc3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 13:32:29 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:47740 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756102AbaCORc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 13:32:27 -0400
MIME-Version: 1.0
X-Originating-IP: [85.250.70.16]
In-Reply-To: <20140314152304.GS18529@joshc.qualcomm.com>
References: <1389658764-39199-1-git-send-email-s-anna@ti.com>
 <1389658764-39199-5-git-send-email-s-anna@ti.com> <CAJAp7Oi7wD+VsMAd37gT04yZ4TH4ygXFmheDhvmWuanUjpBmVQ@mail.gmail.com>
 <52F92524.3080402@ti.com> <CAK=WgbY0wDtGCm71E8VXi2g5+VcGogHEy8jdekTRg8xtp6-3rQ@mail.gmail.com>
 <CAJAp7Ohf43hbKatCwS5Y1+OfEkJYWOkuhZhW-E_=t_9mfM+UaA@mail.gmail.com>
 <CAK=WgbYS+eJSTBXF=OeWjuL6iSbH+Y1RYewARKh9yAXHKKZ_cA@mail.gmail.com> <20140314152304.GS18529@joshc.qualcomm.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sat, 15 Mar 2014 19:32:05 +0200
Message-ID: <CAK=WgbZWqih3R36wYzo2uaw1-C3S_RHx7mrtFTnQxLhww0AWnw@mail.gmail.com>
Subject: Re: [PATCHv4 4/7] hwspinlock/core: add common OF helpers
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Bjorn Andersson <bjorn@kryo.se>, Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Suman Anna <s-anna@ti.com>, Tony Lindgren <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 5:23 PM, Josh Cartwright <joshc@codeaurora.org> wrote:
> So, are you suggesting that because fatal errors should be "extremely
> rare", a consuming driver should just assume that if NULL is returned
> from a hwspin_lock_request*() function that it was the "device not yet
> probed" case that was hit?

No - it's not the scarcity, it's the severity.

The error path that will be optimized here is an invalid id. If this
happens, the consumer will crash and burn, and I'm not sure that
slightly optimizing his death is very interesting?

BTW the hwspinlock core once did use ERR_PTR and friends, and it was
changed due to convincing arguments against that methodology on this
mailing list. We can change it back but we need a strong(er) case.

> Note that having the consumer/hwspinlock device relationship modeled in
> devicetree introduces more potential failure cases...

Yeah. Even the error above, presumed to be EPROBE_DEFER, may be a
symptom of some other fatal error that occurred, and we can't be sure
that a future request will surely be satisfied. So before we bloat our
code, I suggest that we wait for consumers to show up and see if
there's real benefit.

Thanks,
Ohad.
