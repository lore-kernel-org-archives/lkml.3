Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbaKJTkX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 14:40:23 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:51591 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbaKJTkU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 14:40:20 -0500
MIME-Version: 1.0
In-Reply-To: <20141107064027.GA24745@yliu-dev.sh.intel.com>
References: <20141107060040.GD30507@yliu-dev.sh.intel.com> <CALCETrVBcZ=5YJMzjKwFpjz6p32FmXcdkR=8uSPm8kCECDka4g@mail.gmail.com>
 <20141107064027.GA24745@yliu-dev.sh.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 10 Nov 2014 11:39:56 -0800
Message-ID: <CALCETrXNxQ=fpVS2d5ntHQzNqMwhquDT7uK3=16GCAkWq6fh9g@mail.gmail.com>
Subject: Re: [LKP] [x86_64,entry] f04e05b81e4: -62.7% time.user_time
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: LKP <lkp@01.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 6, 2014 at 10:40 PM, Yuanhan Liu
<yuanhan.liu@linux.intel.com> wrote:
> On Thu, Nov 06, 2014 at 10:26:23PM -0800, Andy Lutomirski wrote:
>> On Thu, Nov 6, 2014 at 10:00 PM, LKP <lkp@01.org> wrote:
>> > FYI, we noticed the below changes on
>> >
>> > git://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git x86/entry
>> > commit f04e05b81e4d9ae88bee379f12176f551a24394a ("x86_64,entry: Use sysret to return to userspace when possible")
>> >
>> >
>> > f2ee9bebb99dd4a4  f04e05b81e4d9ae88bee379f12  testbox/testcase/testparams
>> > ----------------  --------------------------
>> >          %stddev     %change         %stddev
>> >              \          |                \
>> >      24.09 ą  4%     -62.7%       8.99 ą  3%  lkp-wsx02/aim9/performance-300s-creat-clo
>> >      24.09           -62.7%       8.99        GEO-MEAN time.user_time
>> >
>>
>> I don't really know how to interpret this.  Is this a good thing or a bad thing?
>
> TBH, I don't, either. Here we just list the changes we captured, which
> is then for your information to decide it's good or bad.
>
>>
>> I actually expect this change to be a dramatic speedup for some
>> workloads.
>
> Would you like to share your workload? If so, I can add them to our
> testing system, and give feedback to you when datat is available.

My workload is just syscall performance under different conditions.
There's no obvious interesting benchmark, although I may write one at
some point.

>
>> Any chance you can send me the .config, kernel command
>> line, and whether you have any tracing features enabled?
>
> .config and dmesg are attached.

Hmm.  I'm not entirely sure what's going on.  I think that you have
NO_HZ_FULL active, but I can't see what's actually activating it.  My
initial attempt to replicate this failed, but I see a big performance
gain if CONFIG_CONTEXT_TRACKING_FORCE=y, so I suspect that you've just
managed to activate context tracking without forcing it.

--Andy
