Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260Ab3JNSgT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 14:36:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60426 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757036Ab3JNSgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 14:36:16 -0400
Date: Mon, 14 Oct 2013 20:29:03 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Anton Arapov <aarapov@redhat.com>, David Smith <dsmith@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Martin Cermak <mcermak@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] uprobes: fix fork() with the pending ret-probe(s)
Message-ID: <20131014182903.GA14115@redhat.com>
References: <20131013191815.GA32466@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131013191815.GA32466@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13, Oleg Nesterov wrote:
>
> Please review, this series fixes the serious bug reported by
> Martin and David and cc's stable. See the changelog in 5/5.

Forgot to mention...

This probably needs another patch to handle the special case, vfork().
In this case it would be more correct to dup return_instances but
(obviously) avoid dup_xol_area.

However I think this is not that important, the child should not "unwind"
the stack if it shares mm/stack with its parent, otherwise it can corrupt
the parent's stack.

So I think that this change (which needs to pass "clone_flags" to
uprobe_copy_process) is not the stable material. But I'll update the
changelog in 4/5 to explain that "mm == t->mm" check should be updated.

Oleg.

