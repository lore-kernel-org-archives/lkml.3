Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932402AbaLAUVL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 15:21:11 -0500
Received: from www.linutronix.de ([62.245.132.108]:44984 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932112AbaLAUVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 15:21:10 -0500
Date: Mon, 1 Dec 2014 21:21:01 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christian Borntraeger <borntraeger@de.ibm.com>
cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Oleg Nesterov <oleg@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [RFC PATCH 07/30] cputime: Convert kcpustat to nsecs
In-Reply-To: <547CCC10.8040706@de.ibm.com>
Message-ID: <alpine.DEB.2.11.1412012120110.3961@nanos>
References: <1417199040-21044-1-git-send-email-fweisbec@gmail.com> <1417199040-21044-8-git-send-email-fweisbec@gmail.com> <20141201151402.31a6cc9a@mschwide> <20141201161031.GA27302@lerouge> <20141201174842.648dfe06@mschwide> <alpine.DEB.2.11.1412011801250.3961@nanos>
 <547CCC10.8040706@de.ibm.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Dec 2014, Christian Borntraeger wrote:
> Am 01.12.2014 um 18:15 schrieb Thomas Gleixner:
> > Why make this s390 specific?
> > 
> > We can decouple the accounting from the time accumulation for all
> > architectures.
> > 
> > struct cputime_record {
> >        u64 user, sys, softirq, hardirq, steal;
> > };
> 
>  Wont we need guest, nice, guest_nice as well?

Yes. I just took the list from Frederics example w/o staring into
the code.
 
Thanks,

	tglx
