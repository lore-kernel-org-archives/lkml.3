Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768Ab3KRQg5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 11:36:57 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:36685 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab3KRQgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 11:36:48 -0500
MIME-Version: 1.0
In-Reply-To: <20131116190121.GB22666@redhat.com>
References: <20131101232521.GA23119@www.outflux.net>
	<20131114170337.GA11068@redhat.com>
	<CAGXu5jLXpLqjCAMFwKp7t7GpMq4+WBqNzSFC=up+CBvgGDuFCw@mail.gmail.com>
	<20131115203652.GA13476@redhat.com>
	<CAGXu5j+=LZYAczLVawGPAxd=9VX1FupWZq+2858GsrD1YprL3w@mail.gmail.com>
	<20131116190057.GA22666@redhat.com>
	<20131116190121.GB22666@redhat.com>
Date: Mon, 18 Nov 2013 08:36:48 -0800
X-Google-Sender-Auth: vsSGJzPe1ExM4rb4yT6cGQaLVnM
Message-ID: <CAGXu5jK1mqQzrHodkMNqQD5jMs164=nMB27KKpUyWePnjo5pSw@mail.gmail.com>
Subject: Re: [PATCH 1/3] set_dumpable: fix the theoretical race with itself
From: Kees Cook <keescook@chromium.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "security@kernel.org" <security@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vasily Kulikov <segoon@openwall.com>,
        Petr Matousek <pmatouse@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Alex Kelly <alex.page.kelly@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 16, 2013 at 11:01 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> set_dumpable() updates MMF_DUMPABLE_MASK in a non-trivial way to
> ensure that get_dumpable() can't observe the intermediate state,
> but this all can't help if multiple threads call set_dumpable()
> at the same time.
>
> And in theory commit_creds()->set_dumpable(SUID_DUMP_ROOT) racing
> with sys_prctl()->set_dumpable(SUID_DUMP_DISABLE) can result in
> SUID_DUMP_USER.
>
> Change this code to update both bits atomically via cmpxchg().
>
> Note: this assumes that it is safe to mix bitops and cmpxchg. IOW,
> if, say, an architecture implements cmpxchg() using the locking
> (like arch/parisc/lib/bitops.c does), then it should use the same
> locks for set_bit/etc.
>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

I can't speak to the bitops/cmpxchg, but the rest looks fine to me.

Acked-by: Kees Cook <keescook@chromium.org>

Thanks!

-Kees

-- 
Kees Cook
Chrome OS Security
