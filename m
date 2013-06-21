Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946106Ab3FUVTV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 17:19:21 -0400
Received: from relay2.sgi.com ([192.48.179.30]:37228 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946062Ab3FUVTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 17:19:19 -0400
Message-ID: <51C4C356.3040602@sgi.com>
Date: Fri, 21 Jun 2013 14:19:18 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Nathan Zimmer <nzimmer@sgi.com>, Robin Holt <holt@sgi.com>,
        Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        the arch/x86 maintainers <x86@kernel.org>, linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 0/2] Delay initializing of large sections of memory
References: <1371831934-156971-1-git-send-email-nzimmer@sgi.com> <CAE9FiQVsNk0rjde8YQd_Bxvo8GFcpDoTeVRgvOMA8DVwhYO4kw@mail.gmail.com>
In-Reply-To: <CAE9FiQVsNk0rjde8YQd_Bxvo8GFcpDoTeVRgvOMA8DVwhYO4kw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 6/21/2013 11:36 AM, Yinghai Lu wrote:
> On Fri, Jun 21, 2013 at 9:25 AM, Nathan Zimmer <nzimmer@sgi.com> wrote:
>> This rfc patch set delays initializing large sections of memory until we have
>> started cpus.  This has the effect of reducing startup times on large memory
>> systems.  On 16TB it can take over an hour to boot and most of that time
>> is spent initializing memory.
> 
> One hour on system with 16T ram? BIOS or OS?

The BIOS is about 20 minutes *before* the 1+ hour.  (When we started this
UV project way back when, 8TB took over 4 hours before we threw in the towel.)
> 
> I use wall clock to check bootime on one system with 3T and 16 pcie cards,
> Linus only takes about 3m and 30 seconds from bootloader.

I can send some stats on where various delays are but most of it was in
memory initialization.  On average UV nodes carry 128 or 256G per node,
so 12 nodes would take about 3 or 4 minutes, perhaps more.
> 
> wonder if you boot delay is with so many cpu get onlined in serialized mode.

Nope.  If that was the case, delaying memory but initializing all the
cpus would not affect the time.
> 
> so can you try boot your system with "maxcpus=128" to get the boot time with
> wall clock ?

We could try if you really think it will provide any useful info.  Not sure
exactly how having memory on nodes with no active cpus will react.
> 
> Thanks
> 
> Yinghai
> 
