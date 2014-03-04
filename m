Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754AbaCDVxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:53:25 -0500
Received: from mail-ve0-f172.google.com ([209.85.128.172]:46954 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756072AbaCDVxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 16:53:24 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1403042153520.18573@ionos.tec.linutronix.de>
References: <1392913425-29369-1-git-send-email-a.perevalov@samsung.com>
 <1392913425-29369-6-git-send-email-a.perevalov@samsung.com>
 <530D5715.1050901@mit.edu> <alpine.DEB.2.02.1403042153520.18573@ionos.tec.linutronix.de>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 4 Mar 2014 13:53:03 -0800
Message-ID: <CALCETrVsmXjkC28pTSCfywTZCeHVcfvyFvHAXubEJ7=TRoEmPQ@mail.gmail.com>
Subject: Re: [PATCH v4 5/6] timerfd: Add support for deferrable timers
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Alexey Perevalov <a.perevalov@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton@enomsg.org>,
        Kyungmin Park <kyungmin.park@samsung.com>, cw00.choi@samsung.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 4, 2014 at 12:58 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Tue, 25 Feb 2014, Andy Lutomirski wrote:
>> On the other hand, if you added a fancier version of timerfd_settime
>> that could explicitly set the slack value (or, equivalently, the
>> earliest and latest allowable times), that could be quite useful.
>>
>> It's often bugged me that timer slack is per-process.
>
> That's a totally different issue. There is a world aside of timerfd
> timers.

This is a patch to add deferrable support *to timerfd*.  I'm asking
why this is a useful feature to add.  Some day (maybe soon -- systemd
is doing something awful here) people will want choices of slack
values other than the per-process value and infinity.  Why not just do
that and skip this intermediate API that will have to be supported
forever?

I admit that I don't really understand the difference between hrtimers
and the other kind of timer internally, but I don't see why this
should have any effect at all of the userspace API.  The kernel
supports slack, slack is strictly more useful than "deferrable", so
let's just expose it properly to userspace.

--Andy
