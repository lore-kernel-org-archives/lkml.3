Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910AbaGWBjA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 21:39:00 -0400
Received: from wolff.to ([98.103.208.27]:48338 "HELO wolff.to"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751145AbaGWBi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 21:38:59 -0400
Date: Tue, 22 Jul 2014 20:37:19 -0500
From: Bruno Wolff III <bruno@wolff.to>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Josh Boyer <jwboyer@redhat.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Scheduler regression from
 caffcdd8d27ba78730d5540396ce72ad022aff2c
Message-ID: <20140723013719.GA2000@wolff.to>
References: <20140721163528.GA10433@wolff.to>
 <20140721165212.GO3935@laptop>
 <20140722094740.GJ12054@laptop.lan>
 <20140722103857.GK12054@laptop.lan>
 <20140722121001.GA30631@wolff.to>
 <20140722130343.GD3935@laptop>
 <20140722132603.GL12054@laptop.lan>
 <20140722133514.GM12054@laptop.lan>
 <20140722140912.GA23406@wolff.to>
 <20140722141855.GG3935@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20140722141855.GG3935@laptop>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 16:18:55 +0200,
  Peter Zijlstra <peterz@infradead.org> wrote:
>
>You can put this on top of them. I hope that this will make the pr_err()
>introduced in the robustify patch go away.

I went to 3.16-rc6 and then reapplied three patches from your previous 
email messages. The dmesg output and the diff from 3.16-rc6 have been 
added to https://bugzilla.kernel.org/show_bug.cgi?id=80251 .
The dmesg output is at: https://bugzilla.kernel.org/attachment.cgi?id=143961
The combined diff is at: https://bugzilla.kernel.org/attachment.cgi?id=143971

What I think you are probably looking for in the dmesg output:
[    0.251061] __sdt_alloc: allocated f515b020 with cpus: 
[    0.251149] __sdt_alloc: allocated f515b0e0 with cpus: 
[    0.251231] __sdt_alloc: allocated f515b120 with cpus: 
[    0.251313] __sdt_alloc: allocated f515b160 with cpus: 
[    0.251397] __sdt_alloc: allocated f515b1a0 with cpus: 
[    0.251479] __sdt_alloc: allocated f515b1e0 with cpus: 
[    0.251561] __sdt_alloc: allocated f515b220 with cpus: 
[    0.251643] __sdt_alloc: allocated f515b260 with cpus: 
[    0.252011] __sdt_alloc: allocated f515b2a0 with cpus: 
[    0.252095] __sdt_alloc: allocated f515b2e0 with cpus: 
[    0.252184] __sdt_alloc: allocated f515b320 with cpus: 
[    0.252266] __sdt_alloc: allocated f515b360 with cpus: 
[    0.252355] build_sched_domain: cpu: 0 level: SMT cpu_map: 0-3 tl->mask: 0,2
[    0.252441] build_sched_domain: cpu: 0 level: MC cpu_map: 0-3 tl->mask: 0,2
[    0.252526] build_sched_domain: cpu: 0 level: DIE cpu_map: 0-3 tl->mask: 0-3
[    0.252611] build_sched_domain: cpu: 1 level: SMT cpu_map: 0-3 tl->mask: 1,3
[    0.252696] build_sched_domain: cpu: 1 level: MC cpu_map: 0-3 tl->mask: 1,3
[    0.252781] build_sched_domain: cpu: 1 level: DIE cpu_map: 0-3 tl->mask: 0-3
[    0.252866] build_sched_domain: cpu: 2 level: SMT cpu_map: 0-3 tl->mask: 0,2
[    0.252951] build_sched_domain: cpu: 2 level: MC cpu_map: 0-3 tl->mask: 0,2
[    0.253005] build_sched_domain: cpu: 2 level: DIE cpu_map: 0-3 tl->mask: 0-3
[    0.253091] build_sched_domain: cpu: 3 level: SMT cpu_map: 0-3 tl->mask: 1,3
[    0.253176] build_sched_domain: cpu: 3 level: MC cpu_map: 0-3 tl->mask: 1,3
[    0.253261] build_sched_domain: cpu: 3 level: DIE cpu_map: 0-3 tl->mask: 0-3
[    0.254004] build_sched_groups: got group f515b020 with cpus: 
[    0.254088] build_sched_groups: got group f515b120 with cpus: 
[    0.254170] build_sched_groups: got group f515b1a0 with cpus: 
[    0.254253] build_sched_groups: got group f515b2a0 with cpus: 
[    0.254336] build_sched_groups: got group f515b2e0 with cpus: 
[    0.254419] build_sched_groups: got group f515b0e0 with cpus: 
[    0.254502] build_sched_groups: got group f515b160 with cpus: 
[    0.254585] build_sched_groups: got group f515b1e0 with cpus: 
[    0.254680] CPU0 attaching sched-domain:
[    0.254684]  domain 0: span 0,2 level SMT
[    0.254687]   groups: 0 (cpu_capacity = 586) 2 (cpu_capacity = 588)
[    0.254695]   domain 1: span 0-3 level DIE
[    0.254698]    groups: 0,2 (cpu_capacity = 1174) 1,3 (cpu_capacity = 1176)
[    0.254709] CPU1 attaching sched-domain:
[    0.254711]  domain 0: span 1,3 level SMT
[    0.254714]   groups: 1 (cpu_capacity = 588) 3 (cpu_capacity = 588)
[    0.254721]   domain 1: span 0-3 level DIE
[    0.254724]    groups: 1,3 (cpu_capacity = 1176) 0,2 (cpu_capacity = 1174)
[    0.254733] CPU2 attaching sched-domain:
[    0.254735]  domain 0: span 0,2 level SMT
[    0.254738]   groups: 2 (cpu_capacity = 588) 0 (cpu_capacity = 586)
[    0.254745]   domain 1: span 0-3 level DIE
[    0.254747]    groups: 0,2 (cpu_capacity = 1174) 1,3 (cpu_capacity = 1176)
[    0.254756] CPU3 attaching sched-domain:
[    0.254758]  domain 0: span 1,3 level SMT
[    0.254761]   groups: 3 (cpu_capacity = 588) 1 (cpu_capacity = 588)
[    0.254768]   domain 1: span 0-3 level DIE
[    0.254770]    groups: 1,3 (cpu_capacity = 1176) 0,2 (cpu_capacity = 1174)
