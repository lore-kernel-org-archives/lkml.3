Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934226Ab3FSDor (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 23:44:47 -0400
Received: from ozlabs.org ([203.10.76.45]:39137 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933861Ab3FSDop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 23:44:45 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <tj@kernel.org>, Kent Overstreet <koverstreet@google.com>,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH percpu/for-3.11 1/2] percpu-refcount: add __must_check to percpu_ref_init() and don't use ACCESS_ONCE() in percpu_ref_kill_rcu()
In-Reply-To: <20130613035201.GD9451@mtj.dyndns.org>
References: <20130613035201.GD9451@mtj.dyndns.org>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 19 Jun 2013 12:25:14 +0930
Message-ID: <87y5a6n71o.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:
> Two small changes.
>
> * Unlike most init functions, percpu_ref_init() allocates memory and
>   may fail.  Let's mark it with __must_check in case the caller
>   forgets.

But it's quite OK to ignore OOM errors in builtin init functions.

It would be neatest to have it fail into slow mode, of course, but it's
probably not worth the pain.

Cheers,
Rusty.
