Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549Ab3JNFz4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 01:55:56 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:29562 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab3JNFzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 01:55:54 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-2b-525b8768528f
Date: Mon, 14 Oct 2013 07:55:46 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH v2 0/2] cpufreq: exynos: Fixes for v3.12
Message-id: <20131014075546.72e0dc61@amdc308.digital.local>
In-reply-to: <2822925.9aRTDAMrLp@vostro.rjw.lan>
References: <1380108138-30402-1-git-send-email-l.majewski@samsung.com>
 <1381320523-28183-1-git-send-email-l.majewski@samsung.com>
 <1457107.oQjJi4YKRz@vostro.rjw.lan> <2822925.9aRTDAMrLp@vostro.rjw.lan>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42I5/e+xgG5Ge3SQQcMpPYuNM9azWjxt+sFu
	0Xn2CbPFm0fcFpd3zWGz+Nx7hNHiduMKNoszpy+xWqyf8ZrFYuNXD4u5vxtZHbg9ds66y+5x
	59oeNo91094ye2y52s7i0bdlFaPH501yAWxRXDYpqTmZZalF+nYJXBnrns5hKVjCVdG75DBz
	A2MzRxcjJ4eEgIlE09w5rBC2mMSFe+vZuhi5OIQEFjFKLDp5jgXCaWeSOHFlNjNIFYuAqsSj
	VdeZQGw2AT2Jz3efgtkiAtoSc3tOMYM0MAscZZZYdmQdWIOwgI3E80tH2UBsXgFribbHJ8DW
	cQoYSBxqPssOYgsJnGWUWHhCGMTmF5CUaP/3gxniJDuJc582sEP0Ckr8mHyPBcRmFtCS2Lyt
	iRXClpfYvOYt8wRGwVlIymYhKZuFpGwBI/MqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOB4
	eSa1g3Flg8UhRgEORiUeXgGn6CAh1sSy4srcQ4wSHMxKIrxX64BCvCmJlVWpRfnxRaU5qcWH
	GKU5WJTEeQ+0WgcKCaQnlqRmp6YWpBbBZJk4OKUaGNMPucTOdv/FZK1n+b3vsuzWPJV98iu4
	PC+2nNPc77FxV8AH8ZX7NtjcmM5pb2GkYeFyYIqR8CTFBZxbFv3idQqYlpFY8q02JT3mMkvH
	1krVDwwuXybOdhSR/1ev800qafrngBNTbznxflDdcbPzW++c6ONxDUlPpq3ROpfH8q4s9oFn
	/mq2S0osxRmJhlrMRcWJAIOMLkqTAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

> On Friday, October 11, 2013 01:22:57 PM Rafael J. Wysocki wrote:
> > On Wednesday, October 09, 2013 02:08:41 PM Lukasz Majewski wrote:
> > > Attached commits provide cpufreq regression fixes for Trats and
> > > Trats2 Exynos4 boards.
> > > Since v3.12 Exynos4 uses common clock framework for clock
> > > manipulation. Those patches restore correct output for
> > > cpuinfo_cur_freq [1] sysfs attribute.
> > > Without them, the [1] provides default frequency (800 MHz) set at
> > > driver initialization.
> > > 
> > > 
> > > Lukasz Majewski (2):
> > >   cpufreq: exynos4x12: Use the common clock framework to set APLL
> > > clock rate
> > >   cpufreq: exynos4210: Use the common clock framework to set APLL
> > > clock rate
> > > 
> > >  drivers/cpufreq/exynos4210-cpufreq.c |   67
> > > ++++-----------------------------
> > > drivers/cpufreq/exynos4x12-cpufreq.c |   69
> > > ++++------------------------------ 2 files changed, 16
> > > insertions(+), 120 deletions(-)
> > 
> > Can you please resend [1/2], it got lost somewhere (at least I
> > can't see it now)?
> 
> Scratch this, it's there in patchwork.
> 

Rafael, do you need any more help with those fixes? 

-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
