Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068AbaAWTp3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:45:29 -0500
Received: from mail-ve0-f175.google.com ([209.85.128.175]:49268 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172AbaAWTp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:45:27 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.1401231426470.7971@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401231259340.31739@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401231302340.31739@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401231303100.31739@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401231303460.31739@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1401231305390.31739@file01.intranet.prod.int.rdu2.redhat.com>
	<CA+55aFxPfHmpcMH-bmRcTPUQeq5=67cKVmra6+SvT26ybvQaug@mail.gmail.com>
	<alpine.LRH.2.02.1401231426470.7971@file01.intranet.prod.int.rdu2.redhat.com>
Date: Thu, 23 Jan 2014 11:45:26 -0800
X-Google-Sender-Auth: i5GAr9WjB2u67uvCrj8Sn2E-msg
Message-ID: <CA+55aFxrZE6oxu5CxFo3mRwGdVcq3jvnn_ChoSJDFgQz45Lq_A@mail.gmail.com>
Subject: Re: [PATCH 4/10] atyfb: set FBINFO_READS_FAST
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 11:31 AM, Mikulas Patocka <mpatocka@redhat.com> wrote:
>
> Both mach64 and matrox have a hardware bitter that is faster than
> rewriting the console - that's why FBINFO_READS_FAST improves performance
> for them.

My point is that I'd expect *anything* that has a hardware blitter to
be faster than rewriting the screen.

FBINFO_READS_FAST is documented to be about "soft-copy" being faster
than re-rendering. Which I take to be about actually doing copying in
*software*.

In particular, updatescrollmode() seems to do this right. It sets
p->scrollmode based on whether there's an accelerated copyarea. But
then SCROLL_PAN/WRAP_MOVE ends up re-testing FBINFO_READS_FAST,
ignoring any hw-accelerated copy-area, and I don't quite see why..

                Linus
