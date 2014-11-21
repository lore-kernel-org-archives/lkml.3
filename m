Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbaKUUJc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 15:09:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56867 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbaKUUJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 15:09:31 -0500
Date: Fri, 21 Nov 2014 12:09:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, Manfred Spraul <manfred@colorfullife.com>,
        Davidlohr Bueso <davidlohr@hp.com>, Rafael Aquini <aquini@redhat.com>
Subject: Re: [PATCH] ipc,sem block sem_lock on sma->lock during sma
 initialization
Message-Id: <20141121120930.3cd8d0f233f9670d689de672@linux-foundation.org>
In-Reply-To: <20141121145226.2ac598af@annuminas.surriel.com>
References: <20141121145226.2ac598af@annuminas.surriel.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2014 14:52:26 -0500 Rik van Riel <riel@redhat.com> wrote:

> When manipulating just one semaphore with semop, sem_lock only takes that
> single semaphore's lock. This creates a problem during initialization of
> the semaphore array, when the data structures used by sem_lock have not
> been set up yet. The sma->lock is already held by newary, and we just
> have to make sure everything else waits on that lock during initialization.
> 
> Luckily it is easy to make sem_lock wait on the sma->lock, by pretending
> there is a complex operation in progress while the sma is being initialized.
> 
> The newary function already zeroes sma->complex_count before unlocking
> the sma->lock.

What are the runtime effects of the bug?
