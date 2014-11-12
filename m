Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbaKLWOv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 17:14:51 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:8683 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752273AbaKLWOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 17:14:49 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Au0NAOatTlRFpamy/2dsb2JhbABcgw5UWIMGtkoGk2aHUQKBHBcBAXyEAgEBBAEjBBEeIgEQIwICBRYEBwICCQMCAQIBJxUJBg0BBwEBFogeCQ22b5R2AQEBAQEBAQMBAQEBAQEBARqBLIUIiXIRAVAHgneBVAEEi2SEBYZmiEOGO4cjgx+CEYFvgjSBYh8vgQ+BPAEBAQ
X-IPAS-Result: Au0NAOatTlRFpamy/2dsb2JhbABcgw5UWIMGtkoGk2aHUQKBHBcBAXyEAgEBBAEjBBEeIgEQIwICBRYEBwICCQMCAQIBJxUJBg0BBwEBFogeCQ22b5R2AQEBAQEBAQMBAQEBAQEBARqBLIUIiXIRAVAHgneBVAEEi2SEBYZmiEOGO4cjgx+CEYFvgjSBYh8vgQ+BPAEBAQ
X-IronPort-AV: E=Sophos;i="5.04,797,1406606400"; 
   d="scan'208";a="96795868"
Message-ID: <5463DBD5.9080303@voxpopuli.im>
Date: Wed, 12 Nov 2014 17:14:45 -0500
From: Alexandre Montplaisir <alexmonthy@voxpopuli.im>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Dominique Toupin <dominique.toupin@ericsson.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Jeremie Galarneau <jgalar@efficios.com>,
        David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Trace Compass Developer Discussions 
	<tracecompass-dev@eclipse.org>
Subject: Support for Perf CTF traces now in master (was Re: FW: [RFC 0/5]
 perf tools: Add perf data CTF conversion)
References: <53F38C74.4030300@voxpopuli.im> <20140820092858.GA1203@krava.brq.redhat.com> <53F4F38C.4080407@voxpopuli.im> <5457C259.8030605@linutronix.de> <545829CA.7040900@voxpopuli.im> <20141105125028.GA30087@linutronix.de> <545AEA37.601@voxpopuli.im> <5460156E.3050601@voxpopuli.im>
In-Reply-To: <5460156E.3050601@voxpopuli.im>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11/09/2014 08:31 PM, Alexandre Montplaisir wrote:
> On 2014-11-05 10:25 PM, Alexandre Montplaisir wrote:
>>
>>>
>>>> But if you could for example tell me the perf equivalents of all the
>>>> strings in that file, I could hack together such wrapper. With that,
>>>> in theory, perf traces should behave exactly the same as LTTng traces
>>>> in the viewer!
>>> Oooh, that would be awesome. So I installed maven but didn't get much
>>> further. Let me gather this for you.
>>
>> Awesome, thanks!
>>
>> I am travelling this week, so I'm a bit busy, but I will try to 
>> prototype a "wrapper" for the kernel analysis, and adding support for 
>> the perf events, whenever I have a chance. I'll keep you posted.
>
> Ok, some good news!
>
> I managed to get the CTF traces from perf working in Trace Compass! 
> See attached screenshots. This is showing the "ctf-out2" trace from 
> your previous email. The other trace seems to have less events 
> enabled, so it would only show some WAIT_FOR_CPU states in the view.
>
> If anybody wishes to try it, you can grab the whole branch ending at 
> https://git.eclipse.org/r/#/c/36200/ . Or run:
> $ git fetch 
> git://git.eclipse.org/gitroot/tracecompass/org.eclipse.tracecompass 
> refs/changes/00/36200/3 && git checkout FETCH_HEAD

Just a quick note, this branch is now merged to master. So anyone who 
pulls the code from the master branch at
git://git.eclipse.org/gitroot/tracecompass/org.eclipse.tracecompass.git
should be able to load perf-CTF traces in the viewer. The trace type is 
now called "Common Trace Format -> Linux Kernel Trace" and should 
support both LTTng kernel and perf traces in CTF format (although 
auto-detection should work in most cases).

This was based on the most recent file format I was aware of, we will 
update it accordingly if required.

Testing welcome!

Cheers,
Alexandre

>
> It reuses much of the code from the LTTng analysis, which is why it 
> was relatively quick to do. For now, it looks for the domain in the 
> CTF environment to be "kernel-perf". But this will be easy to update, 
> if needed, once the final format is decided.
>
> Maybe I missed it, but I couldn't find the system call names in the 
> trace. Using the sys_enter and sys_exit events, the viewer is able to 
> determine the kernel-mode states (in blue), but we cannot show the 
> exact system call names like we do with LTTng.
> There is also something weird with the arrows in the Control Flow View 
> (disabled in the screenshot), I don't know if it's due to the 
> particularity of the trace or to a bug in the view. We'll investigate.
>
> Feedback is very welcome.
>
> Cheers,
> Alexandre

