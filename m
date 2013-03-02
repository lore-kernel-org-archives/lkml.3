Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261Ab3CBBO6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 20:14:58 -0500
Received: from mail-vc0-f178.google.com ([209.85.220.178]:60728 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab3CBBO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 20:14:57 -0500
MIME-Version: 1.0
In-Reply-To: <1362183400.3420.24.camel@buesod1.americas.hpqcorp.net>
References: <1362183400.3420.24.camel@buesod1.americas.hpqcorp.net>
Date: Fri, 1 Mar 2013 17:14:56 -0800
X-Google-Sender-Auth: GUO_9FalAqxQGPJjV-A3D_arTsE
Message-ID: <CA+55aFxHg9aCBydM=QGygmuVHnHDZXov=Z2PKOpO3c9XJTTRdw@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] ipc: introduce obtaining a lockless ipc object
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Rik van Riel <riel@redhat.com>, "Vinod, Chegu" <chegu_vinod@hp.com>,
        "Low, Jason" <jason.low2@hp.com>, linux-tip-commits@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, aquini@redhat.com,
        Michel Lespinasse <walken@google.com>, Ingo Molnar <mingo@kernel.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 1, 2013 at 4:16 PM, Davidlohr Bueso <davidlohr.bueso@hp.com> wrote:
>
> +struct kern_ipc_perm *ipc_obtain_object(struct ipc_ids *ids, int id)

This looks good..

> +struct kern_ipc_perm *ipc_obtain_object_check(struct ipc_ids *ids, int id)

The comment on ipc_checkid() says that it should only be called with
the lock held.

Which seems entirely bogus, and I think it's just stale. It's just
checking the same ipc->seq that is only set at allocation, so it won't
change, afaik.

So I *think* the above is ok, but I'd want people to look at that
comment and remove it if it is stale. And if it's not stale, think
about this.

               Linus
