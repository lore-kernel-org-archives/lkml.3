Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab3EFH1t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 03:27:49 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:62724 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198Ab3EFH1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 03:27:48 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdUEmfOUT8xLZgH+i57uKA4TvYt_8DoDk4_3HbedFKY10A@mail.gmail.com>
References: <0000013e5b56d067-7982dfa6-08a2-4c48-ad77-6888b5114c5f-000000@email.amazonses.com>
	<201305010101.CGB86424.JFQOtSFOVOLFHM@I-love.SAKURA.ne.jp>
	<0000013e5bfc7c4d-54fa9464-dccd-4157-b4a5-22594261eaf3-000000@email.amazonses.com>
	<201305012114.AED78178.tFSHFQOOJLMOFV@I-love.SAKURA.ne.jp>
	<0000013e6705da99-094923c6-e239-43d2-8f0c-5e661656a27c-000000@email.amazonses.com>
	<201305031726.BJG78631.tQSOVOLHJFMFFO@I-love.SAKURA.ne.jp>
	<0000013e6b0fcf7b-9fabe4c8-2667-4bea-a9d1-f1c77e18fe78-000000@email.amazonses.com>
	<CAMuHMdUEmfOUT8xLZgH+i57uKA4TvYt_8DoDk4_3HbedFKY10A@mail.gmail.com>
Date: Mon, 6 May 2013 10:27:47 +0300
X-Google-Sender-Auth: ApypLJg0n3csJmeYTsC3x0Fp3ew
Message-ID: <CAOJsxLHUCh9emzt9-VgeQezJZ=b0A7QoTcCz1Y-ye2ZWfQAOJA@mail.gmail.com>
Subject: Re: [linux-next-20130422] Bug in SLAB?
From: Pekka Enberg <penberg@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Christoph Lameter <cl@linux.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Glauber Costa <glommer@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 6, 2013 at 9:59 AM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Fri, May 3, 2013 at 5:43 PM, Christoph Lameter <cl@linux.com> wrote:
>> Subject: slab: Return NULL for oversized allocations
>>
>> The inline path seems to have changed the SLAB behavior for very large
>> kmalloc allocations. This patch restores the old behavior but also
>> adds diagnostics so that we can figure where in the code these
>> large allocations occur.
>>
>> Signed-off-by: Christoph Lameter <cl@linux.com>
>>
>>
>> Index: linux/include/linux/slab_def.h
>> ===================================================================
>> --- linux.orig/include/linux/slab_def.h 2013-05-03 10:36:46.019564801 -0500
>> +++ linux/include/linux/slab_def.h      2013-05-03 10:37:28.860302188 -0500
>> @@ -126,6 +126,11 @@ static __always_inline void *kmalloc(siz
>>                 if (!size)
>>                         return ZERO_SIZE_PTR;
>>
>> +               if (size > KMALLOC_MAX_SIZE) {
>> +                       WARN_ON(1);
>
> As we were worried about this being triggered frm userspace, this needs
> some rate limiting, to avoid flooding the kernel logs.

I changed it to WARN_ON_ONCE():

https://git.kernel.org/cgit/linux/kernel/git/penberg/linux.git/commit/?h=slab/next
