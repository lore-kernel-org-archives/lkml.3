Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259AbaKTGhT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 01:37:19 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:40088 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbaKTGhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 01:37:16 -0500
MIME-Version: 1.0
X-Originating-IP: [93.173.233.112]
In-Reply-To: <CAJAp7OisV3UrL45UgRb0tMudyCJHe-xsmsRYV0uGG3P4PReHnA@mail.gmail.com>
References: <1410553499-55951-1-git-send-email-s-anna@ti.com>
 <1410553499-55951-6-git-send-email-s-anna@ti.com> <CAK=WgbZE7_WrsNz5E+MDX7j2tAGEjv91zeCgqhB=Jsiu0+d8vw@mail.gmail.com>
 <CAJAp7OisV3UrL45UgRb0tMudyCJHe-xsmsRYV0uGG3P4PReHnA@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 20 Nov 2014 08:36:55 +0200
Message-ID: <CAK=WgbZMY5WyE9aVT3XTDnC3YJyBNXj1QoYBEdUMjwTbYAKA3g@mail.gmail.com>
Subject: Re: [PATCHv6 5/5] hwspinlock/omap: add support for dt nodes
To: Bjorn Andersson <bjorn@kryo.se>
Cc: Suman Anna <s-anna@ti.com>, Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>, Tony Lindgren <tony@atomide.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,

On Thu, Nov 20, 2014 at 2:43 AM, Bjorn Andersson <bjorn@kryo.se> wrote:
> I still have a huge problem understanding the awesomeness with the
> "base_id". If you have a SoC with 2 hwlock blocks; say 8+8 locks, used
> for interaction with e.g. a modem and a video core respectively.
> Why would you in either remote system offset the locks with 8?
> Wouldn't e.g the modem use locks hwlock0:0-7 and video core use locks
> hwlock1:0-7?

Please see below

> What systems use more than one hwlock block

None that we know of. This concern was raised some time ago by Arnd
and since it was easy to deal with we added the 'base_id' notion.

> and do you know of any reasons why these hwlocks are globally numbered?

Because on an heterogeneous asymmetric multiprocessing systems you
sometimes have use cases where hwlocks are dynamically allocated and
their id numbers need to be synchronized between user space
applications, the Linux kernel, and entities running on remote
processors (which are likely not running Linux).

For this to work we have to have some system-wide global hwlocks
naming that is predefined and known to all processors. A mere number
seems like the simplest naming method. A dynamic hwlock request API
could return "hwlock1:0" but a mere 8 seems easier to deal with.

Thanks,
Ohad.
