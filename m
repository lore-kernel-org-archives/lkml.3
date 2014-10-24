Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182AbaJXKg1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 06:36:27 -0400
Received: from mail-yh0-f53.google.com ([209.85.213.53]:36860 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756066AbaJXKg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 06:36:26 -0400
MIME-Version: 1.0
In-Reply-To: <1414139506040-968477.post@n7.nabble.com>
References: <1413802499-17928-1-git-send-email-a.ryabinin@samsung.com>
	<1413802499-17928-2-git-send-email-a.ryabinin@samsung.com>
	<5445640F.10000@oracle.com>
	<5446135E.9020101@samsung.com>
	<1414139506040-968477.post@n7.nabble.com>
Date: Fri, 24 Oct 2014 14:36:25 +0400
Message-ID: <CAPAsAGxuJJYwS2fQ5r63U=xY_MSSb=5vc_tUBvTjkq=JoXhd8A@mail.gmail.com>
Subject: Re: [RFC PATCH] UBSan: run-time undefined behavior sanity checker
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
To: "y.gribov" <y.gribov@samsung.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Sasha Levin <sasha.levin@oracle.com>,
        Michal Marek <mmarek@suse.cz>, linux@rasmusvillemoes.dk,
        x86@kernel.org, linux-kbuild@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-10-24 12:31 GMT+04:00 y.gribov <y.gribov@samsung.com>:
>> Unaligned accesses disabled because they are allowed on some arches (see
> HAVE_EFFICIENT_UNALIGNED_ACCESS).
>> Another reason is that there are to many reports. Not because there are
>> lot of bugs, but because
>> there are many reports for one bug.
>
> A side note - unaligned accesses would prevent KASan from doing it's job
> well because instrumentation code relies on address alignment when
> performing the check.
>

I guess it only matters for inline instrumentation, right?
Because in outline case I've taken care about unaligned accesses.

We could do following trick in Kconfig:
      select HAVE_EFFICIENT_UNALIGNED_ACCESS if !KASAN

This will prevent a lot of unaligned accesses, but surely not all of them



-- 
Best regards,
Andrey Ryabinin
