Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbaH2UGu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 16:06:50 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:35135 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853AbaH2UGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 16:06:49 -0400
Date: Fri, 29 Aug 2014 21:06:46 +0100
From: Sitsofe Wheeler <sitsofe@gmail.com>
To: =?iso-8859-1?Q?Chlo=E9?= Desoutter <chloe.desoutter@atasta.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: linux 3.16 APIC and bhyve won't boot
Message-ID: <20140829200646.GB20771@sucs.org>
References: <540083B4.8050401@atasta.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <540083B4.8050401@atasta.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Aug 29, 2014 at 03:44:20PM +0200, Chloé Desoutter wrote:
> 
> [1.] One line summary of the problem:
> On Linux 3.16 a custom-built kernel with bhyve won't boot and will
> hang on the APIC timer calibration.

Wow I haven't seen a report in this style in a while...

> [2.] Full description of the problem/report:
> I'm booting a 3.16 in bhyve (FreeBSD hypervisor) and according to my tests
> lapic_cal_handler never gets called. This prevents the lapic_cal_loops
> counter from being incremented and therefore the APIC calibration never
> finishes. It is supposed to be called 25 times (APIC_CAL_LOOPS
> constant). I added some apic_printk's to check for these infos (not a
> best practice but I don't have access to a debugger in this specific
> context).

<snip>

> [7.7.] Other information that might be relevant to the problem
> A stock Debian 3.2 kernel will boot. I don't have the possibility to
> build such a bloated kernel to see what's missing. My goal is to
> identify what is the minimal set of functionalities needed to have a
> kernel start up in a bhyve context. I have several other Linux VMs
> able to run on this hypervisor, none with such a recent kernel.

Without being able to email explicit people in addition to the general
LKML there's a good chance this will be overlooked. I can only guess the
problem has something to do with arch/x86/kernel/apic/apic.c but I don't
really know...

What will help a lot is if you can try your cut down 3.16 but modify it
using make oldconfig on an old 3.2 kernel and see if that boots. If it
does, then you can use git bisect v3.16 v3.2 to narrow down the exact
commit that introduced the problem.

-- 
Sitsofe | http://sucs.org/~sits/
