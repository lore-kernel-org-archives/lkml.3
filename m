Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933828Ab3D3Vin (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 17:38:43 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:52461 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933706Ab3D3Vii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 17:38:38 -0400
Date: Tue, 30 Apr 2013 23:38:31 +0200
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        paul.mckenney@linaro.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org
Subject: Re: rcu: Provide compile-time control for no-CBs CPUs
Message-ID: <20130430213831.GA3232@free.fr>
References: <20130430152126.0C564660906@gitolite.kernel.org>
 <20130430184612.GA14568@redhat.com>
 <20130430192541.GE3780@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130430192541.GE3780@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul, Dave, All,

On Tue, Apr 30, 2013 at 12:25:41PM -0700, Paul E. McKenney wrote:
> On Tue, Apr 30, 2013 at 02:46:12PM -0400, Dave Jones wrote:
> > On Tue, Apr 30, 2013 at 03:21:26PM +0000, Linux Kernel wrote:
> > 
> >  > +choice
> >  > +	prompt "Build-forced no-CBs CPUs"
> >  > +	default RCU_NOCB_CPU_NONE
> >  > +	help
> >  > +	  This option allows no-CBs CPUs to be specified at build time.
> >  > +	  Additional no-CBs CPUs may be specified by the rcu_nocbs=
> >  > +	  boot parameter.
> >  > +
> >  > +config RCU_NOCB_CPU_NONE
> >  > +	bool "No build_forced no-CBs CPUs"
> >  > +	depends on RCU_NOCB_CPU
> >  > +	help
> >  > +	  This option does not force any of the CPUs to be no-CBs CPUs.
> >  > +	  Only CPUs designated by the rcu_nocbs= boot parameter will be
> >  > +	  no-CBs CPUs.
> >  > +
> >  > +config RCU_NOCB_CPU_ZERO
> >  > +	bool "CPU 0 is a build_forced no-CBs CPU"
> >  > +	depends on RCU_NOCB_CPU
> >  > +	help
> >  > +	  This option forces CPU 0 to be a no-CBs CPU.  Additional CPUs
> >  > +	  may be designated as no-CBs CPUs using the rcu_nocbs= boot
> >  > +	  parameter will be no-CBs CPUs.
> >  > +
> >  > +	  Select this if CPU 0 needs to be a no-CBs CPU for real-time
> >  > +	  or energy-efficiency reasons.
> >  > +
> >  > +config RCU_NOCB_CPU_ALL
> >  > +	bool "All CPUs are build_forced no-CBs CPUs"
> >  > +	depends on RCU_NOCB_CPU
> >  > +	help
> >  > +	  This option forces all CPUs to be no-CBs CPUs.  The rcu_nocbs=
> >  > +	  boot parameter will be ignored.
> >  > +
> >  > +	  Select this if all CPUs need to be no-CBs CPUs for real-time
> >  > +	  or energy-efficiency reasons.
> > 
> > Note that entering '?' when prompted in oldconfig only outputs the help
> > parameter from the choice section.
> 
> I must defer to the Kconfig experts on this issue.  I have added them on CC.

Yes. plain '?' will give you the help of the 'choice' menu itself.

You can get the help entry for each option independently, by entering
the index followed by a '?', eg. (built-up with copy-paste from above,
actual display may vary slightly):

    Build-forced no-CBs CPUs
    > 1. No build_forced no-CBs CPUs (RCU_NOCB_CPU_NONE) (NEW)
      2. CPU 0 is a build_forced no-CBs CPU (RCU_NOCB_CPU_ZERO) (NEW)
      3. All CPUs are build_forced no-CBs CPUs (RCU_NOCB_CPU_ALL) (NEW)
    choice[1-3?]: 1?

    RCU_NOCB_CPU_NONE:
 
    This option does not force any of the CPUs to be no-CBs CPUs.
    Only CPUs designated by the rcu_nocbs= boot parameter will be
    no-CBs CPUs.

    Symbol: RCU_NOCB_CPU_NONE (=y)
    Type  : boolean
    Prompt: No build_forced no-CBs CPUs
      Defined at: file:X
      Depends on: <choice>
      Location:
        -> blabla -> Build-forced no-CBs CPUs (<choice> (=y>)

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
