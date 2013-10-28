Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191Ab3J1Qtr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 12:49:47 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:52747 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756591Ab3J1Qtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 12:49:45 -0400
Message-ID: <526E95A1.7080701@gmail.com>
Date: Mon, 28 Oct 2013 10:49:37 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Neil Horman <nhorman@tuxdriver.com>
CC: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        sebastien.dugue@bull.net, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
References: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com> <20131012172124.GA18241@gmail.com> <20131014202854.GH26880@hmsreliant.think-freely.org> <1381785560.2045.11.camel@edumazet-glaptop.roam.corp.google.com> <1381789127.2045.22.camel@edumazet-glaptop.roam.corp.google.com> <20131017003421.GA31470@hmsreliant.think-freely.org> <20131017084121.GC22705@gmail.com> <20131028160131.GA31048@hmsreliant.think-freely.org> <20131028162438.GB14350@gmail.com>
In-Reply-To: <20131028162438.GB14350@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/13 10:24 AM, Ingo Molnar wrote:

> The most accurate method of measurement for such single-threaded
> workloads is something like:
>
> 	taskset 0x1 perf stat -a -C 1 --repeat 20 ...
>
> this will bind your workload to CPU#0, and will do PMU measurements
> only there - without mixing in other CPUs or workloads.

you can drop the -a if you only want a specific CPU (-C arg). And -C in 
perf is cpu number starting with 0, so in your example above -C 1 means 
cpu1, not cpu0.

David


