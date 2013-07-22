Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932848Ab3GVS3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 14:29:20 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:33410 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932502Ab3GVS3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 14:29:17 -0400
MIME-Version: 1.0
In-Reply-To: <1374512879.4990.19.camel@edumazet-glaptop>
References: <1374311809-4155-1-git-send-email-freddy@asix.com.tw>
	<1374512879.4990.19.camel@edumazet-glaptop>
Date: Mon, 22 Jul 2013 11:29:16 -0700
Message-ID: <CANEJEGvPc56ePP=_bxfA4PZfsM3vw=MsRjbWwrFBC3eP-GtzZg@mail.gmail.com>
Subject: Re: [PATCH 1/1] TX throttling bug-fixing patch of AX88179_178A
From: Grant Grundler <grundler@google.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Freddy Xin <freddy@asix.com.tw>, David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, linux-usb@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?QVNJWCBMb3VpcyBb6JiH5aiB6Zm4XQ==?= <louis@asix.com.tw>,
        Allan Chou <allan@asix.com.tw>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 10:07 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
...
> I guess that if a driver does not advertise NETIF_F_SG, this
> skb_linearize() call is not needed : All frames reaching your xmit
> function should already be linear

As Ben Hutchings pointed out, hw_features is still setting this...but
I'm not sure how that matters.

ax88179_set_features() doesn't allow setting SG or TSO features.  But
I expect it would be "not too difficult" to add such that ethtool
could set those features after boot.  Or perhaps add a driver module
parameter to set these features.  I just guessing the skb_linearize()
could be removed until set_features support for SG and/or TSO is
added. Is that correct?

thanks,
grant
