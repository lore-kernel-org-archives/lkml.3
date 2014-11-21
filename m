Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758987AbaKUQtL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 11:49:11 -0500
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:59573 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758849AbaKUQtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 11:49:01 -0500
X-ME-Helo: beldin
X-ME-Date: Fri, 21 Nov 2014 17:48:58 +0100
X-ME-IP: 109.222.88.20
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Michal Marek <mmarek@suse.cz>, Daniel Mack <daniel@zonque.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kbuild@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: arm: pxa: CPU_PXA27x?
References: <1416566627.6958.16.camel@x220>
X-URL: http://belgarath.falguerolles.org/
Date: Fri, 21 Nov 2014 17:48:55 +0100
In-Reply-To: <1416566627.6958.16.camel@x220> (Paul Bolle's message of "Fri, 21
	Nov 2014 11:43:47 +0100")
Message-ID: <87vbm85wjs.fsf@free.fr>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Bolle <pebolle@tiscali.nl> writes:

> Robert,
>
> Your commit 03ec7fe70c5c ("arm: pxa: add pxa27x device-tree support") is
> included in today's linux-next (ie, next-20141121). It adds a select
> statement for CPU_PXA27x. But there's no Kconfig symbol CPU_PXA27x.
Ah yes, you're perfectly right, CPU_PXA27x was not the one, it was PXA27x, sic
..

>
> Why is that select needed? For what it's worth: __cpu_is_pxa27x()
> compiles to something interesting if CONFIG_PXA27x is defined.
You mean "is not defined", right ?

That (CONFIG_PXA27x) select is needed because without it the arm cpu
architecture is not selected, ie. CONFIG_CPU_XSCALE is not set. And this in turn
is needed to choose the basic arm operations like TLB handling, cache handling,
etc ... You cannot compile a single platform kernel without this.

As a poor excuse, I hadn't seen this because this resulted from a poor merge
resolution which brought in both "select PXA27x" and "select CPU_PXA27x".

> In https://lkml.org/lkml/2014/9/30/578 I proposed a patch that emits a
> warning in cases like this. Like _all_ Kconfig related patches I've seen
> flying by lately it appears to be dropped in /dev/null. What's going on?
For that one I don't know.

Ah, and yes I'll send an update patch to remove the "select CPU_PXA27x", thanks
for noticing this.

Cheers.

-- 
Robert
