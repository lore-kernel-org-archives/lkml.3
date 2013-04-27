Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135Ab3D0Xrh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 19:47:37 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:65057 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab3D0Xrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 19:47:35 -0400
MIME-Version: 1.0
In-Reply-To: <1367097352.1782.14.camel@buesod1.americas.hpqcorp.net>
References: <1363344869-15732-1-git-send-email-walken@google.com>
	<1367097352.1782.14.camel@buesod1.americas.hpqcorp.net>
Date: Sat, 27 Apr 2013 16:47:35 -0700
Message-ID: <CANN689FBCNx4NGJECTZUj90F6VZcg5R9HuwHdsUxwhvPMU7VFg@mail.gmail.com>
Subject: Re: [PATCH v2 00/13] rwsem fast-path write lock stealing
From: Michel Lespinasse <walken@google.com>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Alex Shi <alex.shi@intel.com>, Ingo Molnar <mingo@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Dave Chinner <david@fromorbit.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 27, 2013 at 2:15 PM, Davidlohr Bueso <davidlohr.bueso@hp.com> wrote:
> Hi Michel,
>
> On Fri, 2013-03-15 at 03:54 -0700, Michel Lespinasse wrote:
>> These patches extend Alex Shi's work (which added write lock stealing
>> on the rwsem slow path) in order to provide rwsem write lock stealing
>> on the fast path (that is, without taking the rwsem's wait_lock).
>>
>> I initially sent a shorter series shortly before v3.9, however some
>> patches were doing too much at once which made them confusing to
>> review. I have now split the series at a smaller granularity;
>> hope this will help :)
>
> Coincidentally, I was doing some similar work with similar results. But
> I have to say I like your series and cleanups better than mine :)
>
> I've run a few tests on this patchset and I'm pretty happy with the
> numbers. The first series of tests were on my quad-core laptop running
> pgbench on three different database sizes, each with various number of
> clients:

Thanks a lot for this testing. I was getting discouraged with this
series, as I would have hoped for it to be picked in -next a long long
time ago. Anyway, I will resend a v3 with the (mostly style) updates I
got from everyone on v2 and try submitting it to Linus.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
