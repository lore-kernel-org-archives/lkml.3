Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbaHURNm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 13:13:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753072AbaHURNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 13:13:41 -0400
Date: Thu, 21 Aug 2014 19:11:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: David Howells <dhowells@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, richard@nod.at,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: kernel: signal: NULL ptr deref when killing process
Message-ID: <20140821171126.GA27140@redhat.com>
References: <53F48402.4080302@oracle.com> <20140820141252.GA27301@redhat.com> <53F60E58.2050708@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53F60E58.2050708@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21, Sasha Levin wrote:
>
> On 08/20/2014 10:12 AM, Oleg Nesterov wrote:
> > On 08/20, Sasha Levin wrote:
> >> >
> >> > Hi all,
> >> >
> >> > While fuzzing with trinity inside a KVM tools guest running the latest -next
> >> > kernel, I've stumbled on the following spew:
> > Thanks...
> >
> > looks like, kill_ok_by_cred()->__task_cred(t) returns NULL at first glance.
> > perhaps you can show the result of "make kernel/signal.s" to be sure? Or at
> > least the full "objdump -d kernel/signal.o".
>
> Attached.

Thanks.

Yes, t->real_cred == NULL (r14).

Interestingly, t->signal is NULL too (rcx). And ->signal must be never NULL.
So it looks like this task_struct was reallocated/reused. Or corrupted.

t == 0xffff880546803000 (r12), this doesn't look wrong.

Oleg.

