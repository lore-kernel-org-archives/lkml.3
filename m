Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192AbaAMPun (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 10:50:43 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:62351 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbaAMPul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 10:50:41 -0500
Date: Mon, 13 Jan 2014 16:50:37 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <ak@linux.jf.intel.com>
Subject: Re: [PATCH RFC v2 0/4] perf: IRQ-bound performance events
Message-ID: <20140113155034.GA10355@localhost.localdomain>
References: <cover.1388858996.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1388858996.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 04, 2014 at 07:22:32PM +0100, Alexander Gordeev wrote:
> Hello,
> 
> This is version 2 of RFC "perf: IRQ-bound performance events". That is an
> introduction of IRQ-bound performance events - ones that only count in a
> context of a hardware interrupt handler. Ingo suggested to extend this
> functionality to softirq and threaded handlers as well:

Hi Alexander,

I still strongly think we should use toggle events to achieve that:
https://lkml.org/lkml/2013/9/25/227

This will let us count not just IRQs (-e 'cycles,irq_entry/on=cycles/,irq_exit/off=cycles/') but much more. 

The patchset still needs some polishing but I think that's a better diection.

Thanks.
