Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969AbaCHQWi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 11:22:38 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:43628 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbaCHQWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 11:22:37 -0500
MIME-Version: 1.0
In-Reply-To: <20140308091331.GA282@x4>
References: <CALCETrWSyhJHwfKSBT3giSb0AtvHFBR9PYmhFhFJa=Yabw25iw@mail.gmail.com>
 <1394265078.7215.11.camel@marge.simpson.net> <20140308091331.GA282@x4>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 8 Mar 2014 08:22:16 -0800
Message-ID: <CALCETrW5Gpz7TYVVj2NxbKx4cFdePUQ1sEPDyLt5qLmy7KCycQ@mail.gmail.com>
Subject: Re: perf samples too long without perf running (?!?)
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 8, 2014 at 1:13 AM, Markus Trippelsdorf
<markus@trippelsdorf.de> wrote:
> On 2014.03.08 at 08:51 +0100, Mike Galbraith wrote:
>> On Fri, 2014-03-07 at 17:57 -0800, Andy Lutomirski wrote:
>> > On recent (3.13) kernels, I'm frequently getting messages like:
>> >
>> > perf samples too long (2503 > 2500), lowering
>> > kernel.perf_event_max_sample_rate to 50000
>> >
>> > a few seconds to minutes after bootup.  As far as I know, I'm not
>> > using perf.  What's going on here?
>>
>> 14c63f17b1
>>
>> I get those all the time too, just building kernels.
>
> I have:
>  echo 0 > /proc/sys/kernel/perf_cpu_time_max_percent
> in my local startup script since that commit.

...so the NMI watchdog (which happens IIRC once every two minutes)
takes more than 0.4ms or so, so perf flips out, changes its parameters,
and writes a log message.

Is it just me or is this whole situation screwed up for multiple reasons?

--Andy

>
> --
> Markus



-- 
Andy Lutomirski
AMA Capital Management, LLC
