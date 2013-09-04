Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759558Ab3IDSMe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 14:12:34 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:38558 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756930Ab3IDSMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 14:12:31 -0400
Message-ID: <522777FF.2040906@linux.vnet.ibm.com>
Date: Wed, 04 Sep 2013 23:42:15 +0530
From: Hemant <hkshaw@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mark Wielaard <mjw@redhat.com>
CC: Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        srikar@linux.vnet.ibm.com, peterz@infradead.org, oleg@redhat.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org
Subject: Re: [RFC PATCH 0/2] Perf support to SDT markers
References: <20130903072944.4793.93584.stgit@hemant-fedora> <20130903082503.GA20732@gmail.com> <5225A937.2050507@hitachi.com> <5225E2C5.3080001@linux.vnet.ibm.com>  <87a9jtt72j.fsf@sejong.aot.lge.com> <1378283148.4321.16.camel@bordewijk.wildebeest.org>
In-Reply-To: <1378283148.4321.16.camel@bordewijk.wildebeest.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090417-0260-0000-0000-000003924928
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2013 01:55 PM, Mark Wielaard wrote:
> On Wed, 2013-09-04 at 15:49 +0900, Namhyung Kim wrote:
>> On Tue, 03 Sep 2013 18:53:17 +0530, Hemant wrote:
>>> On 09/03/2013 02:47 PM, Masami Hiramatsu wrote:
>>>> Indeed, and also I'd like to know what versions of SDT this support,
>>>> and where we can see the technical document of that. As far as I know,
>>>> the previous(?) SDT implementation also involves ugly semaphores.
>>>> Have that already gone?
>> It seems it's not. I see the SDT v3 document still mentions semaphores.
> It mentions them, but should normally not be used. They are there for
> dtrace (source) compatibility. And you don't have to use them.
>
> Since normally a SDT probe marker is just a NOP it doesn't have any
> overhead. But if you want to add complicated arguments that you would
> normally not generate in your code, then you might want to add a
> semaphore. That way you can have probes with a bit more overhead that
> still have zero overhead when not being probed.
>
> Note that if you use the normal DTRACE_PROBE macros no semaphore will be
> inserted. And you can opt to not support probes that have a semaphore in
> perf if you think that is easier (just check the semaphore link-time
> address for the probe, it should normally be zero). Just warn: "No way I
> am going to probe something that might have a little extra overhead! I
> am no debugger..." :)

I agree. There will be an extra overhead but there may be some important 
markers (on which we need to probe) may be worth this overhead?

Thanks
Hemant

>
>>> This link shows an example of marker probing with Systemtap:
>>> https://sourceware.org/systemtap/wiki/AddingUserSpaceProbingToApps
>> I think the link below would be more helpful for us :)
>>
>> http://sourceware.org/systemtap/wiki/UserSpaceProbeImplementation
> Yes, that should be the canonical description.
>
> Cheers,
>
> Mark
>

