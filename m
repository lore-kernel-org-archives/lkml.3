Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751354AbaCaWFK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 18:05:10 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:62555 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbaCaWFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 18:05:07 -0400
MIME-Version: 1.0
In-Reply-To: <CABb+yY3N0e3yTf=+2aqM0gWM8xcnybBWNSJxGezUC5uckAQBGg@mail.gmail.com>
References: <1395168335-29119-1-git-send-email-jaswinder.singh@linaro.org>
	<1396044491-22854-1-git-send-email-markus.mayer@linaro.org>
	<CABb+yY3N0e3yTf=+2aqM0gWM8xcnybBWNSJxGezUC5uckAQBGg@mail.gmail.com>
Date: Mon, 31 Mar 2014 15:05:05 -0700
Message-ID: <CAPdLdqkDCYS7WsgkofJt78ztGTixQ9P+gVhkJZxteQL-YvwbKQ@mail.gmail.com>
Subject: Re: [PATCHv4,2/5] mailbox: Introduce framework for mailbox
From: Markus Mayer <markus.mayer@linaro.org>
To: Jassi Brar <jassisinghbrar@gmail.com>
Cc: Linux Kernel Mailing list <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, Suman Anna <s-anna@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        "Omar Ramirez Luna (omar.ramirez@copitl.com)" 
	<omar.ramirez@copitl.com>,
        Loic Pallardy <loic.pallardy@st.com>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Craig McGeachie <slapdau@yahoo.com.au>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Rob Herring <robherring2@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Josh Cartwright <joshc@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kumar Gala <galak@codeaurora.org>, Girish K S <ks.giri@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 March 2014 20:54, Jassi Brar <jassisinghbrar@gmail.com> wrote:
> On Sat, Mar 29, 2014 at 3:38 AM, Markus Mayer <markus.mayer@linaro.org> wrote:
>
> .....
>
>>> +int mbox_send_message(struct mbox_chan *chan, void *mssg)
>>> +{
>>> +     int t;
>>> +
>>> +     if (!chan || !chan->cl)
>>> +             return -EINVAL;
>>> +
>>> +     t = _add_to_rbuf(chan, mssg);
>>> +     if (t < 0) {
>>> +             pr_err("Try increasing MBOX_TX_QUEUE_LEN\n");
>>> +             return t;
>>> +     }
>>> +
>>> +     _msg_submit(chan);
>>> +
>>> +     if (chan->txdone_method == TXDONE_BY_POLL)
>>> +             poll_txdone((unsigned long)chan->con);
>>
>> Wouldn't it be cleaner to use
>>                 poll_txdone((unsigned long)&chan->con);
>> ?
>>
> Here's how we use it ...
>
> static void poll_txdone(unsigned long data)
> {
>      struct mbox_con *con = (struct mbox_con *)data;
>      .....
> }
>
> To me, unnecessarily passing a pointer to a pointer seems unclean.

You are right. I didn't look closely enough.

Regards,
-Markus
