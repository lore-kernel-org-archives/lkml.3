Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab3AOUSY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 15:18:24 -0500
Received: from mail-vb0-f50.google.com ([209.85.212.50]:53578 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754929Ab3AOUSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 15:18:23 -0500
MIME-Version: 1.0
In-Reply-To: <20130115183204.GE2668@htj.dyndns.org>
References: <CALxABCaE3=XpGmgNJs1pre11aJ8T0pntVzf_mA6_OYNzis9nvQ@mail.gmail.com>
 <Pine.LNX.4.44L0.1301131153520.17578-100000@netrider.rowland.org>
 <CALxABCYtKJD4YrPxy6p+Frim8erccp3ine7SVEV9ReoaRh1BWQ@mail.gmail.com>
 <CACVXFVPMH-CHGw2EVwgYK5ozn1NAygT0f9=Df4vhSJmYYOZBMw@mail.gmail.com>
 <CACVXFVNvBeHG2TgfNY-wRQYtqsd6v-3AAiQVPAECuRnJ--ON-g@mail.gmail.com>
 <CA+55aFxV40V2WvNtJY3EC0F-B9wPk8CV2o1TTTyoF4CoWH7rhQ@mail.gmail.com>
 <CACVXFVNB3bOxF8aZ3Cg3vtOQZR=jNsDj=RbUQcKAhuc0c--Tyg@mail.gmail.com>
 <CACVXFVMFyhM+EsBytw0MKVW4Vp4aOtc_5sfX0v-643m7fwnc3Q@mail.gmail.com>
 <CA+55aFyOyTS1ZCm6UWqGLteoPuFXKu0WSYB-aTeRYvJUYPqe5A@mail.gmail.com> <20130115183204.GE2668@htj.dyndns.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 15 Jan 2013 12:18:01 -0800
X-Google-Sender-Auth: XDNVoGJlPNhS913i8XrTqfSndi4
Message-ID: <CA+55aFzZ1NJz34r99N7+mU4CN5Ju4QpHrDoWv5Kbd5-Z4QzgaA@mail.gmail.com>
Subject: Re: USB device cannot be reconnected and khubd "blocked for more than
 120 seconds"
To: Tejun Heo <tj@kernel.org>
Cc: Ming Lei <ming.lei@canonical.com>, Alex Riesen <raa.lkml@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 10:32 AM, Tejun Heo <tj@kernel.org> wrote:
>
> I think the root problem here, apart from request_module() from block
> - which is a bit nasty but making that part completely async would too
> be quite nasty albeit in a different way - is that
> async_synchronize_full() is way too indescriminate.  It's something
> only suitable for things like the end of system init.
>
> I'm wondering whether what we need is a rudimentray nesting like the
> following.

I think that is a good solution if it works, but look out: we need to
synchronize across *all* domains, not just the default one.  The sd.c
code, for example, uses its own "scsi_sd_probe_domain" for example,
and we *do* want to synchronize with it.

Can you do that with your suggested interface (ie it would have to be
a *global* sequence number).

               Linus
