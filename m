Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab3HLWQg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 18:16:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57346 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755862Ab3HLWQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 18:16:34 -0400
Date: Mon, 12 Aug 2013 15:16:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Daney <ddaney@caviumnetworks.com>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>, Christoph Lameter <cl@gentwo.org>,
        David Daney <ddaney.cavm@gmail.com>, <linux-kernel@vger.kernel.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH] smp.c: Quit unconditionally enabling irqs in
 on_each_cpu_mask().
Message-Id: <20130812151632.c787db7072bc4d93b43c1066@linux-foundation.org>
In-Reply-To: <52054208.4040201@caviumnetworks.com>
References: <1375986342-22999-1-git-send-email-ddaney.cavm@gmail.com>
	<000001405f6459b8-32fb5ffe-837b-41be-bec4-c9c05fd4f114-000000@email.amazonses.com>
	<5203FF48.7000903@caviumnetworks.com>
	<CAOtvUMcR2Hx2jMy6Y0QQv5h7dM2a5fAC_M7BpgnaLa0VUieEHg@mail.gmail.com>
	<52054208.4040201@caviumnetworks.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Aug 2013 12:24:56 -0700 David Daney <ddaney@caviumnetworks.com> wrote:

> > otherwise the bugs
> > stemming from incorrect use can be tricky to catch.
> >
> 
> ... all my patch does is allow on_each_cpu_mask() to be called with IRQs 
> disabled if we are in Early Boot.  This is already the case with 
> smp_call_function(), smp_call_function_many() and on_each_cpu().  I am 
> arguing that for the sake of consistency and the principle that function 
> behavior shouldn't be surprising, that we make on_each_cpu_mask() work 
> the same way.

Yup, the check in smp_call_function_many() will tell us if anyone calls
on_each_cpu_mask() with interrupts disabled any time after boot.

The whole early_boot_irqs_disabled thing is of course totally vile :(
