Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbaAWO1q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 09:27:46 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:36888 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbaAWO1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 09:27:45 -0500
MIME-Version: 1.0
In-Reply-To: <20140123135430.GB13345@localhost.localdomain>
References: <CAKohpomO+2WbNLceBznWwYRcv0e7RsPiaRF7ctRZ+6GFKtr4aA@mail.gmail.com>
	<CALZhoSRvhqJXU=z=h30SS6USjHFe3yKLsJN9WzQr6ch0sxoN-g@mail.gmail.com>
	<CAKohpokbb3ko3sW4kuDKZSoY1qJ6apVVR3-jpv=7m5ZX__YP8Q@mail.gmail.com>
	<20140120154058.GA9436@localhost.localdomain>
	<CALZhoSTzGH+mAB-Om=3dQTgQJriDmH+is_DEAzWNN7rRpzNFuQ@mail.gmail.com>
	<20140123135430.GB13345@localhost.localdomain>
Date: Thu, 23 Jan 2014 19:57:44 +0530
Message-ID: <CAKohpo=VoXbGmCXokK_MDC=oq7WievXH7-=JtMVWOQaYu3iaMw@mail.gmail.com>
Subject: Re: [QUERY]: Is using CPU hotplug right for isolating CPUs?
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Lei Wen <adrian.wenl@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 January 2014 19:24, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Tue, Jan 21, 2014 at 10:07:58AM +0800, Lei Wen wrote:
>> I find the cpuset's cpus member becomes NULL even I hotplug the core3
>> back again.
>> So is it a bug?
>
> Not sure, you may need to check cpuset internals.

I think this is the correct behavior. Userspace must decide what to do
with that CPU once it is back. Simply reverting to earlier cpusets
configuration might not be the right approach.

Also, what if cpusets have been rewritten in-between hotplug events.
