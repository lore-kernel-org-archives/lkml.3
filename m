Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab3IIRrX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 13:47:23 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:48315 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab3IIRrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 13:47:21 -0400
MIME-Version: 1.0
In-Reply-To: <e54aa177-0c72-447b-9c95-26bda8728d08@email.android.com>
References: <5226FAE1.5070201@fb.com> <CALCETrWify68=_bVmFfnTWH5vY3NgxDChr_cvL7v6VovaSJdKA@mail.gmail.com>
 <CANcMJZAi_738t-eDUphC6U_25xFS0NqQqdUZAzu7Aijqmrj=wA@mail.gmail.com>
 <CALCETrVc-3j=7bP13dkYwqxUg77rdauHQ8_KEti0khh-HX220A@mail.gmail.com>
 <52279E1D.3060907@linaro.org> <5227B432.8070205@zytor.com>
 <CALCETrWnZnT_t0KkWPo1v1tmPhX5_XKD19ktWL2BvKY-MezkAA@mail.gmail.com> <e54aa177-0c72-447b-9c95-26bda8728d08@email.android.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 9 Sep 2013 10:47:01 -0700
Message-ID: <CALCETrWJbtrC0FDKFQ7_qS8sdxd7LyJk562uAzrK1TJqy97YOA@mail.gmail.com>
Subject: Re: clock_gettime_ns
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: John Stultz <john.stultz@linaro.org>, Arun Sharma <asharma@fb.com>,
        LKML <linux-kernel@vger.kernel.org>, Kumar Sundararajan <kumar@fb.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 4, 2013 at 6:22 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> I think it would be crazy encoding UTC with a non-POSIX scheme.

The whole point is to find a good way to return the time that solves
the problems with the POSIX scheme.  Some of the problems, as I see
them, are:

 - Performance: seconds + nanoseconds is expensive to compute and
expensive to use.
 - Leap seconds, part 1: Times like 23:59:60.1 are not representable.
 - Leap seconds, part 2: The limited leap-second support that already
exists (via the NTP APIs) is so obscure that it's frequently broken.
 - Offsets between clocks can't be read without using complicated
calls like adjtimex.

I think that coming up with something that's both non-POSIX and
half-arsed is a bad idea, but doing something that's non-POSIX and
well thought-through could be valuable.

--Andy
