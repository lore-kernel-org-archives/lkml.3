Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab3HaILc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 04:11:32 -0400
Received: from mail-de.keymile.com ([195.8.104.250]:57723 "EHLO
	mail-de.keymile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457Ab3HaILa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 04:11:30 -0400
Message-ID: <5221A52C.9050105@keymile.com>
Date: Sat, 31 Aug 2013 10:11:24 +0200
From: Gerlando Falauto <gerlando.falauto@keymile.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130807 Thunderbird/17.0.8
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        "Brunck, Holger" <Holger.Brunck@keymile.com>,
        "Longchamp, Valentin" <Valentin.Longchamp@keymile.com>,
        "Bigler, Stefan" <Stefan.Bigler@keymile.com>
Subject: Re: kernel deadlock
References: <521F6D06.1040107@keymile.com> <E92455D61233364C88CCD4A6DAB2E2850E09518110@SRVDEHAN1MX1.keymile.net> <521FDD12.7050000@linaro.org> <52212511.9050206@keymile.com> <5221264F.4070402@linaro.org> <52213D76.3030304@codeaurora.org>
In-Reply-To: <52213D76.3030304@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,
 >
> Just curious. Do you have this patch from 3.11 applied to your 3.10
> kernel tree?

Nope, I didn't. But I applied it, and it doesn't seem to make a 
difference, unfortunately. :-(

Thanks for your help anyway!
Gerlando

>
> commit 971ee28cbd1ccd87b3164facd9359a534c1d2892
> Author: Peter Zijlstra <peterz@infradead.org>
> Date:   Fri Jun 28 11:18:53 2013 +0200
>
>      sched: Fix HRTICK
>
>      David reported that the HRTICK sched feature was borken; which was
> enough
>      motivation for me to finally fix it ;-)
>
>      We should not allow hrtimer code to do softirq wakeups while holding
> schedul
> er
>      locks. The hrtimer code only needs this when we accidentally try to
> program
> an
>      expired time. We don't much care about those anyway since we have
> the regula
> r
>      tick to fall back to.
>
>      Reported-by: David Ahern <dsahern@gmail.com>
>      Tested-by: David Ahern <dsahern@gmail.com>
>      Signed-off-by: Peter Zijlstra <peterz@infradead.org>
>      Link:
> http://lkml.kernel.org/r/20130628091853.GE29209@dyad.programming.kicks
> -ass.net
>      Signed-off-by: Ingo Molnar <mingo@kernel.org>
>

