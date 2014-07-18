Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759317AbaGRFgY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 01:36:24 -0400
Received: from wolff.to ([98.103.208.27]:53860 "HELO wolff.to"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751807AbaGRFgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 01:36:23 -0400
Date: Fri, 18 Jul 2014 00:34:49 -0500
From: Bruno Wolff III <bruno@wolff.to>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Josh Boyer <jwboyer@redhat.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Scheduler regression from
 caffcdd8d27ba78730d5540396ce72ad022aff2c
Message-ID: <20140718053449.GA2039@wolff.to>
References: <20140716145546.GA6922@wolff.to>
 <20140716151748.GC2460@hansolo.jdub.homelinux.org>
 <53C6CFCC.2050300@arm.com>
 <20140716195414.GA16401@wolff.to>
 <53C7084C.7090104@arm.com>
 <20140717030947.GA17889@wolff.to>
 <53C79013.1020808@arm.com>
 <20140717090452.GH19379@twins.programming.kicks-ass.net>
 <53C7B247.2070309@arm.com>
 <20140717123502.GL19379@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20140717123502.GL19379@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 14:35:02 +0200,
  Peter Zijlstra <peterz@infradead.org> wrote:
>
>In any case, can someone who can trigger this run with the below; its
>'clean' for me, but supposedly you'll trigger a FAIL somewhere.

I got a couple of fail messages.

dmesg output is available in the bug as the following attachment:
https://bugzilla.kernel.org/attachment.cgi?id=143361

The part of interest is probably:

[    0.253354] build_sched_groups: got group f255b020 with cpus: 
[    0.253436] build_sched_groups: got group f255b120 with cpus: 
[    0.253519] build_sched_groups: got group f255b1a0 with cpus: 
[    0.253600] build_sched_groups: got group f255b2a0 with cpus: 
[    0.253681] build_sched_groups: got group f255b2e0 with cpus: 
[    0.253762] build_sched_groups: got group f255b320 with cpus: 
[    0.253843] build_sched_groups: got group f255b360 with cpus: 
[    0.254004] build_sched_groups: got group f255b0e0 with cpus: 
[    0.254087] build_sched_groups: got group f255b160 with cpus: 
[    0.254170] build_sched_groups: got group f255b1e0 with cpus: 
[    0.254252] build_sched_groups: FAIL
[    0.254331] build_sched_groups: got group f255b1a0 with cpus: 0
[    0.255004] build_sched_groups: FAIL
[    0.255084] build_sched_groups: got group f255b1e0 with cpus: 1

I also booted with early printk=keepsched_debug as requested by 
Dietmar.
