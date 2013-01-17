Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405Ab3AQSRM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 13:17:12 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:55001 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab3AQSRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 13:17:11 -0500
MIME-Version: 1.0
In-Reply-To: <20130116171952.GQ2668@htj.dyndns.org>
References: <CALxABCaE3=XpGmgNJs1pre11aJ8T0pntVzf_mA6_OYNzis9nvQ@mail.gmail.com>
 <Pine.LNX.4.44L0.1301131153520.17578-100000@netrider.rowland.org>
 <CALxABCYtKJD4YrPxy6p+Frim8erccp3ine7SVEV9ReoaRh1BWQ@mail.gmail.com>
 <CACVXFVPMH-CHGw2EVwgYK5ozn1NAygT0f9=Df4vhSJmYYOZBMw@mail.gmail.com>
 <CACVXFVNvBeHG2TgfNY-wRQYtqsd6v-3AAiQVPAECuRnJ--ON-g@mail.gmail.com>
 <CA+55aFxV40V2WvNtJY3EC0F-B9wPk8CV2o1TTTyoF4CoWH7rhQ@mail.gmail.com>
 <CACVXFVNB3bOxF8aZ3Cg3vtOQZR=jNsDj=RbUQcKAhuc0c--Tyg@mail.gmail.com>
 <CACVXFVMFyhM+EsBytw0MKVW4Vp4aOtc_5sfX0v-643m7fwnc3Q@mail.gmail.com>
 <CA+55aFyOyTS1ZCm6UWqGLteoPuFXKu0WSYB-aTeRYvJUYPqe5A@mail.gmail.com>
 <20130115183204.GE2668@htj.dyndns.org> <20130116171952.GQ2668@htj.dyndns.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 17 Jan 2013 10:16:50 -0800
X-Google-Sender-Auth: UfZVvU3ngJYbqD3VRXTzUL2OwfE
Message-ID: <CA+55aFxfheczjP22pESE7zXS1hnK3=mOgcGjMHDeoQ2W4D0MDw@mail.gmail.com>
Subject: Re: [PATCH] async: fix __lowest_in_progress()
To: Tejun Heo <tj@kernel.org>
Cc: Ming Lei <ming.lei@canonical.com>, Alex Riesen <raa.lkml@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun, mind explaining this one a bit more to me?

If ordering matters, and we have a running queue and a pending queue,
how could the pending queue *ever* be lower than the running one?

That implies that something was taken off the pending queue and put on
the running queue out of order, right?

And that in turn implies that there isn't much of a "lowest" ordering
at all, so how could anybody even care about what lowest is? It seems
to be a meaningless measure.

So with that in mind, I don't see what semantics the first part of the
patch fixes. Can you explain more?

               Linus
