Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758203AbaGWP1A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:27:00 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:53481 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758070AbaGWP06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:26:58 -0400
Date: Wed, 23 Jul 2014 16:26:49 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: Devicetree List <devicetree@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "ks.giri@samsung.com" <ks.giri@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, ijc@hellion.org.uk,
        Mark Rutland <mark.rutland@arm.com>, robh@kernel.org,
        Pawel Moll <pawel.moll@arm.com>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Matt Porter <mporter@linaro.org>,
        Craig McGeachie <slapdau@yahoo.com.au>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Loic Pallardy <loic.pallardy@st.com>, "Anna, Suman" <s-anna@ti.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        Bjorn Andersson <bjorn@kryo.se>, Patch Tracking <patches@linaro.org>,
        Tetsuya Takinishi <t.takinishi@jp.fujitsu.com>,
        Mark Brown <broonie@linaro.org>, Kevin Hilman <khilman@linaro.org>,
        Mollie Wu <mollie.wu@linaro.org>, Andy Green <andy.green@linaro.org>
Subject: Re: [PATCHv9 2/4] mailbox: Introduce framework for mailbox
Message-ID: <20140723152649.GJ23210@lee--X1>
References: <1406055250-29159-1-git-send-email-jaswinder.singh@linaro.org>
 <1406055374-29275-1-git-send-email-jaswinder.singh@linaro.org>
 <20140723085411.GG23210@lee--X1>
 <CAJe_ZhfaLqgKb3oK-m5Rpae5+zeAEk9-DLFOovq4qjBgg64b-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJe_ZhfaLqgKb3oK-m5Rpae5+zeAEk9-DLFOovq4qjBgg64b-w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jul 2014, Jassi Brar wrote:
> On 23 July 2014 14:24, Lee Jones <lee.jones@linaro.org> wrote:
> > On Wed, 23 Jul 2014, Jassi Brar wrote:
> >> Introduce common framework for client/protocol drivers and
> >> controller drivers of Inter-Processor-Communication (IPC).
> >>
> >> Client driver developers should have a look at
> >>  include/linux/mailbox_client.h to understand the part of
> >> the API exposed to client drivers.
> >> Similarly controller driver developers should have a look
> >> at include/linux/mailbox_controller.h
> >>
> >> Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
> >> ---
> >>  MAINTAINERS                        |   8 +
> >>  drivers/mailbox/Makefile           |   4 +
> >>  drivers/mailbox/mailbox.c          | 467 +++++++++++++++++++++++++++++++++++++
> >>  include/linux/mailbox_client.h     |  45 ++++
> >>  include/linux/mailbox_controller.h | 131 +++++++++++
> >>  5 files changed, 655 insertions(+)
> >>  create mode 100644 drivers/mailbox/mailbox.c
> >>  create mode 100644 include/linux/mailbox_client.h
> >>  create mode 100644 include/linux/mailbox_controller.h

[...]

> >> diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
> >> new file mode 100644
> >> index 0000000..99c0d23
> >> --- /dev/null
> >> +++ b/drivers/mailbox/mailbox.c
> >> @@ -0,0 +1,467 @@
> >> +/*
> >> + * Mailbox: Common code for Mailbox controllers and users
> >> + *
> >> + * Copyright (C) 2013-2014 Linaro Ltd.
> >> + * Author: Jassi Brar <jassisinghbrar@gmail.com>
> >
> > (C) Linaro, but you've supplied your Gmail?
> >
> I don't understand how that's a problem. Is it?
> I always try to post from my Linaro id still.

I don't know to be honest.  I always use my Linaro address when using
Linaro's time (and sometimes when I'm using my own), and plan to
s/linaro.org/gmail.com when/if I move on.  Not sure if there's even a
policy on this, just thought I'd mention it.

[...]

> >> +     if (!dev || !dev->of_node) {
> >> +             pr_debug("%s: No owner device node\n", __func__);
> >
> > Are you sure you want all of this debug prints in the final version?
> >
> pr_debug is as good as absent unless DEBUG is defined

I'm more concerned with how the code looks than the system log, but if
think it will be useful to someone, by all means keep it in.

[...]

> >> +     if (chan->txdone_method == (TXDONE_BY_POLL | TXDONE_BY_ACK))
> >> +             chan->txdone_method = TXDONE_BY_POLL;
> >
> > Unless you're leaving it there for clarity, you can drop the
> > "TXDONE_BY_POLL |" from if().
> >
> We need to check for both.

What I'm trying to get at is; if it's already TXDONE_BY_POLL, there is no
need to set it to TXDONE_BY_POLL.

[...]

> >> +++ b/include/linux/mailbox_controller.h
> >> @@ -0,0 +1,131 @@
> >> +/*
> >> + * This program is free software; you can redistribute it and/or modify
> >> + * it under the terms of the GNU General Public License version 2 as
> >> + * published by the Free Software Foundation.
> >> + */
> >> +
> >> +#ifndef __MAILBOX_CONTROLLER_H
> >> +#define __MAILBOX_CONTROLLER_H
> >> +
> >> +#include <linux/of.h>
> >
> > completion.h
> > device.h
> > timer.h
> >
> > Etc.
> >
> And what else? :)

I'm not going to do all the work for you Jassi. ;)

(Actually, that's as far as I got.  It was more a hint for you to look
to see _if_ there are any others to add, not to say that there were.)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
