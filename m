Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755AbaESWqm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 18:46:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50203 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbaESWqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 18:46:40 -0400
Date: Mon, 19 May 2014 15:46:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, 1vier1@web.de
Subject: Re: [PATCH 6/6] ipc/sem.c: make semctl(,,{GETNCNT,GETZCNT})
 standard compliant
Message-Id: <20140519154639.5570a30f8b47872a323dcdfd@linux-foundation.org>
In-Reply-To: <1400399917-17583-7-git-send-email-manfred@colorfullife.com>
References: <1400399917-17583-1-git-send-email-manfred@colorfullife.com>
	<1400399917-17583-2-git-send-email-manfred@colorfullife.com>
	<1400399917-17583-3-git-send-email-manfred@colorfullife.com>
	<1400399917-17583-4-git-send-email-manfred@colorfullife.com>
	<1400399917-17583-5-git-send-email-manfred@colorfullife.com>
	<1400399917-17583-6-git-send-email-manfred@colorfullife.com>
	<1400399917-17583-7-git-send-email-manfred@colorfullife.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 May 2014 09:58:37 +0200 Manfred Spraul <manfred@colorfullife.com> wrote:

> SUSv4 clearly defines how semncnt and semzcnt must be calculated:
> A task waits on exactly one semaphore:
> The semaphore from the first operation in the sop array that cannot proceed.
> 
> The Linux implementation never followed the standard, it tried to count all
> semaphores that might be the reason why a task sleeps.
> 
> This patch fixes that.

What are the back-compatibility implications of this change?
