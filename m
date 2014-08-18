Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850AbaHRJQp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:16:45 -0400
Received: from mail.aswsp.com ([193.34.35.150]:24457 "EHLO mail.aswsp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906AbaHRJQn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:16:43 -0400
Date: Mon, 18 Aug 2014 11:16:56 +0200
From: Matthieu CASTET <matthieu.castet@parrot.com>
To: David Ahern <dsahern@gmail.com>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: perf on biarch
Message-ID: <20140818111656.40ff6ae7@parrot.com>
In-Reply-To: <53E52A1C.8010504@gmail.com>
References: <20140808184049.65e7d32b@parrot.com>
	<53E52A1C.8010504@gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [46.218.109.88]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Fri, 8 Aug 2014 13:50:52 -0600,
David Ahern <dsahern@gmail.com> a écrit :

> On 8/8/14, 10:40 AM, Matthieu CASTET wrote:
> > Hi,
> >
> > I have a 64 bits kernel running with 32 bits binaries.
> > If I run 32 bits perf on this 64 bits kernel 3.14, I got weird result :
> >
> > - perf trace doesn't work [1]
> 
> I have patches that fix that:
>      git clone https://github.com/dsahern/linux.git
>      git checkout perf-full-monty
> 
> And if autodetection fails you can manually force it with -M x86.
> 
Thanks david. 
It is better, but it seems there are problem with argument parsing.

For example for 
"mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0xf77e2000"
I got :
- 2.847 ( 0.004 ms): mmap2(arg0: 0, arg1: 0, arg2: 4096, arg3: 0, arg4:
3, arg5: 0         ) = -143273984


Note the 4096 position. Running perf trace on a 32 bits kernel give
4096 at arg1.


Matthieu
