Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805AbaLHPqh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 10:46:37 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:57692 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaLHPqg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 10:46:36 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Leitner <dev@g0hl1n.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] misc: ioc4: simplify wave period measurement in clock_calibrate
Date: Mon, 08 Dec 2014 16:46:31 +0100
Message-ID: <3564575.fggPKDmMEE@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141208162810.7b009382@frodo>
References: <20141208132720.16356743@frodo> <CA+V-a8tww3bt7rhMT8Bxn0dwyg4qQTeVKbAKKJxh__zXrKrewA@mail.gmail.com> <20141208162810.7b009382@frodo>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
X-Provags-ID: V03:K0:qOSFgD79+6r60huuRlGvxP4bFWrX/OlCWHQ4ocRSDsiVOutbPh2
 blGAOQp0t3H4u3ffstsf+3KQwzK/7BxB7othTQMb9f2ipp7RnXgq3kvDXN+uC90t2xEuOXD
 ElY1Mtw0n87ITLHVdoOcMNT+52VTu5DMb+gnR0L8kufO16YnTIA97E+oFgUCETD9opHbxYp
 Fei2IfQCZfL/thUz1wHFA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 December 2014 16:28:10 Richard Leitner wrote:
> The loop for measuring the square wave periods over some cycles is
> refactored to be more easily readable. This includes avoiding a
> "by-hand-implemented" for loop with a "real" one and adding some
> comments.
> 
> Furthermore the following compiler warning is avoided by this patch:
> drivers/misc/ioc4.c: In function ‘ioc4_probe’:
> drivers/misc/ioc4.c:194:16: warning: ‘start’ may be used uninitialized
> in this function [-Wmaybe-uninitialized]
>   period = (end - start) /
>                 ^
> drivers/misc/ioc4.c:148:11: note: ‘start’ was declared here
>   uint64_t start, end, period;
>            ^
> 
> Signed-off-by: Richard Leitner <dev@g0hl1n.net>

Acked-by: Arnd Bergmann <arnd@arndb.de>

> ---
> A simplification of this loop was suggested by Andrew Morton [1].
> This is my first proposal of such a simplification.
> 
> Furthermore I'm not sure if the commit message is sufficient.
> Please give me also some feedback on it.
> 
> If this simplification is not needed only initializing start to
> ktime_get_ns() would fix the compiler warning too.

With the changed loop, do you still get a warning if you
remove the extra 'start = ktime_get_ns()' at the start of the loop?

	Arnd
