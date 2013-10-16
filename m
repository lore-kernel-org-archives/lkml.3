Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935513Ab3JPSUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:20:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48651 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761285Ab3JPRpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:45:44 -0400
Date: Wed, 16 Oct 2013 19:38:28 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Anton Arapov <aarapov@redhat.com>, David Smith <dsmith@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Martin Cermak <mcermak@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] uprobes: fix fork() with the pending ret-probe(s)
Message-ID: <20131016173828.GA31347@redhat.com>
References: <20131013191815.GA32466@redhat.com> <20131014182903.GA14115@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131014182903.GA14115@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14, Oleg Nesterov wrote:
>
> On 10/13, Oleg Nesterov wrote:
> >
> > Please review, this series fixes the serious bug reported by
> > Martin and David and cc's stable. See the changelog in 5/5.

OK, nobody seems to object, I am going to ask Ingo to pull this fix.

But,

> This probably needs another patch to handle the special case, vfork().
> In this case it would be more correct to dup return_instances but
> (obviously) avoid dup_xol_area.
>
> However I think this is not that important, the child should not "unwind"
> the stack if it shares mm/stack with its parent, otherwise it can corrupt
> the parent's stack.

Yes, but I forgot that at least the child should return from vfork()
itself and it can be ret-probed.

So I am sending the additional 6/5 in reply to 0/5. This change can
be joined with 1/5, but I'd prefer to do this in a separate patch for
better documentation.

Oleg.

