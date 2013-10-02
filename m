Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab3JBMSm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 08:18:42 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:36456 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945Ab3JBMSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 08:18:38 -0400
Date: Wed, 2 Oct 2013 14:18:34 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        bp@alien8.de, akpm@linux-foundation.org, tglx@linutronix.de,
        bp@suse.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/boot] x86/boot: Further compress CPUs bootup message
Message-ID: <20131002121834.GB25568@gmail.com>
References: <20130930095624.GB16383@pd.tnic>
 <tip-a17bce4d1dce8f3cf714bc2e5d8e4bac009dc077@git.kernel.org>
 <20131002115235.GR3081@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131002115235.GR3081@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, Oct 01, 2013 at 02:10:30AM -0700, tip-bot for Borislav Petkov wrote:
> > Commit-ID:  a17bce4d1dce8f3cf714bc2e5d8e4bac009dc077
> > Gitweb:     http://git.kernel.org/tip/a17bce4d1dce8f3cf714bc2e5d8e4bac009dc077
> > Author:     Borislav Petkov <bp@alien8.de>
> > AuthorDate: Mon, 30 Sep 2013 11:56:24 +0200
> > Committer:  Ingo Molnar <mingo@kernel.org>
> > CommitDate: Tue, 1 Oct 2013 10:52:30 +0200
> > 
> > x86/boot: Further compress CPUs bootup message
> > 
> > Turn it into (for example):
> > 
> > [    0.073380] x86: Booting SMP configuration:
> > [    0.074005] .... node   #0, CPUs:          #1   #2   #3   #4   #5   #6   #7
> > [    0.603005] .... node   #1, CPUs:     #8   #9  #10  #11  #12  #13  #14  #15
> > [    1.200005] .... node   #2, CPUs:    #16  #17  #18  #19  #20  #21  #22  #23
> > [    1.796005] .... node   #3, CPUs:    #24  #25  #26  #27  #28  #29  #30  #31
> > [    2.393005] .... node   #4, CPUs:    #32  #33  #34  #35  #36  #37  #38  #39
> > [    2.996005] .... node   #5, CPUs:    #40  #41  #42  #43  #44  #45  #46  #47
> > [    3.600005] .... node   #6, CPUs:    #48  #49  #50  #51  #52  #53  #54  #55
> > [    4.202005] .... node   #7, CPUs:    #56  #57  #58  #59  #60  #61  #62  #63
> > [    4.811005] .... node   #8, CPUs:    #64  #65  #66  #67  #68  #69  #70  #71
> > [    5.421006] .... node   #9, CPUs:    #72  #73  #74  #75  #76  #77  #78  #79
> > [    6.032005] .... node  #10, CPUs:    #80  #81  #82  #83  #84  #85  #86  #87
> > [    6.648006] .... node  #11, CPUs:    #88  #89  #90  #91  #92  #93  #94  #95
> > [    7.262005] .... node  #12, CPUs:    #96  #97  #98  #99 #100 #101 #102 #103
> > [    7.865005] .... node  #13, CPUs:   #104 #105 #106 #107 #108 #109 #110 #111
> > [    8.466005] .... node  #14, CPUs:   #112 #113 #114 #115 #116 #117 #118 #119
> > [    9.073006] .... node  #15, CPUs:   #120 #121 #122 #123 #124 #125 #126 #127
> > [    9.679901] x86: Booted up 16 nodes, 128 CPUs
> > 
> 
> [    0.314494] smpboot: Booting Node   0, Processors  #   1[    0.333365] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
>  #   2 #   3 #   4 #   5 OK
> [    0.398473] smpboot: Booting Node   1, Processors  #   6 #   7 #   8 #   9 #  10 #  11 OK
> [    0.565198] smpboot: Booting Node   0, Processors  #  12 #  13 #  14 #  15 #  16 #  17 OK
> [    0.654558] smpboot: Booting Node   1, Processors  #  18 #  19 #  20 #  21 #  22 #  23 OK
> [    0.743527] Brought up 24 CPUs

That's not how it looks like here:

[    0.369572] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.377957] x86: Booting SMP configuration:
[    0.382294] .... node  #0, CPUs:        #1  #2  #3
[    0.428340] .... node  #1, CPUs:    #4  #5  #6  #7
[    0.564304] .... node  #2, CPUs:    #8  #9 #10 #11
[    0.700242] .... node  #3, CPUs:   #12 #13 #14 #15
[    0.836819] x86: Booted up 4 nodes, 16 CPUs
[    0.841487] smpboot: Total of 16 processors activated (73944.72 BogoMIPS)

and:

[    0.304732] x86: Booting SMP configuration:
[    0.326682] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.309034] .... node  #0, CPUs:        #1  #2  #3  #4  #5  #6  #7
[    0.417810] .... node  #1, CPUs:    #8  #9 #10 #11 #12 #13 #14 #15
[    0.608563] x86: Booted up 2 nodes, 16 CPUs
[    0.613169] smpboot: Total of 16 processors activated (89598.99 BogoMIPS)

Thanks,

	Ingo
