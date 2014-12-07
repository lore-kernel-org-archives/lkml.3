Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbaLGScD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 13:32:03 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:56895 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbaLGSb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 13:31:59 -0500
Date: Sun, 7 Dec 2014 10:24:20 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141207182420.GG25340@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <547ccf74.a5198c0a.25de.26d9@mx.google.com>
 <CA+55aFx0K=T8yvfRCYeaJG_5YO+Qm8EEQfA9Xp59xedbzj=f2A@mail.gmail.com>
 <20141201230339.GA20487@ret.masoncoding.com>
 <20141202193252.GB17595@redhat.com>
 <547E4C14.6040509@oracle.com>
 <54813C03.8040009@oracle.com>
 <CA+55aFyZOo=HzB_n3gLqswFsN1FcMdumaKLBk+fbhDD3wrvXnA@mail.gmail.com>
 <5481C92E.6020805@oracle.com>
 <CA+55aFxnCxJcg7NgNeqn_P_TugpcHTUk+v21Td25Aw6+2Z8=YA@mail.gmail.com>
 <54846B06.8050906@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54846B06.8050906@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120718-0017-0000-0000-000006E6AD2D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 07, 2014 at 09:58:14AM -0500, Sasha Levin wrote:
> On 12/05/2014 01:15 PM, Linus Torvalds wrote:
> > On Fri, Dec 5, 2014 at 7:03 AM, Sasha Levin <sasha.levin@oracle.com> wrote:
> >>
> >> Yes, it's going to a serial line, but it's only about 100 lines/second on
> >> average. I wouldn't expect it to cause anything to hang!
> > 
> > A regular 16650 serial chip? Running at 115kbps, I assume? So that's
> > about 11kB/s.
> > 
> > And the serial console is polling, since it can't sleep or depend on interrupts.
> > 
> > At a average line length of what, 40 characters? At less than 300
> > lines/s, you'd be using up 100% of one CPU. And since the printouts
> > are serialized, that would be all other CPU's too..
> > 
> > 100 lines/s _average_ means that I can easily see it be 300lines/s for a while.
> > 
> > So yeah. The serial console is simply not designed to handle
> > continuous output. It's for the "occasional" stuff.
> > 
> > The fact that your rcu lockups go away when you make the fault
> > injection be quiet makes me really suspect this is related.
> 
> The lockups themselves "go away", but looking closer at the log
> without those extra prints, I'm seeing:
> 
> [ 1458.700070] INFO: rcu_preempt detected stalls on CPUs/tasks:
> [ 1458.700133]  (detected by 19, t=30502 jiffies, g=12293, c=12292, q=0)
> [ 1458.702764] INFO: Stall ended before state dump start
> 
> Quite often.
> 
> Maybe the extra prints were just a catalyst?

Is anything else being printed about the time that these message show
up?  Or is this the only output for the 40,000 jiffies preceding this
message?

							Thanx, Paul

