Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751323AbaKXUsq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 15:48:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55662 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbaKXUsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 15:48:45 -0500
Date: Mon, 24 Nov 2014 12:49:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <davidlohr@hp.com>, Rafael Aquini <aquini@redhat.com>,
        1vier1@web.de
Subject: Re: [PATCH] ipc,sem block sem_lock on sma->lock during sma
 initialization
Message-Id: <20141124124907.a8ba40e5.akpm@linux-foundation.org>
In-Reply-To: <54722639.1040605@colorfullife.com>
References: <20141121145226.2ac598af@annuminas.surriel.com>
	<54722639.1040605@colorfullife.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Nov 2014 19:23:53 +0100 Manfred Spraul <manfred@colorfullife.com> wrote:

> Subject: [PATCH] ipc/sem.c: Fully initialize sem_array before making it
>  visible
> 
> ipc_addid() makes a new ipc identifier visible to everyone.
> New objects start as locked, so that the caller can complete
> the initialization after the call.
> Within struct sem_array, at least sma->sem_base and sma->sem_nsems
> are accessed without any locks, therefore this approach doesn't work.
> 
> Thus: Move the ipc_addid() to the end of the initialization.

Any thoughts on which kernel version(s) need the patch?  I'm still
rather fuzzy on the end-user impact of this bug.

