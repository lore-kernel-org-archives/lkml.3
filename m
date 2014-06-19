Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965660AbaFSV0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:26:54 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:40432 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964845AbaFSV0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:26:53 -0400
MIME-Version: 1.0
In-Reply-To: <20140619140651.c3c49cf70a7f349db595239e@linux-foundation.org>
References: <1403193138-7677-1-git-send-email-a.ryabinin@samsung.com>
	<alpine.DEB.2.11.1406191555110.4002@gentwo.org>
	<20140619140651.c3c49cf70a7f349db595239e@linux-foundation.org>
Date: Fri, 20 Jun 2014 01:26:52 +0400
Message-ID: <CAPAsAGyYW13VnSKMDZRWXMA3BRefP+wsnqGVbHHJ2Qfk9kFy9A@mail.gmail.com>
Subject: Re: [PATCH] mm: slub: SLUB_DEBUG=n: use the same alloc/free hooks as
 for SLUB_DEBUG=y
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>,
        Andrey Ryabinin <a.ryabinin@samsung.com>,
        Pekka Enberg <penberg@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Konstantin Khlebnikov <koct9i@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-06-20 1:06 GMT+04:00 Andrew Morton <akpm@linux-foundation.org>:
> On Thu, 19 Jun 2014 15:56:56 -0500 (CDT) Christoph Lameter <cl@gentwo.org> wrote:
>
>> On Thu, 19 Jun 2014, Andrey Ryabinin wrote:
>>
>> > I see no reason why calls to other debugging subsystems (LOCKDEP,
>> > DEBUG_ATOMIC_SLEEP, KMEMCHECK and FAILSLAB) are hidden under SLUB_DEBUG.
>> > All this features should work regardless of SLUB_DEBUG config, as all of
>> > them already have own Kconfig options.
>>
>> The reason for hiding this under SLUB_DEBUG was to have some way to
>> guarantee that no instrumentations is added if one does not want it.
>>
>> SLUB_DEBUG is on by default and builds in a general
>> debugging framework that can be enabled at runtime in
>> production kernels.
>>
>> If someone disabled SLUB_DEBUG then that has been done with the intend to
>> get a minimal configuration.
>>
>
> (Is that a nack?)
>
> The intent seems to have been implemented strangely.  Perhaps it would
> be clearer and more conventional to express all this using Kconfig
> logic.
>

Seems I forgot to mention in commit message that the main intent of
this patch is not to fix some weird configurations, which nobody uses,
but a simple cleanup. Just look at diffstat (36 insertions vs 61
deletions). And someone who is going to add more debug hooks in future
will have to do it only in one place.

> Anyway, if we plan to leave the code as-is then can we please get a
> comment in there so the next person is not similarly confused?
>



-- 
Best regards,
Andrey Ryabinin
