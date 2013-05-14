Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946Ab3ENNsb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 09:48:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881Ab3ENNsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 09:48:30 -0400
Message-ID: <5192409C.8040100@redhat.com>
Date: Tue, 14 May 2013 09:48:12 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        bitbucket@online.de, tip-bot for Thomas Gleixner <tipbot@zytor.com>,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/urgent] tick: Cleanup NOHZ per cpu data on cpu down
References: <alpine.LFD.2.02.1305031451561.2886@ionos> <tip-4b0c0f294f60abcdd20994a8341a95c8ac5eeb96@git.kernel.org> <5190FE00.6010508@redhat.com> <alpine.LFD.2.02.1305132035360.2863@ionos>
In-Reply-To: <alpine.LFD.2.02.1305132035360.2863@ionos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/13/2013 03:10 PM, Thomas Gleixner wrote:
> On Mon, 13 May 2013, Prarit Bhargava wrote:
>> Thomas, while this does fix up the NULL pointer issue, I think you've introduced
>> a new bug in the schedule timer code.
> 
> I don't think that I introduced a new bug. I'm quite sure that change
> unearthed another issue which was papered over by the stale data.
> 
> That memset is putting the data structure into the same state as we
> have on boot. From tick-sched perspective cpu onlining is not
> different between boot and an offline/online cycle
> 
>> While doing up and downs on the same CPU, I now occasionally see long delays in
>> the up and down...
> 
>> [   81.744565] smpboot: Booting Node 1 Processor 19 APIC 0x28
>> [   82.848591] smpboot: CPU 19 is now offline
>>
>> Long delay in bringing CPU "up"
>>
>> [   89.826533] smpboot: Booting Node 1 Processor 19 APIC 0x28
>> [   84.905358] smpboot: CPU 19 is now offline
>> [   87.565274] smpboot: Booting Node 1 Processor 19 APIC 0x28
> 
> Errm, the timestamps are random. -ENOTUSEFUL
>  

I'm always saying my computer is full of lies ;)

Here's the bottom line.  The patch included in this thread plus the patch you
pointed me to here

http://marc.info/?l=linux-kernel&m=136847403809031&w=2

seem to resolve the cpu up/down + thermal interrupt issues that I've been seeing.

So thank you :)

Tested-by: Prarit Bhargava <prarit@redhat.com>

P.
