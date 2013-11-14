Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab3KNSBW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 13:01:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754177Ab3KNSBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 13:01:13 -0500
Message-ID: <52850FEC.2040106@redhat.com>
Date: Thu, 14 Nov 2013 13:01:16 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Miroslav Lichvar <mlichvar@redhat.com>
CC: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        Prarit Bhargava <prarit@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH RFC] timekeeping: Fix clock stability with nohz
References: <1384440640-9482-1-git-send-email-mlichvar@redhat.com>
In-Reply-To: <1384440640-9482-1-git-send-email-mlichvar@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2013 09:50 AM, Miroslav Lichvar wrote:
> Since commit 5eb6d205 the system clock is kept separately from NTP time
> and it is synchronized by adjusting its multiplier in a feedback loop.
> This works well when the updates are done regularly. With nohz and idle
> system, however, the loop becomes unstable at a certain update interval.
> The loop overcorrects and the frequency doesn't settle down. The clock
> has a large error, which seems to grow quadratically with update
> interval.

> In a simulation with 1GHz TSC clock and 10Hz clock update the maximum
> error went down from 4.7 microseconds to 5.5 nanoseconds. With 1Hz
> update the maximum error went down from 480 microseconds to 55
> nanoseconds.
>
> In a real test on idle machine comparing raw TSC and clock_gettime()
> time stamps, the maximum error went down from microseconds to tens of
> nanoseconds. A test with clock synchronized to a PTP hardware clock by
> phc2sys from linuxptp now shows no difference when running with nohz
> enabled and disabled, the clock seems to be stable to few tens of
> nanoseconds.

Looks like a big improvement to me.

Also very useful for virtual machines, which have no
good control over when the timekeeping routines will
run, but which can see what time it is when they do
run...

> Signed-off-by: Miroslav Lichvar <mlichvar@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>
