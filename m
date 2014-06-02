Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071AbaFBNGZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 09:06:25 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:46648 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139AbaFBNGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 09:06:20 -0400
X-AuditID: cbfee61b-b7fbb6d000001be3-72-538c76ca96bb
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v2 1/7] arm: firmware: Check firmware is running or not
Date: Mon, 02 Jun 2014 15:05:54 +0200
Message-id: <7579658.qxmXgWLkvU@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <538C7342.4000700@gmail.com>
References: <1401712543-14281-1-git-send-email-b.zolnierkie@samsung.com>
 <1401712543-14281-2-git-send-email-b.zolnierkie@samsung.com>
 <538C7342.4000700@gmail.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsVy+t9jAd1TZT3BBpt2SVvM+yxr0bvgKpvF
	2aY37BbvDz1jttj0+BqrxeVdc9gsPvceYbSYcX4fk8WZ05dYLU7+6WW0WD/jNYvFql1/GC02
	fvVw4PXYOesuu8eda3vYPDYvqfe4/e8xs8eWq+0sHn1bVjF6fN4kF8AexWWTkpqTWZZapG+X
	wJVx85VBQQ9XxYnrK5kbGI+wdzFyckgImEh8W7WOFcIWk7hwbz0biC0ksIhR4updHwi7hUni
	wQotEJtNwEpiYvsqRhBbREBd4tuUfqA5XBzMAseZJZ73LgRrFhbwltjzbR6YzSKgKnF2yT6w
	BbwCmhLdf/aDxUUFPCV2bF8JZnMCxV+8WcsCsWwZo8TbmcwQ9YISPybfA4szC8hL7Ns/lRXC
	1pHY3zqNbQKjwCwkZbOQlM1CUraAkXkVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnC0PJPe
	wbiqweIQowAHoxIP7w/1nmAh1sSy4srcQ4wSHMxKIrxLLYBCvCmJlVWpRfnxRaU5qcWHGKU5
	WJTEeQ+2WgcKCaQnlqRmp6YWpBbBZJk4OKUaGPmyz76PULVadPoR37K/nVOnaBaX+grPWmyk
	mb0j86bUJfmS+RdkDPIuTrLS4P1p7309be2ul++yI0NSFnZNl18YESN2N6OaN81E8ayTxdMt
	1+wKRFSOK+zZ3Lkp3n59T5iEggarcsHMZx41u2YuT+qPOn96qdKOuyrBb5xXzE23sQw7rDNz
	sxJLcUaioRZzUXEiAJotLZCSAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Monday, June 02, 2014 02:51:14 PM Tomasz Figa wrote:
> Hi,
> 
> On 02.06.2014 14:35, Bartlomiej Zolnierkiewicz wrote:
> > From: Kyungmin Park <kyungmin.park@samsung.com>
> > 
> > To support multi-platform, it needs to know it's running under secure
> > OS or not.  Sometimes it needs to access physical address by SMC calls.
> > 
> > e.g.,
> >         if (firmware_run()) {
> >                 addr = physical address;
> >         } else {
> >                 addr = virtual address;
> >         }
> > 
> >         call_firmware_ops(read_address, addr, &value);
> 
> Hmm, I don't understand the code above. It first asks whether the
> firmware is available and then calls a firmware operation anyway
> (assuming that firmware is available regardless of the check above)...
> 
> I don't like the idea of this function, because we have designed the
> firmware API to not require this kind of checks. Instead, you just call
> whatever firmware operation you need and if it returns -ENOSYS you need
> to fallback to legacy (firmware-less) way of doing it.
> 
> Could you provide your use case for which this doesn't work?

Please take a look at patch #7.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

