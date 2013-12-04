Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab3LDEPx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 23:15:53 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:54606 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab3LDEPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 23:15:52 -0500
Message-ID: <529EAC61.5080207@gmail.com>
Date: Tue, 03 Dec 2013 21:15:29 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Arnaldo Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 6/8] perf sched: Introduce timehist command
References: <1384806771-2945-1-git-send-email-dsahern@gmail.com>	<1384806771-2945-7-git-send-email-dsahern@gmail.com>	<CAM9d7cg4t_HD-225GawXnUHXG1D-f91ZDS_xsfy19baHSM624w@mail.gmail.com>	<529768D3.1000507@gmail.com> <87k3fsowwe.fsf@sejong.aot.lge.com> <5297F4D6.3070408@gmail.com>
In-Reply-To: <5297F4D6.3070408@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/13, 6:58 PM, David Ahern wrote:
> On 11/28/13, 5:48 PM, Namhyung Kim wrote:
>> Do we really need to look up the callchain to find out an idle thread?
---8<---
>> It seems every idle/swapper thread for each cpu has a pid of 0.
>

I knew I had this code in there for a reason....

Older kernels (e.g., RHEL6) show init as the idle task for cpus != 0. 
So, to be robust across kernel versions the idle check needs to do more 
than just looking at the swapper thread as the incoming or outgoing 
task. It needs to walk the first few frames of the callstack looking for 
a known idle symbol.

David

