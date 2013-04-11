Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935858Ab3DKPGo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 11:06:44 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:54905 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379Ab3DKPGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 11:06:43 -0400
Date: Thu, 11 Apr 2013 17:06:39 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        hpa@zytor.com, rostedt@goodmis.org, akpm@linux-foundation.org,
        tglx@linutronix.de, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 4/4] cputime: remove scaling
Message-ID: <20130411150637.GB15699@somewhere>
References: <1364489605-5443-1-git-send-email-sgruszka@redhat.com>
 <1364489605-5443-5-git-send-email-sgruszka@redhat.com>
 <20130410120228.GC8083@gmail.com>
 <20130411083634.GB1380@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130411083634.GB1380@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 10:36:35AM +0200, Stanislaw Gruszka wrote:
> > I really prefer robust kernel side accounting/instrumentation.
> 
> We have CONFIG_IRQ_TIME_ACCOUNTING and CONFIG_VIRT_CPU_ACCOUNTING_GEN.
> Perhaps we can change to use one of those options by default. I wonder
> if the additional performance cost related with them is really something
> that we should care about. Are there any measurement that show those
> will make performance worse ?

CONFIG_IRQ_TIME_ACCOUNTING also make use of scaling. And CONFIG_VIRT_CPU_ACCOUNTING_GEN
involves too much overhead on IO-bound workloads. It's mostly good for
undisturbed userspace bound workloads (few IRQs, few exceptions, few syscalls).
