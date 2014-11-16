Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbaKPGdW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 01:33:22 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:61800 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbaKPGdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 01:33:20 -0500
MIME-Version: 1.0
In-Reply-To: <20141116014006.GA5016@redhat.com>
References: <20141114213124.GB3344@redhat.com>
	<CA+55aFx16ks_azU0eAcx+qZ5-o8Xo0zzP6aNjrskai8rqp+eMg@mail.gmail.com>
	<20141115213405.GA31971@redhat.com>
	<20141116014006.GA5016@redhat.com>
Date: Sat, 15 Nov 2014 22:33:19 -0800
X-Google-Sender-Auth: gtaMDXWOeU5MQTaOmLZaBsF1CnQ
Message-ID: <CA+55aFwLH6zGf7O=o2+H0Z8=8nW4zwUbw3Q4bJGttHACv9g+FQ@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 15, 2014 at 5:40 PM, Dave Jones <davej@redhat.com> wrote:
>  >
>  > I'll try that next, and check in on it tomorrow.
>
> No luck. Died even faster this time.

Yeah, and your other lockups haven't even been TLB related. Not that
they look like anything else *either*.

I have no ideas left. I'd go for a bisection - rather than try random
things, at least bisection will get us a smaller set of suspects if
you can go through a few cycles of it. Even if you decide that you
want to run for most of a day before you are convinced it's all good,
a couple of days should get you a handful of bisection points (that's
assuming you hit a couple of bad ones too that turn bad in a shorter
while). And 4 or five bisections should get us from 11k commits down
to the ~600 commit range. That would be a huge improvement.

                   Linus
