Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab3BDKNA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 05:13:00 -0500
Received: from www.linutronix.de ([62.245.132.108]:42862 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023Ab3BDKM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 05:12:58 -0500
Date: Mon, 4 Feb 2013 11:12:56 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Izik Eidus <izik.eidus@ravellosystems.com>
cc: linux-kernel@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>,
        Leonid Shatz <leonid.shatz@ravellosystems.com>
Subject: Re: hrtimer possible issue
In-Reply-To: <510E58C2.9010207@ravellosystems.com>
Message-ID: <alpine.LFD.2.02.1302041110160.11905@ionos>
References: <510E58C2.9010207@ravellosystems.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Feb 2013, Izik Eidus wrote:

> Hi,
> 
> it seems like hrtimer_enqueue_reprogram contain a race which could result in
> timer.base switch during unlock/lock sequence.
> 
> See the code at __hrtimer_start_range_ns where it calls
> hrtimer_enqueue_reprogram. The later is releasing lock protecting the timer
> base for a short time and timer base switch can occur from a different CPU
> thread. Later when __hrtimer_start_range_ns calls unlock_hrtimer_base, a base
> switch could have happened and this causes the bug
> 
> Try to start the same hrtimer from two different threads in kernel running
> each one on a different CPU. Eventually one of the calls will cause timer base
> switch while another thread is not expecting it.
> 
> This can happen in virtualized environment where one thread can be delayed by
> lower hypervisor, and due to time delay a different CPU is taking care of
> missed timer start and runs the timer start logic on its own.

Nice analysis.
 
> This simple patch (just to give example of a fix) refactor this function to
> get rid of unneeded lock which immediately was followed by the unlock (with
> possible undesired base switch).
> 
> (Both the bug and the fixed were found/patched by Leonid Shatz)

The patch got mangled by your mail client and it is missing the proper
Signed-off-by annotation in the patch description. See
Documentation/SubmittingPatches.

Can you please resend ?

Thanks,

	tglx


