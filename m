Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230AbaJUKNK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 06:13:10 -0400
Received: from down.free-electrons.com ([37.187.137.238]:56596 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754553AbaJUKNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 06:13:08 -0400
Date: Tue, 21 Oct 2014 12:13:04 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexandre FOURNIER <alexandre.fournier@wisp-e.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Gregory =?UTF-8?B?Q2zDqW1lbnQ=?= 
	<gregory.clement@free-electrons.com>
Subject: Re: RCU stall in af_unix.c, should use spin_lock_irqsave?
Message-ID: <20141021121304.076d5acd@free-electrons.com>
In-Reply-To: <1413886132.32553.14.camel@localhost>
References: <20141021100313.397f4962@free-electrons.com>
	<1413886132.32553.14.camel@localhost>
Organization: Free Electrons
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Hannes Frederic Sowa,

On Tue, 21 Oct 2014 12:08:52 +0200, Hannes Frederic Sowa wrote:
> On Di, 2014-10-21 at 10:03 +0200, Thomas Petazzoni wrote:
> > So, the question is: is this patch the correct solution (but then other
> > usage of spin_lock in af_unix.c might also need fixing) ? Or is the
> > network driver at fault?
> 
> It feels like a false positive. Do you see one core spinning tightly on
> a lock? Does the system get unusable?

Interrupts are still enabled (for example, sysrq are still working),
but scheduling no longer takes place (all processes are blocked).

Best regards,

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
