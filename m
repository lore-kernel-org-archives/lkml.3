Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608Ab3J2ONE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 10:13:04 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:47903 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab3J2ONC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 10:13:02 -0400
Message-ID: <526FC26A.8050806@gmail.com>
Date: Tue, 29 Oct 2013 08:12:58 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Neil Horman <nhorman@tuxdriver.com>
CC: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        sebastien.dugue@bull.net, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
References: <20131017003421.GA31470@hmsreliant.think-freely.org> <20131017084121.GC22705@gmail.com> <20131028160131.GA31048@hmsreliant.think-freely.org> <20131028162438.GB14350@gmail.com> <20131028174630.GB31048@hmsreliant.think-freely.org> <20131028182913.GD31048@hmsreliant.think-freely.org> <20131029082542.GA24625@gmail.com> <20131029112022.GA24477@neilslaptop.think-freely.org> <20131029113031.GA16897@gmail.com> <20131029114907.GE24477@neilslaptop.think-freely.org> <20131029125233.GA17449@gmail.com>
In-Reply-To: <20131029125233.GA17449@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/13 6:52 AM, Ingo Molnar wrote:
>> According to the perf man page, I'm supposed to be able to use --
>> to separate perf command line parameters from the command I want
>> to run.  And it definately executed test.sh, I added an echo to
>> stdout in there as a test run and observed them get captured in
>> counters.txt
>
> Well, '--' can be used to delineate the command portion for cases
> where it's ambiguous.
>
> Here's it's unambiguous though. This:
>
>    perf stat --repeat 20 -C 0 -ddd perf bench sched messaging -- /root/test.sh
>
> stops parsing a valid option after the -ddd option, so in theory it
> should execute 'perf bench sched messaging -- /root/test.sh' where
> '-- /root/test.sh' is simply a parameter to 'perf bench' and is thus
> ignored.

Normally with perf commands a workload can be specified to state how 
long to collect perf data. That is not the case for perf-bench.

David
