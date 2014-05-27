Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbaE0IMz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 04:12:55 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:50594 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbaE0IMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 04:12:43 -0400
Message-ID: <1401178359.5134.95.camel@marge.simpson.net>
Subject: Re: balance storm
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Libo Chen <libo.chen@huawei.com>
Cc: tglx@linutronix.de, mingo@elte.hu, LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, Li Zefan <lizefan@huawei.com>,
        peterz@infradead.org
Date: Tue, 27 May 2014 10:12:39 +0200
In-Reply-To: <53844277.3050204@huawei.com>
References: <5382AF2E.1040407@huawei.com>
	 <1401090987.5339.79.camel@marge.simpson.net> <53832A36.5020205@huawei.com>
	 <1401112989.23186.28.camel@marge.simpson.net> <53844277.3050204@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-05-27 at 15:44 +0800, Libo Chen wrote: 
> On 2014/5/26 22:03, Mike Galbraith wrote:
> > On Mon, 2014-05-26 at 19:49 +0800, Libo Chen wrote:
> > 
> >> how to turn off SD_SHARE_PKG_RESOURCES in userspace ?
> > 
> > I use a script Ingo gave me years and years ago to
> > twiddle /proc/sys/kernel/sched_domain/cpuN/domainN/flags domain wise.
> > Doing that won't do you any good without a handler to build/tear down
> > sd_llc when you poke at flags though.  You can easily add a sched
> > feature to play with it.
> 
> 
> I make a simple script：
> 
>    for ((i=0;i<=15;i++))
>    do
>            echo 4143 > /proc/sys/kernel/sched_domain/cpu$i/domain1/flags
>    done
> 
> In our kernel  SD_SHARE_PKG_RESOURCE is 0x0200, the original flag value is 4655,
> domain1's name is MC.
> 
> but migrations event doesn't reduce like yours, what problem?  I wouldn't like
> recompile kernel :(

Hm, I thought you were a kernel hacker, but guess not since that would
be a really weird thing for a kernel hacker to say :)  Problem is that
there's no handler in your kernel to convert your flag poking to sd_llc
poking.

I could send you a patchlet, but that ain't gonna work, neither that nor
the commit I pointed out will seep into the kernel via osmosis.  There
should be a kernel hacker somewhere near you, look down the hall by the
water cooler, when you find one, he/she should be able to help.

-Mike

