Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167AbaEHWYu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 18:24:50 -0400
Received: from www.linutronix.de ([62.245.132.108]:59215 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756099AbaEHWY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 18:24:27 -0400
Date: Fri, 9 May 2014 00:24:33 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dave Hansen <dave.hansen@intel.com>
cc: x86@kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        LKML <linux-kernel@vger.kernel.org>, Gleb Natapov <gleb@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: KVM_GUEST support breaks page fault tracing
In-Reply-To: <536C039A.5000204@intel.com>
Message-ID: <alpine.DEB.2.02.1405090024050.6261@ionos.tec.linutronix.de>
References: <536C039A.5000204@intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2014, Dave Hansen wrote:

You forgot to cc Steven :)

> I noticed on some of my systems that page fault tracing doesn't work:
> 
> 	cd /sys/kernel/debug/tracing
> 	echo 1 > events/exceptions/enable
> 	cat trace;
> 	# nothing shows up
> 
> I eventually traced it down to CONFIG_KVM_GUEST.  At least in a KVM VM,
> enabling that option breaks page fault tracing, and disabling fixes it.
>  I tried on some old kernels and this does not appear to be a
> regression: it never worked.
> 
> Anybody have any theories about what is going on?
> 
> I'm also having problems with the page fault tracing on bare metal (same
> symptom of no trace output).  I'm unsure if it's related.
> 
