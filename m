Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760131AbaCUH6I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 03:58:08 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:43522 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689AbaCUH6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 03:58:05 -0400
MIME-Version: 1.0
In-Reply-To: <532BEE64.3090501@linux.vnet.ibm.com>
References: <cover.1395379422.git.viresh.kumar@linaro.org>
	<f6116069b730c0c3a74ff627fa818b98dc4f1491.1395379422.git.viresh.kumar@linaro.org>
	<532BEE64.3090501@linux.vnet.ibm.com>
Date: Fri, 21 Mar 2014 13:28:04 +0530
Message-ID: <CAKohpom8ZHXxVmuSHYL5nyZzNrK8EFNVdx5XJdJxiHWPb13aeg@mail.gmail.com>
Subject: Re: [PATCH V4 1/3] cpufreq: Make sure frequency transitions are serialized
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "ego@linux.vnet.ibm.com" <ego@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 March 2014 13:16, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> Wonderful! I was going to do this today, but thanks a lot for taking
> care of this for me!

I just wanted to finish this long lasting thread as soon as possible.

> We need this assignment to happen exactly at this point, that is, *after*
> the call to post_transition() completes and before calling wake_up().
>
> If the compiler or the CPU reorders the instructions and moves this
> assignment to some other place, then we will be in trouble!
>
> We might need memory barriers to ensure this doesn't get reordered.
> Alternatively, we can simply hold the spin-lock around this assignment,
> since locks automatically imply memory barriers. As an added advantage,
> the code will then look more intuitive and easier to understand as well.
>
> Thoughts?

I may be wrong but this is how I understand locks. Yes, spinlocks have
memory barriers implemented but it wouldn't guarantee what you are
asking for in the above explanation.

It will guarantee that transition_ongoing will be updated after the lock
is taken but the notification() can happen after the lock is taken and
also after the variable is modified.

You can find some information on this in
Documentation/memory-barriers.txt

I don't think compiler or CPU will reorder calls to a function and
updates of a variable. And so this code might simply work. And
I hope there would be plenty of such code in kernel.
