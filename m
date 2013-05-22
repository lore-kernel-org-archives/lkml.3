Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab3EVIpS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 04:45:18 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:64397 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407Ab3EVIpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 04:45:14 -0400
Message-ID: <519C8597.4090608@kernel.org>
Date: Wed, 22 May 2013 11:45:11 +0300
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [RFC 0/7] perf report/gtk: Add support for hierarchy view
References: <1369116878-12489-1-git-send-email-namhyung@kernel.org> <CAOJsxLETg8WMrX+gqYA03Bm4tAsgAKVgbH6aay=NS9L-WmKbpQ@mail.gmail.com> <87vc6c3iam.fsf@sejong.aot.lge.com>
In-Reply-To: <87vc6c3iam.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2013 10:26 AM, Namhyung Kim wrote:
> On Tue, 21 May 2013 10:04:05 +0300, Pekka Enberg wrote:
>> Hello,
>>
>> On Tue, May 21, 2013 at 9:14 AM, Namhyung Kim <namhyung@kernel.org> wrote:
>>> This patchset implements a new feature that collects hist entries in a
>>> hierachical manner.  That means lower-level entries are belonged to an
>>> upper-level entry.  The entry hierachy is built on the sort keys
>>> given, so users can set it whatever they want.  It only shows
>>> top-level entries first, and user can expand/collapse it dynamically.
>>>
>>> This is only implemented in --gtk currently, since it's well-matched
>>> to the GTK tree view widget and I didn't want to be bothered with the
>>> TUI browser code at this stage. :)
>>
>> Can use this infrastructure to support call-graphs in the GTK UI?
>
> Yes, I think it's doable.  I don't have an idea how to use both of the
> features at the same time though.  Anyway, I'll try to add support for
> callchains later.

So I think hierarchy view makes tons of sense but it needs to be 
orthogonal with call-graphs. Preferably in such a way that if you have 
both hierarchy view and call-graphs enabled, you can seamlessly drill 
down from process level all the way to call-graph leaf nodes.

			Pekka
