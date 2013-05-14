Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab3ENBTH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 21:19:07 -0400
Received: from mail-da0-f51.google.com ([209.85.210.51]:61825 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067Ab3ENBTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 21:19:05 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org
Cc: akpm@linux-foundation.org
Subject: AIO refactoring/performance improvements/cancellation
Date: Mon, 13 May 2013 18:18:37 -0700
Message-Id: <1368494338-7069-1-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a respin of the AIO patches that were deferred until 3.11, along
with some other stuff I had queued up.

Changes:

 * Took the dynamic allocation stuff out of the percpu refcounting
   patch, which Tejun was wanting. I split the dynamic bits out into
   another patch, which I may resend later.

 * Changed batch completion to use a singly linked list instead of an rb
   tree; it now calls batch_complete_aio() early if it has to look too
   far down the list.

 * Some batch completion performance improvements, to avoid doing nested
   irqsave/restore (which was the source of a performance regression)
   and not free the kiocbs with irqs disabled.

 * There's also some more assorted refactoring/minor performance
   improvements that had been sitting in my tree for awhile but weren't in
   the patch series that was queued up for 3.10

 * And, the last few patches add cancellation for direct IO; these
   patches are still preliminary but they do work and are useful for
   some simple use cases.
