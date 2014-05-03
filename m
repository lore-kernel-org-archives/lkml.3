Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286AbaECL3O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 07:29:14 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:59454 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751005AbaECL3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 07:29:12 -0400
Date: Sat, 3 May 2014 13:29:05 +0200
From: Florian Westphal <fw@strlen.de>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        =?utf-8?B?T25kxZllaiBCw61sa2E=?= <neleai@seznam.cz>,
        Caitlin Bestler <caitlin.bestler@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Elie De Brauwer <eliedebrauwer@gmail.com>,
        David Miller <davem@davemloft.net>,
        Steven Whitehouse <steve@chygwyn.com>,
        =?iso-8859-15?Q?R=E9mi?= Denis-Courmont 
	<remi.denis-courmont@nokia.com>,
        Paul Moore <paul@paul-moore.com>,
        Chris Friesen <chris.friesen@windriver.com>
Subject: Re: recvmmsg() timeout behavior strangeness [RESEND]
Message-ID: <20140503112905.GC3514@breakpoint.cc>
References: <536101C9.9090601@gmail.com>
 <CAKgNAkhaFoMMzo1JB7wfgZ2Qwkgjvf8Tp8c77ih99=1qcDoNKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgNAkhaFoMMzo1JB7wfgZ2Qwkgjvf8Tp8c77ih99=1qcDoNKg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Kerrisk (man-pages) <mtk.manpages@gmail.com> wrote:
> Reinvestigating the problem, I see that I got my description of the
> behavior slightly wrong, although the fundamental problem remains.
> Here's my improved formulation:
[..]

> Since the timeout is only checked after the arrival of each datagram,
> we can have scenarios like the following:
> 
> 0. Assume a timeout of 10 (T) seconds, that vlen is 5, and the call
>    is made at time X
> 
> 1. First datagram arrives at time X+2.
> 
> 2. Second datagram arrives at time X+4 secs
> 
> 3. Third datagram arrives at time X+6 secs
> 
> 4. No more datagrams arrive.
> 
> In this case, the call blocks forever. It hardly seems that this could
> be intended behavior. The problem, of course is that the timeout is
> checked only after receipt of a datagram.

Isn't that what MSG_WAITFORONE is supposed to solve?
