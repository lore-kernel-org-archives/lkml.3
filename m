Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662AbaA1VRW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 16:17:22 -0500
Received: from one.firstfloor.org ([193.170.194.197]:35409 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923AbaA1VRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 16:17:04 -0500
Date: Tue, 28 Jan 2014 22:17:02 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Ingo Molnar <mingo@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Plug racy xAPIC access of CPU hotplug code
Message-ID: <20140128211702.GB11821@two.firstfloor.org>
References: <52E6AFFE.3030004@siemens.com>
 <20140127202252.GA11821@two.firstfloor.org>
 <52E767C2.2090807@siemens.com>
 <20140128115549.GA26230@gmail.com>
 <52E79DEA.3010408@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E79DEA.3010408@siemens.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Of course, we still need irqs off during ICR writes. I thought Andi was
> just suggesting to replace preempt_disable with get_cpu, maybe to
> document why we are disabling preemption here.

Yes that was my point.

Also with irq-off you of course still always have races against
the NMI-level machine check.

-Andi
