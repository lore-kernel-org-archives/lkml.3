Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751171Ab3KJKsM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 05:48:12 -0500
Received: from mail-ve0-f180.google.com ([209.85.128.180]:33449 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014Ab3KJKsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 05:48:08 -0500
MIME-Version: 1.0
In-Reply-To: <CAApbN=Jm=zuDaVYALmGg5z_QfJJ3q13e9tshb7OpAtPQ8Ema1w@mail.gmail.com>
References: <CAApbN=Jm=zuDaVYALmGg5z_QfJJ3q13e9tshb7OpAtPQ8Ema1w@mail.gmail.com>
Date: Sun, 10 Nov 2013 11:48:07 +0100
Message-ID: <CAFLxGvxAcud=-1vfnancvhrMf-ECpjGkuJ4ymPCrR=cvhimb2g@mail.gmail.com>
Subject: Re: Cross thread shutdown of connected UDP socket, unexpected
 recvfrom behavior
From: Richard Weinberger <richard.weinberger@gmail.com>
To: mpb <mpb.mail@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 10, 2013 at 2:32 AM, mpb <mpb.mail@gmail.com> wrote:
> Hi LKML,
>
> I have a C/pthreads program with two threads ("main" and "thread").
> "thread" calls recvfrom on a connected UDP socket and blocks, waiting
> for input.  "main" then calls shutdown SHUT_RD on the socket.  In
> "thread", recvfrom returns, apparently successfully, returning a zero
> length string, and setting src_addr to a bogus(?) address family,
> port, and source address.
>
> Is the above the correct behavior for recvfrom?

A return value of 0 means that the socket was shutdown.

> Here is output from my program.  "main" sends "hello\0", then "" (the
> empty string), then calls shutdown.  "thread" receives "hello\0", "",
> and then finally receives an empty string that was never sent!
>
> thread  recvfrom: Success
>   rv 6  addrlen 16  fam 2  port 8000  addr 100007f
>
> thread  recvfrom: Success
>   rv 0  addrlen 16  fam 2  port 8000  addr 100007f
>
> main    shutdown: Success
>   rv 0
>
> thread  recvfrom: Success
>   rv 0  addrlen 16  fam 59060  port 44237  addr deaadef0
>
> The source code (2k) for the porgram is attached.  I'm running Ubuntu
> 13.04, kernel 3.8.0-19-generic #30-Ubuntu, on 32-bit i686.
>
> For reference, this June 2000 LKML thread discusses calling close in a
> similar situation.
> http://www.gossamer-threads.com/lists/linux/kernel/144379
>
> Please CC me if you have questions, otherwise I'll try to watch for
> answers in the list archives.
>
> Thanks!
>
> -mpb



-- 
Thanks,
//richard
