Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450AbaCaV7c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 17:59:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49894 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbaCaV7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 17:59:31 -0400
Date: Mon, 31 Mar 2014 14:59:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Mathias Krause <minipli@googlemail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        PaX Team <pageexec@freemail.hu>, Nadia Derbey <Nadia.Derbey@bull.net>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [PATCH] ipc: constify ipc_ops
Message-Id: <20140331145929.7fc32c21c884739892c46831@linux-foundation.org>
In-Reply-To: <1396275156.2507.4.camel@buesod1.americas.hpqcorp.net>
References: <1396186538-3378-1-git-send-email-minipli@googlemail.com>
	<1396216043.2579.11.camel@buesod1.americas.hpqcorp.net>
	<CA+rthh93hc5w_yKMLyJmEZFrW0NbHU3TEf_YL4cpE5OT3hvpLQ@mail.gmail.com>
	<1396275156.2507.4.camel@buesod1.americas.hpqcorp.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Mar 2014 07:12:36 -0700 Davidlohr Bueso <davidlohr@hp.com> wrote:

> > >> --- a/ipc/msg.c
> > >> +++ b/ipc/msg.c
> > >> @@ -306,15 +306,14 @@ static inline int msg_security(struct kern_ipc_perm *ipcp, int msgflg)
> > >>  SYSCALL_DEFINE2(msgget, key_t, key, int, msgflg)
> > >>  {
> > >>       struct ipc_namespace *ns;
> > >> -     struct ipc_ops msg_ops;
> > >> +     static const struct ipc_ops msg_ops = {
> > >> +             .getnew = newque,
> > >> +             .associate = msg_security,
> > >
> > > For completeness, please add .more_checks = NULL as well.
> > 
> > The C standard already ensures that .more_checks is initialized with
> > NULL. So I don't see any benefit from doing it explicitly.
> > We're not initializing global/static variables holding NULL pointers
> > in the majority of the code base either, so this is just "best
> > practice".
> 
> Hence the word _completeness_.

It's unusual to fill in the zeroed fields.  We could put it in
explicitly as commentary to tell the reader "this exists - we thought
about it and decided to leave it zero".  Which presumably is along the
lines of what you're thinking.  Or not ;)

I'm easy either way.  I'll shove the patch into my nice pile of
things-to-look-at-after-rc1.
