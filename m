Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567Ab3KYOn6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:43:58 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755029Ab3KYOn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 09:43:56 -0500
From: Richard Weinberger <richard@nod.at>
To: Boaz Harrosh <bharrosh@panasas.com>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: LKP <fnstml-lkp@cn.fujitsu.com>, Fengguang Wu <fengguang.wu@intel.com>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: CPU: 0 PID: 1 at init/main.c:711 do_one_initcall()
Date: Mon, 25 Nov 2013 15:43:47 +0100
Message-ID: <2845101.Wgsx5afvdX@sandpuppy>
User-Agent: KMail/4.11.2 (Linux/3.12.0-34.ge8fa6b4-desktop; KDE/4.11.2; x86_64; ; )
In-Reply-To: <52935F73.4090209@panasas.com>
References: <20131122060223.GP9991@yliu-dev.sh.intel.com> <CAFLxGvynVV=aY755xTPTa7-57O25Dwzc+cbWELj+4xxFKznKMg@mail.gmail.com> <52935F73.4090209@panasas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 25. November 2013, 16:32:19 schrieb Boaz Harrosh:
> On 11/25/2013 04:15 PM, Richard Weinberger wrote:
> > On Fri, Nov 22, 2013 at 7:02 AM, Yuanhan Liu
> > 
> > <yuanhan.liu@linux.intel.com> wrote:
> >> Greetings,
> >> 
> >> I got the below dmesg and the first bad commit is
> >> 
> >> commit 20545536cd8ea949c61527b6395ec8c0d2c237b1
> >> Author: Boaz Harrosh <bharrosh@panasas.com>
> >> Date:   Thu Jul 19 15:22:37 2012 +0300
> >> 
> >>     RFC: do_xor_speed Broken on UML do to jiffies
> >>     
> >>     Remember that hang I reported a while back on UML. Well
> >>     I'm at it again, and it still hangs and I found why.
> >>     
> >>     I have dprinted jiffies and it never advances during the
> >>     loop at do_xor_speed. There for it is stuck in an endless
> >>     loop. I have also dprinted current_kernel_time() and it
> >>     returns the same constant value as well.
> >>     
> >>     Note that it does usually work on UML, only during
> >>     the modprobe of xor.ko while that test is running. It looks
> >>     like some lucking is preventing the clock from ticking.
> >>     
> >>     However ktime_get_ts does work for me so I changed the code
> >>     as below, so I can work. See how I put several safety
> >>     guards, to never get hangs again.
> >>     And I think my time based approach is more accurate then
> >>     previous system.
> >>     
> >>     UML guys please investigate the jiffies issue? what is
> >>     xor.ko not doing right?
> > 
> > This patch never hit my mailbox...
> > 
> >>     Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> 
> Sir Richard
> 
> I never followed on this patch. Sorry. I do think it is in
> the right direction, but it has a dev-by-zero problem and
> a 32 bitness problem. (So I never sent it, beyond the initial
> query)
> 
> [It stopped to be very important for me since I stopped using
>  UM very much. Ever since FC17 I'm unable to produce a running
>  image. It just will not boot, an image that a kvm would. So
>  very sad me, but no UML for me anymore.]

Sad to hear.
Did you try one from http://fs.devloop.org.uk/?
Just booted a FC18 on UML. Works fine.

In the past we've had some issues with systemd-enabled distros.
systemd uncovered problem in the UML tty driver.

> If you want to investigate. try doing a modprobe xor.ko on
> a uml and see. since xor.ko is only built on demand for example
> enabling exofs or object-layout-driver will select it. ,or MD-raid5.

Ok.

Thanks,
//richard
