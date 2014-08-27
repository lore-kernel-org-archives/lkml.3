Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932774AbaH0JNV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 05:13:21 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:64950 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886AbaH0JNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 05:13:19 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC 2/2] lib: string: Make all calls to strnicmp into calls to strncasecmp
Organization: D03
References: <1409124962-11527-1-git-send-email-linux@rasmusvillemoes.dk>
	<1409124962-11527-3-git-send-email-linux@rasmusvillemoes.dk>
	<20140827090537.GL5100@mwanda>
X-Hashcash: 1:20:140827:hpa@linux.intel.com::0PqrITU3EsDltYtv:0000000000000000000000000000000000000000000DRV
X-Hashcash: 1:20:140827:ak@linux.intel.com::0pcnXkMGWbG95KVY:00000000000000000000000000000000000000000001MlA
X-Hashcash: 1:20:140827:linux-kernel@vger.kernel.org::Vr/N/U3kmzGi/aAy:0000000000000000000000000000000001LDp
X-Hashcash: 1:20:140827:grant.likely@linaro.org::auFDFW1W1AgPlm+I:000000000000000000000000000000000000001KYb
X-Hashcash: 1:20:140827:akpm@linux-foundation.org::FQ3hZQnLQdPuCmyq:0000000000000000000000000000000000001f1o
X-Hashcash: 1:20:140827:dan.carpenter@oracle.com::lMxCql3W+0rg7CWj:00000000000000000000000000000000000005X8k
Date: Wed, 27 Aug 2014 11:13:16 +0200
In-Reply-To: <20140827090537.GL5100@mwanda> (Dan Carpenter's message of "Wed,
	27 Aug 2014 12:05:37 +0300")
Message-ID: <87sikie1n7.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27 2014, Dan Carpenter <dan.carpenter@oracle.com> wrote:

> On Wed, Aug 27, 2014 at 09:36:02AM +0200, Rasmus Villemoes wrote:
>> The previous patch made strnicmp into a wrapper for strncasecmp. This
>> patch makes all in-tree users of strnicmp call strncasecmp directly,
>> while still making sure that the strnicmp symbol can be used by
>> out-of-tree modules. It should be considered a temporary hack until
>> all in-tree callers have been converted.
>> 
>> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
>
> Won't GCC just do the right thing without this second patch?
>

Not without LTO, I think. gcc can't really know how strnicmp is
implemented, so it has to emit a call to it.

Anyway, I was also planning on sending tree-wide patches doing
s/strnicmp/strncasecmp/, and then removing the hack from string.h, but I
first wanted to get feedback on the first patch and maybe some guidance
on how to properly deal with the module issue (e.g., does the kernel
need to export a strnicmp symbol forever?).

Rasmus
