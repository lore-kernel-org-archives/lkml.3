Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928AbaLCOI6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 09:08:58 -0500
Received: from h1.radempa.de ([176.9.142.194]:38576 "EHLO mail.cosmopool.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856AbaLCOI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 09:08:56 -0500
From: Harald Geyer <harald@ccbib.org>
To: Richard Weinberger <richard@nod.at>
cc: jic23@kernel.org, knaack.h@gmx.de, lars@metafoo.de, pmeerw@pmeerw.net,
        sanjeev_sharma@mentor.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: iio: dht11 Updates
In-reply-to: <547F0CFE.4010107@nod.at>
References: <1417563176-31972-1-git-send-email-richard@nod.at> <E1Xw8sp-0001B6-Ul@stardust.g4.wien.funkfeuer.at> <547F0CFE.4010107@nod.at>
Comments: In-reply-to Richard Weinberger <richard@nod.at>
   message dated "Wed, 03 Dec 2014 14:15:42 +0100."
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4951.1417615711.1@stardust.g4.wien.funkfeuer.at>
Date: Wed, 03 Dec 2014 15:08:31 +0100
Message-Id: <E1XwAbX-0001Ht-Jg@stardust.g4.wien.funkfeuer.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger writes:
> Harald,
> 
> Am 03.12.2014 um 13:18 schrieb Harald Geyer:
> > Hi Richard,
> > 
> > thanks for all the work you put into this!
> > 
> > Richard Weinberger writes:
> >> I have also a question on your driver. Why you increment
> >> DHT11_DATA_BIT_LOW/timeres by one in the ambiguity check?
> >>
> >>         threshold = DHT11_DATA_BIT_HIGH / timeres;
> >>         if (DHT11_DATA_BIT_LOW/timeres + 1 >= threshold)
> >>                 pr_err("dht11: WARNING: decoding ambiguous\n");
> > 
> > This is to take ambiguity of when the bit started relativ to the
> > clock ticks into account. For example with common 32kHz clocks:
> > DHT11_DATA_BIT_LOW / timeres = 0
> > DHT11_DATA_BIT_HIGH / timeres = 2
> > but since the bit might not start at a clock tick the actual t of
> > a low bit can be either 0 or 1 while the actual t of a high bit
> > can be either 2 or 3.
> > 
> > This case is fine.
> > 
> > But if we had a 38kHz clock:
> > DHT11_DATA_BIT_LOW / timeres = 1    t can be 1 or 2
> > DHT11_DATA_BIT_HIGH / timeres = 2   t can be 2 or 3
> > so we have an ambiguity. The ambiguity could be removed by a smarter
> > decoder, that looks at the t of other bits, but I'm not going to do
> > that unless somebody is promising to test it on affected hardware.
> > 
> > Feel free to add some comment about this to the code.
> 
> Will do, thanks a lot for the explanation.
> 
> I was asking because I see the "dht11: WARNING: decoding ambiguous"
> very often. (with and without my patches)

Yes, your patches shouldn't have any effect on this.
"very often" in the sense of "not always"? This would be very surprising,
because this would involve variable length clock ticks, i think.

I guess we should include timeres into the warning message.

Also I guess now is the time to think about a smarter decoder.

Thanks a lot for your effort.
Harald
