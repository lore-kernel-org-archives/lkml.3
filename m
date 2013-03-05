Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472Ab3CENGm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 08:06:42 -0500
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:51329 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751611Ab3CENGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 08:06:41 -0500
Message-ID: <1362488795.16460.82.camel@x61.thuisdomein>
Subject: Re: [PATCH v2] MIPS: Get rid of CONFIG_CPU_HAS_LLSC again
From: Paul Bolle <pebolle@tiscali.nl>
To: Jonas Gorski <jogo@openwrt.org>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Date: Tue, 05 Mar 2013 14:06:35 +0100
In-Reply-To: <CAOiHx=nvH-Q+3HCkukM9ZDZXLm=w0bO9LPyosQS7UHOmOvQYOQ@mail.gmail.com>
References: <1362477800.16460.69.camel@x61.thuisdomein>
	 <CAOiHx=nzNVatEp0nyfZKU2p35+1kjrw6VsvZTP+QPJykWF3JAg@mail.gmail.com>
	 <1362486020.16460.73.camel@x61.thuisdomein>
	 <CAOiHx=nvH-Q+3HCkukM9ZDZXLm=w0bO9LPyosQS7UHOmOvQYOQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Mar 2013 13:06:35.0217 (UTC) FILETIME=[43BCDC10:01CE19A2]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-05 at 13:55 +0100, Jonas Gorski wrote:
> On 5 March 2013 13:20, Paul Bolle <pebolle@tiscali.nl> wrote:
> > diff --git a/arch/mips/include/asm/mach-sead3/cpu-feature-overrides.h b/arch/mips/include/asm/mach-sead3/cpu-feature-overrides.h
> > index d9c8284..b40f37f 100644
> > --- a/arch/mips/include/asm/mach-sead3/cpu-feature-overrides.h
> > +++ b/arch/mips/include/asm/mach-sead3/cpu-feature-overrides.h
> > @@ -28,11 +28,7 @@
> >  /* #define cpu_has_prefetch    ? */
> >  #define cpu_has_mcheck         1
> >  /* #define cpu_has_ejtag       ? */
> > -#ifdef CONFIG_CPU_HAS_LLSC
> > -#define cpu_has_llsc           1
> > -#else
> >  #define cpu_has_llsc           0
> > -#endif
> 
> Hm, shouldn't you leave cpu_has_llsc set to 1? At least the "old" path
> SEAD3 => CPU_MIPS32_R1/R2/64_R1 => select CPU_HAS_LLSC for all three
> would have always caused this to be 1.

That would mean an actual change to the code. See, there's no Kconfig
symbol CPU_HAS_LLSC since v2.6.32. This means that CONFIG_CPU_HAS_LLSC
has not been defined ever since and that SEAD3 has been having
cpu_has_llsc set to 0 for some time now. My patch just removes dead
code.

Perhaps SEAD3 need cpu_has_llsc set to 1. I wouldn't know. Anyhow, that
should be done in another patch, with (runtime) testing, etc.


Paul Bolle

