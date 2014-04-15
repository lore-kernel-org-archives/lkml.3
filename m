Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751285AbaDOE2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 00:28:19 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:40747 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbaDOE2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 00:28:17 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1404150116130.22697@ionos.tec.linutronix.de>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
	<alpine.DEB.2.02.1404150116130.22697@ionos.tec.linutronix.de>
Date: Tue, 15 Apr 2014 09:58:17 +0530
Message-ID: <CAKohpond16U2QbyJkKqjxemGKbJLn=-fYjgaMiFiQUUfz75+dQ@mail.gmail.com>
Subject: Re: [PATCH 00/38] tick cleanups and bugfixes
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Arvind Chauhan <Arvind.Chauhan@arm.com>,
        Linaro Networking <linaro-networking@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 April 2014 05:08, Thomas Gleixner <tglx@linutronix.de> wrote:
> And that's wrong to begin with.
>
> Bugfixes first and then all other stuff. We dont want dependencies of
> bugfixes on cleanups, reordering of code ...

Correct, should have taken care of this initially :(

> Now looking at the thing some more, it contains gems like this:
>
> -               printk(KERN_ERR "tick-broadcast: ignoring broadcast for "
> -                      "offline CPU #%d\n", *oncpu);
> +               printk(KERN_ERR "tick-broadcast: ignoring broadcast for offline CPU #%d\n",
> +                      *oncpu);
>
> If you fix that checkpatch.pl line wrap issue, why do you not change
> printk(KERN_ERR) to pr_err() as well?
>
> checkpatch.pl is happy, right?

I did this for one patch and missed it for other.. I will fix all printk's in
kernel/time/ now :)

> Please send me the next series in the following way:
>
> - send a bug fix series, which does nothing else than fixing bugs.

Right.

>   when that is applied, then
>
> - send a small batch of improvements for a particular issue and not a
>   mixed bag of random patches.

Okay.. Thanks.
