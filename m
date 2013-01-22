Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab3AVSm6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 13:42:58 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:57706 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528Ab3AVSm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 13:42:56 -0500
Date: Tue, 22 Jan 2013 19:42:45 +0100
From: Leandro Lucarella <leandro.lucarella@sociomantic.com>
To: Rick Jones <rick.jones2@hp.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Doubts about listen backlog and tcp_max_syn_backlog
Message-ID: <20130122184245.GJ4608@sociomantic.com>
References: <20130122161038.GG4608@sociomantic.com>
 <1358873142.3464.3964.camel@edumazet-glaptop>
 <20130122165929.GH4608@sociomantic.com>
 <1358874800.3464.4002.camel@edumazet-glaptop>
 <50FED7CE.1030008@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50FED7CE.1030008@hp.com>
X-Paranoid: Just because you're paranoid, don't mean they're not after you.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:s+Lsm4otiRxPFkhEkJO21Fzzg4pp61f0kJs1rKTpx/Z
 0qDIccfSbokGu/QPN+ydpB/TG91h5f2N1myiXw+6tPiXUS0XI/
 e5uB3ABeYQ4FejmKg3zlMpi/qtFlFFJmSSSXGBn6Jw1AhLXPIf
 fu9veSMHQ1mCZf/457Ijpt4ufl7SKLg+CNkeLpPPJlXngzHN0B
 lOCBUep5g/pS7xSv6L5MkRJ9oIwOQWC8+VJZqpdI2QNy3l2Tdt
 mZG72vvKBn9SxLuGG36qUp50OLiKqN/mqdv5dbr8YdzboTR5e6
 HYqBONdvXjXfdQE6SdzLNkQjbEpj3s7KE9mgP+tegmXVbCcLMw
 X/Bbg0DXjOTktvwwLnng9NX8JWP1MG2PLWRyUYnVT41IQ3+iwi
 sLHj9JuhD+lhg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 10:17:50AM -0800, Rick Jones wrote:
> >What is important is the backlog, and I guess you didn't increase it
> >properly. The somaxconn default is quite low (128)
> 
> Leandro -
> 
> If that is being overflowed, I believe you should be seeing something like:
> 
>     14 SYNs to LISTEN sockets dropped
> 
> in the output of netstat -s on the system on which the server
> application is running.

What is that value reporting exactly? Because we are using syncookies,
and AFAIK with that enabled, all SYNs are being replied, and what the
listen backlog is really limitting is the "completely  established
sockets waiting to be accepted", according to listen(2). What I don't
really know to be honest, is what a "completely established socket" is,
does it mean that the SYN,ACK was sent, or the ACK was received back?

Also, from the client side, when is the connect(2) call done? When the
SYN,ACK is received?

Thanks!

-- 
Leandro Lucarella
sociomantic labs GmbH
http://www.sociomantic.com
