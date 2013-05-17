Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab3EQXgy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 19:36:54 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:57754 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752974Ab3EQXgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 19:36:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Paul E. McKenney" <paul.mckenney@linaro.org>
Cc: Arend van Spriel <arend@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: REGRESSION: 3.10-rc1: Dell Latitude e6410 hangs within 3 seconds
Date: Sat, 18 May 2013 01:45:30 +0200
Message-ID: <2152370.hoU9Fodeoj@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <519697CC.1070308@broadcom.com>
References: <5192363E.7040204@broadcom.com> <5192A0DE.90209@broadcom.com> <519697CC.1070308@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Is this known?

Rafael


On Friday, May 17, 2013 10:49:16 PM Arend van Spriel wrote:
> On 05/14/2013 10:38 PM, Arend van Spriel wrote:
> > On 05/14/2013 10:34 PM, Rafael J. Wysocki wrote:
> >> On Tuesday, May 14, 2013 03:03:58 PM Arend van Spriel wrote:
> >>> Laptop hangs pretty soon after booting. Workaround for me was to turn
> >>> off ACPI on kernel command line, ie. acpi=off
> >>>
> >>> Attached is my kernel configuration.
> >>
> >> Well, I have no idea what may be the source of this.
> >
> > Me neither.
> >
> >> Any chance to bisect?
> >
> > can try. Rebuilding kernels can be a drag :-p
> >
> > Regards,
> > Arend
> 
> Hi Rafael,
> 
> The bisect result found commit c0f4dfd4f as culprit. I also verified 
> that the merge into Linus' tree introduced the issue upstream, ie. 
> 6c24499 works and 1f889ec does not. I tried to revert the commit, but 
> that was a bit risky (conflict to resolve) and did not give me a stable 
> kernel. The only thing that works is selecting acpi=off. I tried also 
> nohz=off but that resulted in /init failure.
> 
> Regards,
> Arend
> 
> ---8<----------------------------------------------------------------
> 
> commit 1f889ec62c3f0d8913f3c32f9aff2a1e15099346
>    Merge: 6c24499 8fcfae3
> 
>    commit 8fcfae31719c0a6c03f2cf63f815b46d378d8be4
>      Merge: d02a9a8 6d87669
> 
>      commit 6d87669357936bffa1e8fea7a4e7743e76905736
>        Merge: 3f944ad 81e5949 910ee45
> 
>        commit c0f4dfd4f90f1667d234d21f15153ea09a2eaa66
>        Author: Paul E. McKenney <paul.mckenney@linaro.org>
>        Date:   Fri Dec 28 11:30:36 2012 -0800
> 
>            rcu: Make RCU_FAST_NO_HZ take advantage of numbered callbacks
> 
>            Because RCU callbacks are now associated with the number
>            of the grace period that they must wait for, CPUs can now
>            take advance callbacks corresponding to grace periods that
>            ended while a given CPU was in dyntick-idle mode. This
>            eliminates the need to try forcing the RCU state machine
>            while entering idle, thus reducing the CPU intensiveness
>            of RCU_FAST_NO_HZ, which should increase its energy
>            efficiency.
> 
>        Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
>        Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
