Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914AbaAMPaQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 10:30:16 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:45121 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaAMPaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 10:30:12 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-c9-52d4068224f9
Message-id: <52D40681.3030801@samsung.com>
Date: Mon, 13 Jan 2014 19:30:09 +0400
From: Alexey Perevalov <a.perevalov@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623
 Thunderbird/17.0.7
MIME-version: 1.0
To: linux-kernel@vger.kernel.org, john.stultz@linaro.org
Cc: Alexey Perevalov <a.perevalov@samsung.com>, anton@enomsg.org,
        kyungmin.park@samsung.com, akpm@linux-foundation.org,
        cw00.choi@samsung.com
Subject: Re: [PATCH v2 0/3] Deferrable timers support for timerfd API
References: <1389609835-24377-1-git-send-email-a.perevalov@samsung.com>
In-reply-to: <1389609835-24377-1-git-send-email-a.perevalov@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsVy+t/xa7pNbFeCDL5fVrKYe/c8i8Wc9WvY
	LA5u1bS4/uU5q8WZ37oWZ5vesFtc3jWHzYHdY0L/J0aPO9f2sHmcmPGbxaNvyypGj8+b5AJY
	o7hsUlJzMstSi/TtErgy9vxoZSxYyl0x99gW9gbGpxxdjJwcEgImEs+6elkhbDGJC/fWs3Ux
	cnEICSxllOg72skE4XxmlHjbe5sJpIpXQEvi57QDbCA2i4CqxMKdExi7GDk42AQMJPbdswUx
	RQUiJI4u14SoFpT4MfkeC4gtImAhcefVf1aQkcwC/YwS3XOeg40RFnCVOLF9PdgRQgLuEsfn
	f2UEsTkFPCSOL9kKZjMLWEusnLQNypaX2LzmLfMERoFZSHbMQlI2C0nZAkbmVYyiqaXJBcVJ
	6bmGesWJucWleel6yfm5mxghAf5lB+PiY1aHGAU4GJV4eE8yXgkSYk0sK67MPcQowcGsJMJb
	9fNykBBvSmJlVWpRfnxRaU5q8SFGJg5OqQZG4xLxmjcH2GuMLyjfefunf2G2QIyCI4+qoXW4
	kftep4vBm59+0ei1nqPIvyk0ZlUbk7uej/Es58Yf6/ft5Jl/88N2hmbDFY5+Z9bW3v//se6l
	VOCRfRP0PNeeWNhke6K8d1lb8C4Vo48TFx3O/FGy9/NN4d4t9mGi9ev5tso+nLpAJ3wty4nH
	SizFGYmGWsxFxYkA3mu80U4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello all,

one remark - timerfd is not documented in linux Documentation directory 
at all.
I think it's better to have such description.


On 01/13/2014 02:43 PM, Alexey Perevalov wrote:
> Hello dear community.
>
> This is reworked patch set of original Anton's Vorontsov
> proposal regarding unified deferrable timers in the user space.
> http://lwn.net/Articles/514707/
>
>
> I decided to resubmit it due we found it usefull for us too.
>
> timerfd was modified since Anton's commit, Alarm support was added.
> This isn't only rebase. Anton's previous version used deferrable timer
> in couple with hrtimer. This version uses only deferrable timer. It
> mean the behaviour of overrun number is different.
> e.g. if you don't poll one second timer for a 10 seconds - you'll get
> 10 overruns with hrtimer, but for deferrable timer it could be another value.
>
> Anton Vorontsov (3):
>    kernel/time: Add new helpers to convert ktime to/from jiffies
>    timerfd: Factor out timer-type unspecific timerfd_expire()
>    timerfd: Add support for deferrable timers
>
>   fs/timerfd.c            |  127 +++++++++++++++++++++++++++++++++++------------
>   include/linux/jiffies.h |    4 +-
>   include/linux/ktime.h   |    3 +-
>   include/linux/timerfd.h |    4 +-
>   kernel/time.c           |   23 +++++++++
>   5 files changed, 126 insertions(+), 35 deletions(-)
>


-- 
Best regards,
Alexey Perevalov
