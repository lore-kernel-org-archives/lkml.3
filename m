Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933826Ab3DBWfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:35:37 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48712 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933511Ab3DBWfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:35:31 -0400
X-Sasl-enc: z9rfeb8dLdvZxryD2/fK/FV+Cb/H2tZPZcpww74HlcuP 1364942130
Message-ID: <515B5D34.4000407@signal11.us>
Date: Tue, 02 Apr 2013 18:35:32 -0400
From: Alan Ott <alan@signal11.us>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>
CC: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-zigbee-devel <linux-zigbee-devel@lists.sourceforge.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] mac802154: Immediately retry sending failed packets
References: <1364928481-1813-1-git-send-email-alan@signal11.us> <1364928481-1813-2-git-send-email-alan@signal11.us> <CAJmB2rCr5ds11+iN=W5GCKsUgdfb57uKg+mH4NY4CWw6EFCTbg@mail.gmail.com> <515B3F78.2020301@signal11.us> <515B4D79.40805@signal11.us>
In-Reply-To: <515B4D79.40805@signal11.us>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2013 05:28 PM, Alan Ott wrote:

> According to 7.5.6.5 of IEEE 802.15.4-2003, if the retransmission fails
> more than aMaxFrameRetries (3) times, it is assumed that it has failed.
> Since some transceivers (and I would assume most if not all) do this in
> hardware, it's now my opinion that we should _not_ try to retransmit at
> all in mac802154/tx.c.
> 
> For a driver for a device which _doesn't_ do retransmission in hardware,
> maybe it should be handled by that driver then.


It's worth noting that the mrf24j40, the at86rf230, and the cc2420
support retransmission in hardware (the first two are the only two in
mainline).

Alan.

