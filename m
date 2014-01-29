Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbaA2R4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 12:56:23 -0500
Received: from mail-vb0-f53.google.com ([209.85.212.53]:57369 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbaA2R4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 12:56:21 -0500
MIME-Version: 1.0
In-Reply-To: <20140128175804.GA5287@netboy>
References: <1389067023-13541-1-git-send-email-john.stultz@linaro.org>
	<20140113175114.GA4271@netboy>
	<52D42D36.1020400@linaro.org>
	<20140128175804.GA5287@netboy>
Date: Wed, 29 Jan 2014 09:56:20 -0800
Message-ID: <CALAqxLU21LNc2g_VnmGjZqqdjjKVZ3sRDQDdQmD2f=b13iV+pA@mail.gmail.com>
Subject: Re: [PATCH] [RFC] timekeeping: Rework frequency adjustments to work
 better w/ nohz
From: John Stultz <john.stultz@linaro.org>
To: Richard Cochran <richardcochran@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Prarit Bhargava <prarit@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 9:58 AM, Richard Cochran
<richardcochran@gmail.com> wrote:
> I tested for a regression using the patched kernel with the nohz=off
> command line option...
>
> On Mon, Jan 13, 2014 at 10:15:18AM -0800, John Stultz wrote:
>> On 01/13/2014 09:51 AM, Richard Cochran wrote:
>> >
>> > - Linux 3.12.7-nohz-plain-20140106                nohz-plain.log
>> > - Linux 3.12.7-nohz-plain-20140106 NOHZ=OFF       periodic-plain.log
>> > - Linux 3.12.7-nohz-fix-20140106-00001-gd753140   nohz-fix.log
>
> Regression check:
>
>  - Linux homeboy 3.12.7-nohz-fix-20140106-00001-gd753140 NOHZ=OFF
>    nohz-fix-periodic.log
>
>> > The performance in the log files as reflected in the clock offset is
>> > summarized in this table. The values are in nanoseconds.
>> >
>> >  |         | periodic-plain |      nohz-fix |    nohz-plain |
>> >  |---------+----------------+---------------+---------------|
>> >  | minimum |  -1.599000e+03 | -1.051000e+03 | -5.373700e+04 |
>> >  | maximum |  +1.311000e+03 | +1.048000e+03 | +6.389500e+04 |
>> >  | mean    |  +9.880240e-02 | -7.747305e+01 | +1.597904e+01 |
>> >  | stddev  |  +4.610021e+02 | +3.960978e+02 | +1.491263e+04 |
>
> Comparing the nohz=off case with and without the patch, the three hour
> test looks like this.
>
>   |         | periodic-plain | nohz-fix-periodic |
>   |---------+----------------+-------------------+
>   | minimum |  -1.599000e+03 |     -1.427000e+03 |
>   | maximum |  +1.311000e+03 |     +1.279000e+03 |
>   | mean    |  +9.880240e-02 |     -2.710778e+01 |
>   | stddev  |  +4.610021e+02 |     +3.974372e+02 |
>
>> >    http://linuxptp.sourceforge.net/nohz-fix/current_nohz.png
>> >    http://linuxptp.sourceforge.net/nohz-fix/periodic_vs_fix.png
>
> I also made a third graph showing before and after the patch.
>
>     http://linuxptp.sourceforge.net/nohz-fix/nohz_regression.png
>
>> If you do get a chance to look again, I'd also be interested if running
>> with nohz=off w/ the fix doesn't show any regression compared to the
>> unmodified nohz=off case.
>
> Looks like there is no regression.

That's great to hear! Looks like we might be able to queue it for 3.15...

Thanks so much again for the detailed testing! I really appreciate it!

thanks
-john
