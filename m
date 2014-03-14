Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173AbaCNNMu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 09:12:50 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:61552 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503AbaCNNMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 09:12:48 -0400
MIME-Version: 1.0
X-Originating-IP: [85.250.70.16]
In-Reply-To: <CAJAp7Ohf43hbKatCwS5Y1+OfEkJYWOkuhZhW-E_=t_9mfM+UaA@mail.gmail.com>
References: <1389658764-39199-1-git-send-email-s-anna@ti.com>
 <1389658764-39199-5-git-send-email-s-anna@ti.com> <CAJAp7Oi7wD+VsMAd37gT04yZ4TH4ygXFmheDhvmWuanUjpBmVQ@mail.gmail.com>
 <52F92524.3080402@ti.com> <CAK=WgbY0wDtGCm71E8VXi2g5+VcGogHEy8jdekTRg8xtp6-3rQ@mail.gmail.com>
 <CAJAp7Ohf43hbKatCwS5Y1+OfEkJYWOkuhZhW-E_=t_9mfM+UaA@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Fri, 14 Mar 2014 15:12:26 +0200
Message-ID: <CAK=WgbYS+eJSTBXF=OeWjuL6iSbH+Y1RYewARKh9yAXHKKZ_cA@mail.gmail.com>
Subject: Re: [PATCHv4 4/7] hwspinlock/core: add common OF helpers
To: Bjorn Andersson <bjorn@kryo.se>
Cc: Suman Anna <s-anna@ti.com>, Mark Rutland <mark.rutland@arm.com>,
        Tony Lindgren <tony@atomide.com>, Kumar Gala <galak@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 2, 2014 at 10:19 PM, Bjorn Andersson <bjorn@kryo.se> wrote:
> When introducing the ability to reference a hwspin lock via a phandle
> in device tree it makes a big difference to be able to differ between
> the case of "initialization failed" or "device not yet probed"; so
> that the client knows if it should fail or retry later.

I'm not convinced.

The only advantage this brings is to avoid retrying in case a fatal
error has occurred. Such fatal errors are extremely rare, and when
they show up - extremely painful, and I suspect that optimizing them
wouldn't be a big win.

OTOH, keeping the code easier to read and less error prone is a big
win. I prefer we keep it simple for now.

Thanks,
Ohad.
