Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbaJMNX2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 09:23:28 -0400
Received: from mail-oi0-f49.google.com ([209.85.218.49]:64443 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161AbaJMNXY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 09:23:24 -0400
Date: Mon, 13 Oct 2014 08:23:19 -0500
From: Chuck Ebbert <cebbert.lkml@gmail.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 3.17 00/25] 3.17.1-stable review
Message-ID: <20141013082319.175d90bb@as>
In-Reply-To: <20141013112834.GA10826@khazad-dum.debian.net>
References: <20141013022454.289398272@linuxfoundation.org>
	<20141013112834.GA10826@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Oct 2014 08:28:35 -0300
Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:

> On Mon, 13 Oct 2014, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.17.1
> > release. There are 25 patches in this series, all will be posted
> > as a response to this one.  If anyone has any issues with these
> > being applied, please let me know.
> 
> Actually, 3.17 is a filesystem killer for some unlucky users due to
> the libata blacklist being disabled by a bug.
> 
> Patch:
> https://git.kernel.org/cgit/linux/kernel/git/tj/libata.git/patch/?id=1c40279960bcd7d52dbdf1d466b20d24b99176c8
> 1c40279960bcd7d52dbdf1d466b20d24b99176c8 (libata: Un-break ATA
> blacklist)
> 

There are some more bugs too:


RCU stalls, fix has been in rcu/urgent for 7 days:
https://git.kernel.org/cgit/linux/kernel/git/paulmck/linux-rcu.git/commit/?h=rcu/urgent&id=789cbbeca4eb7141cbd748ee93772471101b507b


blk-mq bio merging (still no good fix available):
https://lkml.org/lkml/2014/10/9/729
(The fix sitting in the block tree:
https://git.kernel.org/cgit/linux/kernel/git/axboe/linux-block.git/commit/?h=for-3.18/core&id=764f612c6c3c231b9c12cfae7c328ccc9c453258
is wrong according to that message.)


Stalls when using nohz, requires series of six patches to fix that
didn't make 3.17 and weren't marked for -stable:

>From a80e49e2cc3145af014a8ae44f575829cc236192 Mon Sep 17 00:00:00 2001
From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: nohz: Move nohz full init call to tick init

>From c5c38ef3d70377dc504a6a3f611a3ec814bc757b Mon Sep 17 00:00:00 2001
From: Peter Zijlstra <peterz@infradead.org>
Subject: irq_work: Introduce arch_irq_work_has_interrupt()

>From 76a33061b9323b7fdb220ae5fa116c10833ec22e Mon Sep 17 00:00:00 2001
From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: irq_work: Force raised irq work to run on irq work interrupt

>From 3010279f0fc36f0388872203e63ca49912f648fd Mon Sep 17 00:00:00 2001
From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: x86: Tell irq work about self IPI support

>From 09f6edd424218eb69078551b2ecfada1f2d098eb Mon Sep 17 00:00:00 2001
From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: arm: Tell irq work about self IPI support

>From 3631073659d0aafeaa52227bb61a100efaf901dc Mon Sep 17 00:00:00 2001
From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: arm64: Tell irq work about self IPI support
