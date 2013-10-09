Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab3JINrA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 09:47:00 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:34838 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab3JINq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 09:46:59 -0400
Message-ID: <52555E4B.4020704@gmail.com>
Date: Wed, 09 Oct 2013 07:46:51 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf record: mmap output file - RFC
References: <1379901959-5285-1-git-send-email-dsahern@gmail.com> <20131009133331.GC5459@krava.redhat.com>
In-Reply-To: <20131009133331.GC5459@krava.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/9/13 7:33 AM, Jiri Olsa wrote:
>> +
>> +	if (size > remaining) {
>> +		memcpy(rec->mmap_addr + rec->mmap_offset, buf, remaining);
>> +		rec->bytes_written += remaining;
>> +
>> +		size -= remaining;
>> +		buf  += remaining;
>> +
>> +		msync(rec->mmap_addr, rec->mmap_size, MS_ASYNC);
>> +		munmap(rec->mmap_addr, rec->mmap_size);
>
> do we need msync call if munmap is called right away?

I was being overly cautious. I will remove it in v2.

David
