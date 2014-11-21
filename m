Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbaKUUmb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 15:42:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57115 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145AbaKUUma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 15:42:30 -0500
Date: Fri, 21 Nov 2014 12:42:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, Manfred Spraul <manfred@colorfullife.com>,
        Davidlohr Bueso <davidlohr@hp.com>, Rafael Aquini <aquini@redhat.com>
Subject: Re: [PATCH] ipc,sem block sem_lock on sma->lock during sma
 initialization
Message-Id: <20141121124229.933a9b6ef9725a4032c95d45@linux-foundation.org>
In-Reply-To: <546FA0A7.2010507@redhat.com>
References: <20141121145226.2ac598af@annuminas.surriel.com>
	<20141121120930.3cd8d0f233f9670d689de672@linux-foundation.org>
	<546FA0A7.2010507@redhat.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2014 15:29:27 -0500 Rik van Riel <riel@redhat.com> wrote:

> On 11/21/2014 03:09 PM, Andrew Morton wrote:
> > On Fri, 21 Nov 2014 14:52:26 -0500 Rik van Riel <riel@redhat.com>
> > wrote:
> > 
> >> When manipulating just one semaphore with semop, sem_lock only
> >> takes that single semaphore's lock. This creates a problem during
> >> initialization of the semaphore array, when the data structures
> >> used by sem_lock have not been set up yet. The sma->lock is
> >> already held by newary, and we just have to make sure everything
> >> else waits on that lock during initialization.
> >> 
> >> Luckily it is easy to make sem_lock wait on the sma->lock, by
> >> pretending there is a complex operation in progress while the sma
> >> is being initialized.
> >> 
> >> The newary function already zeroes sma->complex_count before
> >> unlocking the sma->lock.
> > 
> > What are the runtime effects of the bug?
> > 
> 
> NULL pointer dereference in spin_lock from sem_lock,
> if it is called before sma->sem_base has been pointed
> somewhere valid.

Help us out here.  People need to use this description to work out
which kernel versions need the patch and whether to backport the fix
into their various kernels.  Other people will be starting at this
changelog wondering "will this fix the bug my customer has reported".

Is there some bug report people can look at?

What userspace actions trigger this bug?
