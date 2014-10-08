Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021AbaJHJeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 05:34:20 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35614 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754992AbaJHJeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 05:34:13 -0400
X-Sasl-enc: Q2mwVzAVDcn55nnUHa+x4ye5wOANGrgvXQ+H1sOMcYaj 1412760852
Message-ID: <1412760850.7228.5.camel@localhost>
Subject: Re: [PATCH 1/1 net-next] af_unix: remove NULL assignment on static
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: David Laight <David.Laight@ACULAB.COM>
Cc: Fabian Frederick <fabf@skynet.be>, Guenter Roeck <linux@roeck-us.net>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 08 Oct 2014 11:34:10 +0200
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D174C6CA5@AcuExch.aculab.com>
References: <1412712996-4672-1-git-send-email-fabf@skynet.be>
	 <20141007.161832.453892039501955243.davem@davemloft.net>
	 <20141007203344.GA4748@roeck-us.net>
	 <1559212122.19553.1412714971908.open-xchange@webmail.nmp.skynet.be>
	 <1412715283.11600.11.camel@localhost>
	 <063D6719AE5E284EB5DD2968C1650D6D174C6CA5@AcuExch.aculab.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mi, 2014-10-08 at 09:10 +0000, David Laight wrote:
> From: Hannes Frederic Sowa
> > I think David's concern was whether if 0 == false in all situations. It
> > is pretty clear that static memory is initialized to 0.
> 
> I'm not 100% sure about that.
> static pointers may be required to be initialised to NULL.

This isn't something the C standard specified but in case of Linux, I
think the ELF standard might be the right one to look at. Looking at the
kernel, I think this is an unwritten law. ;)

The standard allows NULL and static memory initialization to be
implementation defined, so NULL very well might not be 'all 0', that's
correct. Even static memory must only be initialized, when this happens
and how it is initialized is completely up to the implementation.

> If NULL isn't the 'all 0 bit pattern' then the memory would need
> to be initialised to a different pattern.

I haven't looked closely but I don't think that pointers need to be
initialized to NULL, but please don't quote me on this.

> Not that anyone is likely to implement such a system because far too
> much code will break.
> 
> The only system I knew where 'native' NULL pointers were 'all 1s'
> used 0 in its C compiler.

:)

Bye,
Hannes


