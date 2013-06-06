Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751254Ab3FFEIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 00:08:17 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:49811 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab3FFEIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 00:08:14 -0400
Message-ID: <1370491691.24311.326.camel@edumazet-glaptop>
Subject: Re: stop_machine lockup issue in 3.9.y.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Joe Lawrence <joe.lawrence@stratus.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
        Jouni Malinen <jouni@qca.qualcomm.com>,
        Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
        Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Date: Wed, 05 Jun 2013 21:08:11 -0700
In-Reply-To: <51B00719.20406@candelatech.com>
References: <51AE27D5.7050202@candelatech.com>
	   <87sj0xry1k.fsf@rustcorp.com.au> <20130605071539.GA3429@mtj.dyndns.org>
	   <51AF6E54.3050108@candelatech.com>
	 <20130605184807.GD10693@mtj.dyndns.org>
	   <51AF8D4B.4090407@candelatech.com> <51AF91F5.6090801@candelatech.com>
	   <51AFA677.9010605@candelatech.com>
	 <20130605211157.GK10693@mtj.dyndns.org>
	   <1370482492.24311.308.camel@edumazet-glaptop>
	   <20130606031444.GA12335@mtj.dyndns.org>
	  <1370489181.24311.318.camel@edumazet-glaptop>
	  <51B004CD.6080007@candelatech.com>
	 <1370490403.24311.322.camel@edumazet-glaptop>
	 <51B00719.20406@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-05 at 20:50 -0700, Ben Greear wrote:
> On 06/05/2013 08:46 PM, Eric Dumazet wrote:
> >
> > We use in Google a patch triggering warning is a thread holds the cpu
> > without taking care to need_resched() for more than xx ms
> 
> Well, I'm sure that patch works nicely until the clock stops moving
> forward :)
> 

This is not using jiffies, but the clock used in kernel/sched/core.c,
with ns resolution ;)

> I'll post a patch with limit of 10 shortly.

ok


