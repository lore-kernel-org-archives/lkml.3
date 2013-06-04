Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab3FDLVz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 07:21:55 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:57829 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064Ab3FDLVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 07:21:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michael Karcher <Michael.Karcher@fu-berlin.de>
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>, linux-pm@vger.kernel.org,
        Len Brown <len.brown@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: power management regression in linux 3.10? (related to CONFIG_NO_HZ_FULL)
Date: Tue, 04 Jun 2013 13:30:54 +0200
Message-ID: <1906476.HVJCZCXmXX@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1370308128.6305.3.camel@localhost>
References: <1370282175.18020.4.camel@localhost> <51ACF071.702@gmail.com> <1370308128.6305.3.camel@localhost>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 04, 2013 03:08:48 AM Michael Karcher wrote:
> Am Montag, den 03.06.2013, 12:37 -0700 schrieb Dirk Brandewie:
> > On 06/03/2013 12:34 PM, Rafael J. Wysocki wrote:
> > > On Monday, June 03, 2013 07:56:15 PM Michael Karcher wrote:
> > >> Hello,
> > > Yes, please try with CONFIG_NO_HZ_IDLE and see if you can reproduce the
> > > problem.
> Instead of doing that, I successfully applied Dirk's suggestion. Is
> CONFIG_NO_HZ + CONFIG_NO_HZ_IDLE worth testing?

Yes, it is.

> > > Does your system use intel_idle?  You've set that in .config, but can you check
> > > what dmesg says, please?
> No, intel_idle complains it doesn't support my CPU family.

I thought so.  It is using the ACPI idle driver, then, so I think cpuidle in
general is affected.

That seems to be a time accounting problem of some sort (adding CCs to Ingo and
Thomas).

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
