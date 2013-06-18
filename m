Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab3FRCOJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 22:14:09 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:48462 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab3FRCOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 22:14:08 -0400
MIME-Version: 1.0
In-Reply-To: <B8EFE96D1287C24090BAD9D858E15E6172A070@sisaex02sj>
References: <B8EFE96D1287C24090BAD9D858E15E6172A070@sisaex02sj>
Date: Mon, 17 Jun 2013 19:14:07 -0700
X-Google-Sender-Auth: TGIi1D2QHLvvaxDU2p0Db69iDOk
Message-ID: <CANcMJZCuYmim8q5ZPg2ppwA8T0jXMmpGowikeca5EzaoeVxr-Q@mail.gmail.com>
Subject: Re: pm: System date and time set incorrectly after suspend/resume to disk
From: John Stultz <john.stultz@linaro.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: "rjw@sisk.pl" <rjw@sisk.pl>, "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 6:30 PM, Shuah Khan <shuah.kh@samsung.com> wrote:
> I am seeing a problem on my system after a suspend to disk in reboot or
> shutdown mode. When pm_trace is 0 (which is the default), I can't
> reproduce the problem easily. I have to run a few more suspend tests
> before I see the problem. When pm_trace is disabled, the problem showed
> up when I ran suspend in platform mode in a row. However when pm_ptrace
> is enabled, problem happens on the very first spend to disk in reboot mode.
>
> Steps to run into the issue:
>
> echo 1 > pm_print_times
> echo 1 > pm_trace
> echo reboot > disk
> echo disk > state
>
> or
>
> echo 1 > pm_print_times
> echo 1 > pm_trace
> echo shutdown > disk
> echo disk > state
>
> When system comes back up, system time set to incorrect time.

So I this is by design. Please see Documentation/power/s2ram.txt for details:

"pm_trace uses the system's Real Time Clock (RTC) to save the magic number.
Reason for this is that the RTC is the only reliably available piece of
hardware during resume operations where a value can be set that will
survive a reboot.

Consequence is that after a resume (even if it is successful) your system
clock will have a value corresponding to the magic number instead of the
correct date/time! It is therefore advisable to use a program like ntp-date
or rdate to reset the correct date/time from an external time source when
using this trace option."

thanks
-john
