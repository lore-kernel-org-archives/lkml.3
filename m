Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515AbaELJUC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 05:20:02 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:47768 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbaELJUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 05:20:00 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20140512084727.GN30445@twins.programming.kicks-ass.net>
References: <536F8F0E.7020301@gmail.com> <53707007.3080003@gmail.com> <20140512084727.GN30445@twins.programming.kicks-ass.net>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Mon, 12 May 2014 11:19:39 +0200
Message-ID: <CAKgNAkiGt6xV0JaddmC8pLeTe+fSEu79DNvzg8XbA-MPo_zXyg@mail.gmail.com>
Subject: Re: [BUG] sched_setattr() SCHED_DEADLINE hangs system
To: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@gmail.com>, Dario Faggioli <raistlin@linux.it>,
        Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Mon, May 12, 2014 at 10:47 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, May 12, 2014 at 08:53:59AM +0200, Michael Kerrisk (man-pages) wrote:
>> On 05/11/2014 04:54 PM, Michael Kerrisk (man-pages) wrote:
>
>> > $ time sudo ./t_sched_setattr d 18446744072 18446744072 18446744073
>>
>> I realize my speculation was completely off the mark. time(2) really
>> is reporting the truth, and the sched_setattr() call returns immediately.
>> But it looks like with these settings the deadline scheduler gets itself
>> into a confused state. The process chews up a vast amount of CPU time
>> for the few actions (including process teardown) that occur after
>> the sched_setattr() call, and since the SCHED_DEADLINE process has
>> priority over everything else, the system locks up.
>
> Yeah, its doing something weird alright.. let me see if I can get
> something useful out.

Thanks!

> Btw, you do know about EX_USAGE from sysexits.h ?

Yes, I'm peripherally aware of them, but have tended to avoid them
because they're not in POSIX, and don't seem to be all that widely
used.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
