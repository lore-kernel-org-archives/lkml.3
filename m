Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093AbaGHHty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 03:49:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:53376 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbaGHHtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 03:49:53 -0400
Date: Tue, 8 Jul 2014 09:49:43 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "xiaofeng.yan" <xiaofeng.yan@huawei.com>
Cc: Li Zefan <lizefan@huawei.com>, mingo@redhat.com,
        linux-kernel@vger.kernel.org, xiaofeng.yan2012@gmail.com,
        Juri Lelli <juri.lelli@gmail.com>
Subject: Re: [PATCH] sched/rt: overrun could happen in start_hrtick_dl
Message-ID: <20140708074943.GK19379@twins.programming.kicks-ass.net>
References: <1404475341-22536-1-git-send-email-xiaofeng.yan@huawei.com>
 <20140707084150.GC19379@twins.programming.kicks-ass.net>
 <53BB4510.5090704@huawei.com>
 <53BB5A13.1070305@huawei.com>
 <53BB5C96.2040203@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R9gO+D7ggLXSSo9w"
Content-Disposition: inline
In-Reply-To: <53BB5C96.2040203@huawei.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--R9gO+D7ggLXSSo9w
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 08, 2014 at 10:51:02AM +0800, xiaofeng.yan wrote:
> On 2014/7/8 10:40, Li Zefan wrote:
> >On 2014/7/8 9:10, xiaofeng.yan wrote:
> >>On 2014/7/7 16:41, Peter Zijlstra wrote:
> >>>On Fri, Jul 04, 2014 at 12:02:21PM +0000, xiaofeng.yan wrote:
> >>>>It could be wrong for the precision of runtime and deadline
> >>>>when the precision is within microsecond level. For example:
> >>>>Task runtime deadline period
> >>>>   P1   200us   500us   500us
> >>>>
> >>>>This case need enbale HRTICK feature by the next command
> >>>>PC#echo "HRTICK" > /sys/kernel/debug/sched_features
> >>>>PC#./schedtool -E -t 200000:500000 -e ./test&
> >>>>PC#trace-cmd record -e sched_switch
> >>>Are you actually using HRTICK ?
> >>yes, If HRTICK is close , then all of runtime and deadline will be wrong.
> >I think what peter meant is, do you use HRTICK in products or
> >just use it for testing/experiment?
> >
> Thanks for your timely comments. In fact, We use HRTICK feature in product.
> We need microsecond level
> precision.

Ah, thanks. Be advised that currently HRTICK is rather expensive. The
cost is twofold: 1) doing all the kernel side hrtimer things and 2)
programming clock hardware.

Of course, if that's what you need, you're willing to pay the price.

I'll see if I can put making it less expensive slightly higher on the
(endless) todo list.

--R9gO+D7ggLXSSo9w
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTu6KXAAoJEHZH4aRLwOS6GsIP/2nXCruY1lJ+eeSiUGz+otlQ
QJ7BbwAuLCufX4hOsUONjd01KrU7PpQRQHQQ3ECBrTwgnEqle/Pws96y+tvppnFw
bYRPipMM8bKUKRGEBiVgSpnyCx7++IlXuulcjqnGqEJAHVTHreEJKPFhFr+wSmkr
SpGCg29s1ih4At+Qlks7bc79dvd6fZiFCpqgaMvtJG8u85EnT3rF0pgOYPS0JZDT
OBTL7I4DffKjFK1z1Z6b9v7bNy6boUsYvn7LqwF4Lyo/EnrFsBDrqK1kmlmuV+i/
COhlR0RI68VfXZVNQ1gqtHGV/lHOPFOLk2UnWHtVTXWyfdsUmGDiRK4vOCK+LNYV
jBuF9rZmu1jmoGZ8Xi45tSdXeJOGIIOjJrQ3kEa+EpjjJFur8nrXJglYFFJWSdxN
A8+qwiuii/RBXHwWr/oOUbUYBMwGDlwWaezvGoQMGeRuHj3LbcTUKI1xeXG0PLjX
4upzdTHz1YX6iT0Tbm2k+W4HWuM6hr8CmIoQhp+wfefvsnQQGk6qB7CwOkM/FrmL
kO3dwzr6q0R7kI4XFKUYnMvRn816gvIn3faqdYwVtQ6WazcKqCKAh2w5Nr8tG4PD
28sJtFOXSU8pU6LhOjahGQ4xMgGqvBlWEUuIUAYKjcFAO+xHK3fEbhTMuEjMydlh
GcAs/pU2X+TfBJaLq4BC
=M7eg
-----END PGP SIGNATURE-----

--R9gO+D7ggLXSSo9w--
