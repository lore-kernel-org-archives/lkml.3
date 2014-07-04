Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbaGDE7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 00:59:20 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:61799 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbaGDE7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 00:59:18 -0400
MIME-Version: 1.0
X-Originating-IP: [89.139.36.201]
In-Reply-To: <53B59471.30703@ti.com>
References: <1398904476-26200-1-git-send-email-s-anna@ti.com>
 <1398904476-26200-5-git-send-email-s-anna@ti.com> <CAK=WgbbZvBLT7U638fBfPjF7-MJaP=4WJcrT_fEg6Uu3cXRAyg@mail.gmail.com>
 <53B47626.4040506@ti.com> <CAK=WgbbJ6a17wrsEcvNq6tPiaciQ=E+22QE06t9EA8RFqicNRg@mail.gmail.com>
 <53B59471.30703@ti.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Fri, 4 Jul 2014 07:58:56 +0300
Message-ID: <CAK=WgbbZYwfOyeZuDTX2RXtEdYzsZc++crHZ-ZAqeiWds0BCcg@mail.gmail.com>
Subject: Re: [PATCHv5 04/15] hwspinlock/core: add common OF helpers
To: Suman Anna <s-anna@ti.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Bjorn Andersson <bjorn@kryo.se>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suman,

On Thu, Jul 3, 2014 at 8:35 PM, Suman Anna <s-anna@ti.com> wrote:
> Not at the moment, with the existing platform implementations. So, if I
> understand you correctly, you are asking to leave out the xlate ops and
> make the of_hwspin_lock_simple_xlate() internal until a need for an
> xlate method arises.

Yes, please. It seems to me this way we're reducing complexity without
compromising anything.

> This also means, we only support a value of 1 for #hwlock-cells.

When a different #hwlock-cells value shows up, someone would have to
write a new xlate implementation anyway. At the same time, the xlate
ops could be brought back quite easily.

Since we're not imposing anything on the DT data, this doesn't affect
our ability to support these scenarios in the future, but unless I'm
missing a current use case, these scenarios right now seems somewhat
fictional.

> But, that would mean DT-based client users would have to invoke two
> function calls to request a hwspinlock. We already have an API to get
> the lock id given a hwspinlock - hwspin_lock_get_id(), so I added the OF
> API for requesting a lock directly rather than giving an OF API for
> getting the lock id. This is in keeping in convention with what other
> drivers do normally - a regular get and an OF get. I can modify it if
> you still prefer the OF API for getting a global lock id, but I feel its
> a burden for client users.

Let's discuss this.

I was actually thinking of the more general use case of an heterogenous system:

- driver gets the global lock id from a remote processor
- driver then requests the specific lock

Looking at these cases, the OF scenario only differs in the small part
of fetching the lock id, and if we keep the regular request_specific
API we'll have more common code between drivers.

What do you think?

> Also, do you prefer an open property-name in client users (like I am
> doing at the moment) or imposing a standard property name "hwlocks"?

Good point - I think we can start with an imposed "hwlocks" name, and
evolve in the future as needed (again, only because we're not really
imposing anything on the DT data - this is just kernel code that we
could always extend as needed).

Thanks,
Ohad.
