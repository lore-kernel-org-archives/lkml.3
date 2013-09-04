Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520Ab3IDSwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 14:52:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758009Ab3IDSww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 14:52:52 -0400
Subject: Re: [RFC PATCH 0/2] Perf support to SDT markers
From: Mark Wielaard <mjw@redhat.com>
To: Hemant <hkshaw@linux.vnet.ibm.com>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        srikar@linux.vnet.ibm.com, peterz@infradead.org, oleg@redhat.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org
In-Reply-To: <522777FF.2040906@linux.vnet.ibm.com>
References: <20130903072944.4793.93584.stgit@hemant-fedora>
	 <20130903082503.GA20732@gmail.com> <5225A937.2050507@hitachi.com>
	 <5225E2C5.3080001@linux.vnet.ibm.com>  <87a9jtt72j.fsf@sejong.aot.lge.com>
	 <1378283148.4321.16.camel@bordewijk.wildebeest.org>
	 <522777FF.2040906@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Sep 2013 20:52:15 +0200
Message-ID: <1378320735.4321.62.camel@bordewijk.wildebeest.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-04 at 23:42 +0530, Hemant wrote:
> On 09/04/2013 01:55 PM, Mark Wielaard wrote:
> > Note that if you use the normal DTRACE_PROBE macros no semaphore will be
> > inserted. And you can opt to not support probes that have a semaphore in
> > perf if you think that is easier (just check the semaphore link-time
> > address for the probe, it should normally be zero). Just warn: "No way I
> > am going to probe something that might have a little extra overhead! I
> > am no debugger..." :)
> 
> I agree. There will be an extra overhead but there may be some important 
> markers (on which we need to probe) may be worth this overhead?

Yes, there maybe. And gdb and stap do support them. But it means not
just setting the probe, but also incrementing (and decrementing) the
semaphore. See "Semaphore Handling" under
https://sourceware.org/systemtap/wiki/UserSpaceProbeImplementation

Which is extra work, so for a minimal implementation that just supports
normal (no-overhead) probes you might want to skip the extra work
required to support them. I believe they are normally not used. I
wouldn't recommend them and when I have added SDT probes myself I never
used/needed them, but I haven't actually looked what others do.

Cheers,

Mark

