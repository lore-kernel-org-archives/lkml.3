Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291Ab3FFEfa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 00:35:30 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:41050 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab3FFEf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 00:35:28 -0400
Message-ID: <1370493325.24311.332.camel@edumazet-glaptop>
Subject: Re: [PATCH 5/5] net: Block MSG_CMSG_COMPAT in send(m)msg and
 recv(m)msg
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Michael Neuling <mikey@neuling.org>
Cc: Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        x86@kernel.org, trinity@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>, torvalds@linux-foundation.org
Date: Wed, 05 Jun 2013 21:35:25 -0700
In-Reply-To: <CAEjGV6xcF776C6N6VxeMY0Vyk+X51oNixdbN42-xkWjQOaMEQA@mail.gmail.com>
References: <cover.1369177867.git.luto@amacapital.net>
	 <aa015609319786835bcab445d507faa75c11f111.1369177867.git.luto@amacapital.net>
	 <CAEjGV6xcF776C6N6VxeMY0Vyk+X51oNixdbN42-xkWjQOaMEQA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-06 at 12:56 +1000, Michael Neuling wrote:
> On Thu, May 23, 2013 at 7:07 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> > MSG_CMSG_COMPAT is (AFAIK) not intended to be part of the API --
> > it's a hack that steals a bit to indicate to other networking code
> > that a compat entry was used.  So don't allow it from a non-compat
> > syscall.
> 
> Dave & Linus
> 
> This is causing a regression on 64bit powerpc with 32bit usermode.
> When I hit userspace, udev is broken and I suspect all networking is
> broken as well.
> 
> Can we please revert 1be374a0518a288147c6a7398792583200a67261 upstream?
> 

It seems to also break x86_64, if using 32bit usermode.



