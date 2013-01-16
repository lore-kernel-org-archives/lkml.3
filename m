Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227Ab3APEPJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 23:15:09 -0500
Received: from mail-vb0-f45.google.com ([209.85.212.45]:48119 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757828Ab3APEPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 23:15:07 -0500
MIME-Version: 1.0
In-Reply-To: <CACVXFVMi2nrPT8F08xb5ZG0wzq326oqW7xOqo+_8AOvPSWMvoA@mail.gmail.com>
References: <CALxABCaE3=XpGmgNJs1pre11aJ8T0pntVzf_mA6_OYNzis9nvQ@mail.gmail.com>
 <Pine.LNX.4.44L0.1301131153520.17578-100000@netrider.rowland.org>
 <CALxABCYtKJD4YrPxy6p+Frim8erccp3ine7SVEV9ReoaRh1BWQ@mail.gmail.com>
 <CACVXFVPMH-CHGw2EVwgYK5ozn1NAygT0f9=Df4vhSJmYYOZBMw@mail.gmail.com>
 <CACVXFVNvBeHG2TgfNY-wRQYtqsd6v-3AAiQVPAECuRnJ--ON-g@mail.gmail.com>
 <CA+55aFxV40V2WvNtJY3EC0F-B9wPk8CV2o1TTTyoF4CoWH7rhQ@mail.gmail.com>
 <CACVXFVNB3bOxF8aZ3Cg3vtOQZR=jNsDj=RbUQcKAhuc0c--Tyg@mail.gmail.com>
 <CACVXFVMFyhM+EsBytw0MKVW4Vp4aOtc_5sfX0v-643m7fwnc3Q@mail.gmail.com>
 <CA+55aFyOyTS1ZCm6UWqGLteoPuFXKu0WSYB-aTeRYvJUYPqe5A@mail.gmail.com> <CACVXFVMi2nrPT8F08xb5ZG0wzq326oqW7xOqo+_8AOvPSWMvoA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 15 Jan 2013 20:14:46 -0800
X-Google-Sender-Auth: 6sAcfUwCchno-limnwX1lZLM78M
Message-ID: <CA+55aFwyqpgLN6MUva0crrwvZhD8zccuSbtqJ57Xbngdx47Ykw@mail.gmail.com>
Subject: Re: USB device cannot be reconnected and khubd "blocked for more than
 120 seconds"
To: Ming Lei <ming.lei@canonical.com>
Cc: Tejun Heo <tj@kernel.org>, Alex Riesen <raa.lkml@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 7:05 PM, Ming Lei <ming.lei@canonical.com> wrote:
>
> So looks only sd.c and floppy.c are to be synchronized suppose
> some sync interfaces are introduced, doesn't it?

What about ata_host_register() (usually called through ata_host_activate())?

I don't understand why you continue to push for something fragile
where you have to get things right in the driver, when it clearly is
very fragile indeed, as now shown *twice* by how you seem to have
missed some potential case.

This is *exactly* why I NAK'ed the patch, and said it has to be
handled automatically (or at least default to the safe model, not the
unsafe one).

We do have the automatic patch now. Admittedly it's not wonderful, and
I agreed when Tejun called it slightly ugly, but at least it does
these things automatically without humans having to go through these
cases one by one and having to get them right. So please just stop
pushing this "manual marking" thing. It's fundamentally flawed and
broken.

             Linus
