Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbaATPAO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 10:00:14 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:64746 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbaATPAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 10:00:11 -0500
MIME-Version: 1.0
In-Reply-To: <CALZhoSRvhqJXU=z=h30SS6USjHFe3yKLsJN9WzQr6ch0sxoN-g@mail.gmail.com>
References: <CAKohpomO+2WbNLceBznWwYRcv0e7RsPiaRF7ctRZ+6GFKtr4aA@mail.gmail.com>
	<CALZhoSRvhqJXU=z=h30SS6USjHFe3yKLsJN9WzQr6ch0sxoN-g@mail.gmail.com>
Date: Mon, 20 Jan 2014 20:30:10 +0530
Message-ID: <CAKohpokbb3ko3sW4kuDKZSoY1qJ6apVVR3-jpv=7m5ZX__YP8Q@mail.gmail.com>
Subject: Re: [QUERY]: Is using CPU hotplug right for isolating CPUs?
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lei Wen <adrian.wenl@gmail.com>
Cc: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Kevin Hilman <khilman@linaro.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linaro Networking <linaro-networking@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 January 2014 19:29, Lei Wen <adrian.wenl@gmail.com> wrote:
> Hi Viresh,

Hi Lei,

> I have one question regarding unbounded workqueue migration in your case.
> You use hotplug to migrate the unbounded work to other cpus, but its cpu mask
> would still be 0xf, since cannot be changed by cpuset.
>
> My question is how you could prevent this unbounded work migrate back
> to your isolated cpu?
> Seems to me there is no such mechanism in kernel, am I understand wrong?

These workqueues are normally queued back from workqueue handler. And we
normally queue them on the local cpu, that's the default behavior of workqueue
subsystem. And so they land up on the same CPU again and again.
