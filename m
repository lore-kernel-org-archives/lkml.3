Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760423Ab3DCBY6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 21:24:58 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54531 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760358Ab3DCBY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 21:24:57 -0400
X-Sasl-enc: cpJQuO/5uqSycX0UNz+UcVCBLuNeRnnoOefIn3x9bfsd 1364952296
Message-ID: <515B84EB.8020006@signal11.us>
Date: Tue, 02 Apr 2013 21:24:59 -0400
From: Alan Ott <alan@signal11.us>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Werner Almesberger <werner@almesberger.net>
CC: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-zigbee-devel <linux-zigbee-devel@lists.sourceforge.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [Linux-zigbee-devel] [PATCH 1/6] mac802154: Immediately retry
 sending failed packets
References: <1364928481-1813-1-git-send-email-alan@signal11.us> <1364928481-1813-2-git-send-email-alan@signal11.us> <CAJmB2rCr5ds11+iN=W5GCKsUgdfb57uKg+mH4NY4CWw6EFCTbg@mail.gmail.com> <515B3F78.2020301@signal11.us> <515B4D79.40805@signal11.us> <20130402231319.GD28141@ws>
In-Reply-To: <20130402231319.GD28141@ws>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2013 07:13 PM, Werner Almesberger wrote:
> Alan Ott wrote:
>> it's now my opinion that we should _not_ try to retransmit at
>> all in mac802154/tx.c.
> I think the currently blocking workqueue design is ugly and
> quite contrary to how most the rest of the stack works. So
> anything that kills it has my blessing :-)

I like it for a couple of reasons.
1. Most supported devices have only single packet output buffer, so
blocking in the driver is the most straight-forward way to handle it.
The alternative is to make each driver have a workqueue for xmit() (to
lift the blocking out from atomic context). This makes each driver simpler.

2. All of the flow control can be handled one time in the mac802154 layer.

> I do wonder though why it was done like this in the first place.
> Just for convenience ?
>
> If we want to move towards an asynchronous interface, it could
> exist in parallel with the current one. That way, drivers could
> be migrated one by one.

Maybe at some point this will be done. Right now we have a ton of
pressing issues (in my opinion).

> Having said that, the errors you get there may not be failed
> single transmissions on the air but some form of congestion in
> the driver or a problem with the device. But I don't think
> that's a valid reason for retrying the transmission at that
> level.

Agreed. Like I said, I'm now of the opinion that the mac802154 layer
should _not_ retry at all.

Alan.

