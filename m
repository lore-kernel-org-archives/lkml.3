Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab3JBLxE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 07:53:04 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43659 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399Ab3JBLxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 07:53:02 -0400
Date: Wed, 2 Oct 2013 13:52:36 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, bp@alien8.de, akpm@linux-foundation.org,
        tglx@linutronix.de, bp@suse.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/boot] x86/boot: Further compress CPUs bootup message
Message-ID: <20131002115235.GR3081@twins.programming.kicks-ass.net>
References: <20130930095624.GB16383@pd.tnic>
 <tip-a17bce4d1dce8f3cf714bc2e5d8e4bac009dc077@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-a17bce4d1dce8f3cf714bc2e5d8e4bac009dc077@git.kernel.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 01, 2013 at 02:10:30AM -0700, tip-bot for Borislav Petkov wrote:
> Commit-ID:  a17bce4d1dce8f3cf714bc2e5d8e4bac009dc077
> Gitweb:     http://git.kernel.org/tip/a17bce4d1dce8f3cf714bc2e5d8e4bac009dc077
> Author:     Borislav Petkov <bp@alien8.de>
> AuthorDate: Mon, 30 Sep 2013 11:56:24 +0200
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Tue, 1 Oct 2013 10:52:30 +0200
> 
> x86/boot: Further compress CPUs bootup message
> 
> Turn it into (for example):
> 
> [    0.073380] x86: Booting SMP configuration:
> [    0.074005] .... node   #0, CPUs:          #1   #2   #3   #4   #5   #6   #7
> [    0.603005] .... node   #1, CPUs:     #8   #9  #10  #11  #12  #13  #14  #15
> [    1.200005] .... node   #2, CPUs:    #16  #17  #18  #19  #20  #21  #22  #23
> [    1.796005] .... node   #3, CPUs:    #24  #25  #26  #27  #28  #29  #30  #31
> [    2.393005] .... node   #4, CPUs:    #32  #33  #34  #35  #36  #37  #38  #39
> [    2.996005] .... node   #5, CPUs:    #40  #41  #42  #43  #44  #45  #46  #47
> [    3.600005] .... node   #6, CPUs:    #48  #49  #50  #51  #52  #53  #54  #55
> [    4.202005] .... node   #7, CPUs:    #56  #57  #58  #59  #60  #61  #62  #63
> [    4.811005] .... node   #8, CPUs:    #64  #65  #66  #67  #68  #69  #70  #71
> [    5.421006] .... node   #9, CPUs:    #72  #73  #74  #75  #76  #77  #78  #79
> [    6.032005] .... node  #10, CPUs:    #80  #81  #82  #83  #84  #85  #86  #87
> [    6.648006] .... node  #11, CPUs:    #88  #89  #90  #91  #92  #93  #94  #95
> [    7.262005] .... node  #12, CPUs:    #96  #97  #98  #99 #100 #101 #102 #103
> [    7.865005] .... node  #13, CPUs:   #104 #105 #106 #107 #108 #109 #110 #111
> [    8.466005] .... node  #14, CPUs:   #112 #113 #114 #115 #116 #117 #118 #119
> [    9.073006] .... node  #15, CPUs:   #120 #121 #122 #123 #124 #125 #126 #127
> [    9.679901] x86: Booted up 16 nodes, 128 CPUs
> 

[    0.314494] smpboot: Booting Node   0, Processors  #   1[    0.333365] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
 #   2 #   3 #   4 #   5 OK
[    0.398473] smpboot: Booting Node   1, Processors  #   6 #   7 #   8 #   9 #  10 #  11 OK
[    0.565198] smpboot: Booting Node   0, Processors  #  12 #  13 #  14 #  15 #  16 #  17 OK
[    0.654558] smpboot: Booting Node   1, Processors  #  18 #  19 #  20 #  21 #  22 #  23 OK
[    0.743527] Brought up 24 CPUs

Bah, ugly.. 
