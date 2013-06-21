Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423720Ab3FUTAs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 15:00:48 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:59517 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423554Ab3FUTAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 15:00:44 -0400
MIME-Version: 1.0
In-Reply-To: <20130621184434.GC26001@kroah.com>
References: <1371831934-156971-1-git-send-email-nzimmer@sgi.com>
	<CAE9FiQVsNk0rjde8YQd_Bxvo8GFcpDoTeVRgvOMA8DVwhYO4kw@mail.gmail.com>
	<20130621184434.GC26001@kroah.com>
Date: Fri, 21 Jun 2013 12:00:44 -0700
X-Google-Sender-Auth: ZLYzvAp2s4cC_s1Xacax9bsZkJA
Message-ID: <CAE9FiQUfL9695iDY6zMwA5j6OGL8edotXwfSNBHsHC54qqEAGQ@mail.gmail.com>
Subject: Re: [RFC 0/2] Delay initializing of large sections of memory
From: Yinghai Lu <yinghai@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Nathan Zimmer <nzimmer@sgi.com>, Robin Holt <holt@sgi.com>,
        Mike Travis <travis@sgi.com>, Rob Landley <rob@landley.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "the arch/x86 maintainers" <x86@kernel.org>, linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 11:44 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Fri, Jun 21, 2013 at 11:36:21AM -0700, Yinghai Lu wrote:
>> On Fri, Jun 21, 2013 at 9:25 AM, Nathan Zimmer <nzimmer@sgi.com> wrote:
>> > This rfc patch set delays initializing large sections of memory until we have
>> > started cpus.  This has the effect of reducing startup times on large memory
>> > systems.  On 16TB it can take over an hour to boot and most of that time
>> > is spent initializing memory.
>>
>> One hour on system with 16T ram? BIOS or OS?
>>
>> I use wall clock to check bootime on one system with 3T and 16 pcie cards,
>> Linus only takes about 3m and 30 seconds from bootloader.
>>
>> wonder if you boot delay is with so many cpu get onlined in serialized mode.
>>
>> so can you try boot your system with "maxcpus=128" to get the boot time with
>> wall clock ?
>
> Why use the "wall clock" when we have the wonderful bootchart tools and
> scripts that do this all for you, and can tell you exactly what part of
> the kernel is taking what time, to help with fixing issues like this?

bootchart is not completed.

printk timestamp come after mem get initialized.
....
[    0.004000] tsc: Fast TSC calibration using PIT

before that stamp are all 0.

Yinghai
