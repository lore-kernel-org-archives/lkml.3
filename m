Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbaLGO60 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 09:58:26 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:26169 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbaLGO6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 09:58:25 -0500
Message-ID: <54846B06.8050906@oracle.com>
Date: Sun, 07 Dec 2014 09:58:14 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        =?UTF-8?B?RMOibmllbCBGcmFnYQ==?= <fragabr@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
References: <20141127225637.GA24019@redhat.com>	<m5dart$co$1@ger.gmane.org>	<CA+55aFwm4hpyDjJ=GzrahOe2QtuO7im71sPky7U6Rh+18A0X0w@mail.gmail.com>	<547b8a45.6e608c0a.20f9.1002@mx.google.com>	<CA+55aFzQ0QZxL-PRnv4Db=wo1pDmBR45P-vpGxyeJnt1DFnSfA@mail.gmail.com>	<547bbe36.48548c0a.105c.779c@mx.google.com>	<20141201191431.GA17385@linux.vnet.ibm.com>	<547ccf74.a5198c0a.25de.26d9@mx.google.com>	<CA+55aFx0K=T8yvfRCYeaJG_5YO+Qm8EEQfA9Xp59xedbzj=f2A@mail.gmail.com>	<20141201230339.GA20487@ret.masoncoding.com>	<20141202193252.GB17595@redhat.com>	<547E4C14.6040509@oracle.com>	<54813C03.8040009@oracle.com>	<CA+55aFyZOo=HzB_n3gLqswFsN1FcMdumaKLBk+fbhDD3wrvXnA@mail.gmail.com>	<5481C92E.6020805@oracle.com> <CA+55aFxnCxJcg7NgNeqn_P_TugpcHTUk+v21Td25Aw6+2Z8=YA@mail.gmail.com>
In-Reply-To: <CA+55aFxnCxJcg7NgNeqn_P_TugpcHTUk+v21Td25Aw6+2Z8=YA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2014 01:15 PM, Linus Torvalds wrote:
> On Fri, Dec 5, 2014 at 7:03 AM, Sasha Levin <sasha.levin@oracle.com> wrote:
>>
>> Yes, it's going to a serial line, but it's only about 100 lines/second on
>> average. I wouldn't expect it to cause anything to hang!
> 
> A regular 16650 serial chip? Running at 115kbps, I assume? So that's
> about 11kB/s.
> 
> And the serial console is polling, since it can't sleep or depend on interrupts.
> 
> At a average line length of what, 40 characters? At less than 300
> lines/s, you'd be using up 100% of one CPU. And since the printouts
> are serialized, that would be all other CPU's too..
> 
> 100 lines/s _average_ means that I can easily see it be 300lines/s for a while.
> 
> So yeah. The serial console is simply not designed to handle
> continuous output. It's for the "occasional" stuff.
> 
> The fact that your rcu lockups go away when you make the fault
> injection be quiet makes me really suspect this is related.

The lockups themselves "go away", but looking closer at the log
without those extra prints, I'm seeing:

[ 1458.700070] INFO: rcu_preempt detected stalls on CPUs/tasks:
[ 1458.700133]  (detected by 19, t=30502 jiffies, g=12293, c=12292, q=0)
[ 1458.702764] INFO: Stall ended before state dump start

Quite often.

Maybe the extra prints were just a catalyst?


Thanks,
Sasha
