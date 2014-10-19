Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177AbaJSXtS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 19:49:18 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:56605 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbaJSXtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 19:49:17 -0400
MIME-Version: 1.0
In-Reply-To: <20141019231031.GB9319@node.dhcp.inet.fi>
References: <1413734862-13510-1-git-send-email-sasha.levin@oracle.com>
	<CA+55aFyDECoy4s6oO=PFZSyNS_F9EagxFiNm1X95Fu0cdSTeXQ@mail.gmail.com>
	<20141019210348.GA28144@drone.musicnaut.iki.fi>
	<CA+55aFzOYL-2WT2bf5C5ODAJnd=qVgpZGb-6o7z56Vu14wavJg@mail.gmail.com>
	<20141019231031.GB9319@node.dhcp.inet.fi>
Date: Sun, 19 Oct 2014 16:49:16 -0700
X-Google-Sender-Auth: iAG1USgrzNSNd0rDBCSy_aE5UPk
Message-ID: <CA+55aFxf6_cA5hTtDGqPU4=DkKz_6OUizhiqge+Xf5u34RxeXw@mail.gmail.com>
Subject: Re: [PATCH] kernel: use the gnu89 standard explicitly
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, Andrew Pinski <pinskia@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 19, 2014 at 4:10 PM, Kirill A. Shutemov
<kirill@shutemov.name> wrote:
>
> IIUC, it's nothing to do with volatile. C11 and above reads
>
>         (rwlock_t) { .raw_lock = { 0 }, }
>
> as compound literal (which is not constant) rather than constant
> initalizer plus a cast.

Ahh. I thought it was the volatile, just because of the "constant"
part and the fact that it looked like the test-case was minimal. But
apparently that was just a red herring.

So it's just the fact that C11 hasn't got the useful GNU extension of
a cast-with-initializer, and then that extension got removed (probably
just an oversight) because people thought that the "standard" C11
initializers were good enough.

And it sounds like this will get fixed (perhaps already is) in gcc anyway.

So maybe we need to do that "--std=gnu89" as a temporary workaround,
but not as long long-term "newer versions are broken".

That doesn't sound too bad. My main objection to the patch was a
"let's try to fix this properly instead", but if the breakage is just
a temporary problem, there's no issue with "properly". Although it
does look like the *placement* of the --std=gnu89 was incorrect in
that original patch, so it needs updating regardless.

AndrewP, mind explaing the other difference you mentioned (ie wrt
"extern inline")? I thought we had already long since ended up
following the gcc semantics (ie use "static inline" if we don't have
an external version somehwre), what exactly changed?

Thanks,

                       Linus
