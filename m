Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707AbaCUXK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 19:10:27 -0400
Received: from mail-yk0-f172.google.com ([209.85.160.172]:61269 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbaCUXKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 19:10:25 -0400
MIME-Version: 1.0
In-Reply-To: <CAG-99FPk6kX3QO9g3M20SC1fq8VhpVv6iDLsgjZDAUd5KvzCOQ@mail.gmail.com>
References: <1393223377-5744-1-git-send-email-tuukka.tikkanen@linaro.org>
	<1393223377-5744-7-git-send-email-tuukka.tikkanen@linaro.org>
	<CAJvTdKneVk_ToJ=Sv4GnMfn5a0r=ynfL4fRLOoKHsqMrDYr8JA@mail.gmail.com>
	<CAG-99FPk6kX3QO9g3M20SC1fq8VhpVv6iDLsgjZDAUd5KvzCOQ@mail.gmail.com>
Date: Fri, 21 Mar 2014 19:10:24 -0400
X-Google-Sender-Auth: cDiplW91O8SBWI3Pf9-XWwVwV7E
Message-ID: <CAJvTdKm3FfOgHbEkaDE+N2rwyL6FTnzXHF6Gn2iuxmhz3c9nnA@mail.gmail.com>
Subject: Re: [PATCH 6/7] Cpuidle: Deal with timer expiring in the past
From: Len Brown <lenb@kernel.org>
To: Tuukka Tikkanen <tuukka.tikkanen@linaro.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tuukka,
I've reproduced this negative on a 48 thread 2-socket Xeon during boot
(seen it only once, so far).

expected_us gets calculated to be -1, which is truthful, since the
next timer return value was about 500ns in the past
and our math truncates.  This, in turn, confuses the heck out of
menu's prediction of the next event to be
over 500 sec in the future.

I suspect more breakage is lurking, so I'll poke some more...

Len Brown, Intel Open Source Technology Center
