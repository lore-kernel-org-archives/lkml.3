Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884Ab3FNVGN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 17:06:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22187 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab3FNVGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 17:06:11 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=w1cNLofYa50A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=yqaEuN8awxIA:10 a=V_Nx1pHck5XVaBwX5WwA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1371243967.9844.338.camel@gandalf.local.home>
Subject: Re: Regression in RCU subsystem in latest mainline kernel
From: Steven Rostedt <rostedt@goodmis.org>
To: Rojhalat Ibrahim <imr@rtschenk.de>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Date: Fri, 14 Jun 2013 17:06:07 -0400
In-Reply-To: <1645938.As0LR1yeVd@pcimr>
References: <1626500.7WAVXjfS9F@pcimr>
	 <20130614122800.GL5146@linux.vnet.ibm.com> <1645938.As0LR1yeVd@pcimr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-14 at 14:46 +0200, Rojhalat Ibrahim wrote:
> On Friday 14 June 2013 05:28:00 Paul E. McKenney wrote:
> > On Fri, Jun 14, 2013 at 01:47:00PM +0200, Rojhalat Ibrahim wrote:
> > > Hi,
> > > 
> > > the current mainline kernel from git reproducibly hangs on my Freescale
> > > PowerPC P5020DS development system. Most of the time the hang occurs
> > > during
> > > boot (kernel just stops booting, system hangs), sometimes shortly after
> > > booting (system hangs, no message). Very often booting stops at the
> > > initialization of the Intel PRO 1000 PCIe network device (e1000e).

I was pretty much able to reproduce this on my PA Semi PPC box. Funny
thing is, when I type on the console, it makes progress. Anyway, it
seems that powerpc has an issue with irq_work(). I'll try to get some
time either tonight or next week to figure it out.

Thanks!

-- Steve

> > > 
> > > I used git bisect and arrived at this commit:
> > > 
> > > 016a8d5be6ddcc72ef0432d82d9f6fa34f61b907
> > > rcu: Don't call wakeup() with rcu_node structure ->lock held
> > > 
> > > With versions before that commit the system runs normally.
> > 
> > Odd, given that this fix was intended to prevent hangs.  Could you
> > please send your .config?
> > 
> > 							Thanx, Paul


