Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067Ab3JGEml (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 00:42:41 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:61249 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab3JGEmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 00:42:39 -0400
Message-ID: <1381120901.9926.11.camel@marge.simpson.net>
Subject: Re: [PATCH V3]hrtimer: Fix a performance regression by disable
 reprogramming in remove_hrtimer
From: Mike Galbraith <bitbucket@online.de>
To: Ethan Zhao <ethan.kernel@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rjw@sisk.pl,
        daniel.lezcano@linaro.org, linux-pm@vger.kernel.org, lenb@kernel.org
Date: Mon, 07 Oct 2013 06:41:41 +0200
In-Reply-To: <CABawtvMo+NtTv3a3jj=YTg-Om=MzHhVDARdtTA-DtTMzNeNAJA@mail.gmail.com>
References: <24EECBCC-F655-404F-8946-73CC36095A5F@gmail.com>
	 <1378362989.18435.2.camel@marge.simpson.net>
	 <20130905111428.GB23362@gmail.com>
	 <1378386697.6567.9.camel@marge.simpson.net>
	 <20130905133750.GA26637@gmail.com>
	 <1378445942.5434.31.camel@marge.simpson.net>
	 <20130909122325.GX31370@twins.programming.kicks-ass.net>
	 <1378730538.5586.30.camel@marge.simpson.net>
	 <20130909133044.GB31370@twins.programming.kicks-ass.net>
	 <20130909134635.GB26785@twins.programming.kicks-ass.net>
	 <20130911085643.GS26785@twins.programming.kicks-ass.net>
	 <1378895123.5476.83.camel@marge.simpson.net>
	 <CABawtvMo+NtTv3a3jj=YTg-Om=MzHhVDARdtTA-DtTMzNeNAJA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:3kdhb7LlWyGkCpEPsZ7E/1wlU7VZ1qDQAPYWBwc+1O9
 E4YFiYdWx6az+xSTi++CDjR1a/TomJPcVzicQcRwGEMf+ZkT/Y
 4K6CN55A05fRLNL+JCJ6uMPcxPTdZWuy4n6dXT44J2tdzJPxi4
 XysQVDkR6Mzg4tczbV44dReOjEyCiASCo8fODRp2E2mua8/XVp
 4UollhlQYiAHkgG+zw5Mcb6jWipPSP2QwZmEGxA8FezCPFlhd1
 bvJkGjOH4/Tsib5VmRNyBtU72L06G+8ZsSUgVh5k5s4ubTE8NA
 uBd/55zCHpUVn+eSjFTh4Xdc4jaAWTgdGA5W2RHS0IKQdVol+P
 3716YZjeZaaGC4pS1acHL1t3/JwDwiXV3+t7toFa5GVnZxHF+Q
 vMQD8lcaUmKlg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-04 at 20:06 +0800, Ethan Zhao wrote: 
> Mike, Peter,
>    Seems lots of work has been done these days, studious guys. those
> patches merged in last stable/dev branch (fix performance regression
> caused by extra rtimer programming and rescheduling IPI,confusing
> idle... etc) ? So I could just do a lazy pull for test with my
> environment.  I need catch up with other mail loops with my vacation
> again.

Massive timer overhead seems to have crawled off and died while I wasn't
looking.  Peter's fix for IPI woes..

tip commit ea811747 sched, idle: Fix the idle polling state logic

..hasn't yet swum upstream.

-Mike

