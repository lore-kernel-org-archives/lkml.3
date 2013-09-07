Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905Ab3IGTwW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 15:52:22 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:45751 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812Ab3IGTwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 15:52:21 -0400
Date: Sat, 7 Sep 2013 19:52:20 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Mayk Eskila <meskilla@outlook.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Problems with splice
Message-ID: <20130907195220.GB26022@dcvr.yhbt.net>
References: <BLU0-SMTP1270709DA425DAB477295E0C43D0@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BLU0-SMTP1270709DA425DAB477295E0C43D0@phx.gbl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mayk Eskila <meskilla@outlook.com> wrote:
> Hello list,
> 
> I intend to upgrade my own disc and partition cloning program by
> using splice. When running splice-cp.c from current git on my
> average dualcore hardware with kernel 3.10 I found that copying 1G
> files with splice is about twice as fast as using plain vanilla cp.
> 
> However I have encountered the following problems:
> 
> a) When trying to copy files with 2G size the program immediately
> terminates with the error "open input: Value too large for defined
> data type".
> 
> b) When trying to copy from a harddisc partition like /dev/sdb1 the
> program immediately terminates without any error and without
> copying.
> 
> c) When output is directed to /dev/null transfer speeds are extremely bad.
> 
> I guess that a+b might be due to size being larger than 32bit value.
> Is this a bug in the kernel or how can it be prevented from a user
> space program?

Probably just writing a loop and copying smaller values.  There's some
FSes/drivers which don't handle values approaching INT_MAX well.
INT_MAX/2 is probably a safe bet and still fast.

> c) I guess that the code run when outputting to /dev/null takes it's
> time, but I intend to use that possibility for benchmarking pure
> read throughputs. In the current program I detect that special case
> and do not open the output file and in the copying loop skip all
> writing code. How could this be done by using the splice
> family and thus avoid copying data to user space?

I don't know about /dev/null performance.  Maybe it's just not
optimized.  I sometimes splice small amounts to /dev/null myself for
error recovery, but I've never noticed it being slow.

> d) I also intend to use it for wiping discs and partitions. I know
> how to fill a buffer with zeros or pseudo random data, but how can I
> avoid repeatedly copying that data into kernel space?

using tee() instead of splice() should work
