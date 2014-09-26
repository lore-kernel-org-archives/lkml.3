Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134AbaIZTZU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 15:25:20 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:56789 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534AbaIZTZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 15:25:18 -0400
Message-ID: <5425BD94.4030006@gmail.com>
Date: Fri, 26 Sep 2014 13:25:08 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Pawel Moll <pawel.moll@arm.com>, Namhyung Kim <namhyung@kernel.org>
CC: Richard Cochran <richardcochran@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] perf: Add sampling of the raw monotonic clock
References: <1411491787-25938-1-git-send-email-pawel.moll@arm.com>	 <1411491787-25938-2-git-send-email-pawel.moll@arm.com>	 <87sijhk21x.fsf@sejong.aot.lge.com> <1411642198.4768.30.camel@hornet>	 <8738bekith.fsf@sejong.aot.lge.com>  <1411729103.3852.19.camel@hornet>	 <1411742306.1669.6.camel@leonhard> <1411743959.3852.45.camel@hornet>
In-Reply-To: <1411743959.3852.45.camel@hornet>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/26/14, 9:05 AM, Pawel Moll wrote:
> To do the correlation you need both timestamps to be "taken"
> simultaneously:
>
>          perf event     user event
>         -----O--------------+-------------O------> t_mono
>              :              |             :
>              :              V             :
>         -----O----------------------------O------> t_perf
>
> Of course it's not possible get both values literally at the same time,
> but placing them in a atomic context a couple of instructions from each
> other still gives pretty good results. The larger this distance is, the

An early patchset on this topic added the realtime clock as an event and 
an ioctl was used to push a sample into the event stream. In that case 
you have wall clock and perf-clock samples taken in the same kernel 
context and about as close together as you can get.

https://lkml.org/lkml/2011/2/27/158
https://lkml.org/lkml/2011/2/27/159

David
