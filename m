Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbaKPSd0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 13:33:26 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:55412 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755466AbaKPSdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 13:33:25 -0500
MIME-Version: 1.0
In-Reply-To: <20141116100636.GA340@x4>
References: <20141114213124.GB3344@redhat.com>
	<CA+55aFx16ks_azU0eAcx+qZ5-o8Xo0zzP6aNjrskai8rqp+eMg@mail.gmail.com>
	<20141115213405.GA31971@redhat.com>
	<20141116014006.GA5016@redhat.com>
	<CA+55aFwLH6zGf7O=o2+H0Z8=8nW4zwUbw3Q4bJGttHACv9g+FQ@mail.gmail.com>
	<20141116100636.GA340@x4>
Date: Sun, 16 Nov 2014 10:33:24 -0800
X-Google-Sender-Auth: nLOnce8vd2ezBWsc75PSSybzIT0
Message-ID: <CA+55aFz+UQzPOwLL3doV3F6n5=7fP3YcaMiP-kF9C71Fkrw4-A@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16, 2014 at 2:06 AM, Markus Trippelsdorf
<markus@trippelsdorf.de> wrote:
>
> Before starting a bisection you could try and disable transparent_hugepages.
> There are strange bugs, that were introduced during this merge-window, in this
> area. See: https://lkml.org/lkml/2014/11/4/144
> https://lkml.org/lkml/2014/11/4/904
> http://thread.gmane.org/gmane.linux.kernel.mm/124451

Those look different, and hopefully should be fixed by commit
1d5bfe1ffb5b ("mm, compaction: prevent infinite loop in
compact_zone"). Which admittedly isn't in -rc4 (it went in on
Thursday), but I think Dave tends to run git-of-the-day rather than
last rc, so he probably already had it.

I *think* that if it was the infinite compaction problem, you'd have
the soft-lockup reports showing that. Dave's are in random places.
Which is odd.

               Linus
