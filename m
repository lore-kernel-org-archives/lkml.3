Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbaLPVPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 16:15:51 -0500
Received: from www.linutronix.de ([62.245.132.108]:51741 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbaLPVPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 16:15:49 -0500
Date: Tue, 16 Dec 2014 22:15:34 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
cc: Viresh Kumar <viresh.kumar@linaro.org>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, LKP <lkp@01.org>,
        "Zijlstra, Peter" <peter.zijlstra@intel.com>
Subject: Re: [nohz] 2a16fc93d2c: kernel lockup on idle injection
In-Reply-To: <20141216091528.17ee429d@ultegra>
Message-ID: <alpine.DEB.2.11.1412162205130.17382@nanos>
References: <20141211194204.GA19083@wfg-t540p.sh.intel.com> <CAKohpokEw6f5+u8J_AoV76sOAQO=J8dGhX1eZb=QZOuE+Jhq_A@mail.gmail.com> <548E8D01.9050707@linux.vnet.ibm.com> <CAKohpo=C8Jv-+CtmDO+QJ-_=3dNwsk6_W0gtRRHmtSQ8_LgObQ@mail.gmail.com> <548EAD4A.6070506@linux.vnet.ibm.com>
 <DD415AA12F8FF042BF4EA69DF123C1478AF76532@ORSMSX106.amr.corp.intel.com> <CAKohpokZCK3TAZx1mwo3zLxugkxg-h7MAXkTxA4LVWausufDYg@mail.gmail.com> <20141216091528.17ee429d@ultegra>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2014, Jacob Pan wrote:
> On Tue, 16 Dec 2014 09:48:42 +0530
> Viresh Kumar <viresh.kumar@linaro.org> wrote:
> > I really don't know what stuff out of the two patches I posted (The
> > above one and the fix I posted yesterday), will possible make the
> > synchronization bad ..
> > 
> But since your patch has real benefits and does not cause regression
> with the current code, there is no reason to hold it back. I was just
> hoping to get help on debugging this.

As I said elsewhere in this thread, this is not going anywhere. The
only sane decision is to revert 2a16fc93d2c9 for now.

Aside of that both NOHZ full and powerclamp need to be fixed
proper. Both of them are a complete disaster and just a steaming pile
of abuse and bandaids fixing the abuse. Read my other replies on that
before you ponder to argue.

The real solution for both things at the moment would be to make them
depend on BROKEN. I'm serious about that, really.

Your's grumpy

       tglx

