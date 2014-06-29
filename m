Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbaF2Qu0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 12:50:26 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:36496 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbaF2QuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 12:50:25 -0400
Message-ID: <53B043D0.4040009@gmail.com>
Date: Sun, 29 Jun 2014 10:50:24 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 05/18] perf tools: Add ordered_events_(get|put) interface
References: <1403103539-16807-1-git-send-email-jolsa@kernel.org> <1403103539-16807-6-git-send-email-jolsa@kernel.org> <53ADF8FC.5030604@gmail.com> <20140629163933.GA1407@krava.redhat.com>
In-Reply-To: <20140629163933.GA1407@krava.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/29/14, 10:39 AM, Jiri Olsa wrote:
> On Fri, Jun 27, 2014 at 05:06:36PM -0600, David Ahern wrote:
>> On 6/18/14, 8:58 AM, Jiri Olsa wrote:
>>>
>>> +static struct ordered_event*
>>> +ordered_events_get(struct ordered_events_queue *q, u64 timestamp)
>>> +{
>>> +	struct ordered_event *new;
>>> +
>>> +	new = alloc_event(q);
>>> +	if (new) {
>>> +		new->timestamp = timestamp;
>>> +		queue_event(q, new);
>>> +	}
>>> +
>>> +	return new;
>>> +}
>>
>> The _get name does not really correlate with what is happening -- ie.,
>> allocate a new event and add it to the queue. There is no reference taken
>> either.
>
> ook.. so how about ordered_events_alloc ordered_events_free
>
>>
>>> +
>>> +static void
>>> +ordered_event_put(struct ordered_events_queue *q, struct ordered_event *iter)
>>> +{
>>> +	list_del(&iter->list);
>>> +	list_add(&iter->list, &q->cache);
>>> +	q->nr_events--;
>>> +}
>>
>> Similarly here with the _put. In this case the function is moving the event
>> from one list to another. And how about something else for the name besides
>> iter -- oe, or oevent?
>
> how about 'event' ?

Already a heavily used keyword in perf, that's why I was thinking oe or 
oevent -- besides it is a struct ordered_event not an event.

The bigger thing to me with this patch is the _get/_put names.

David

