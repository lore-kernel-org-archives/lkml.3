Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab3KGQGN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 11:06:13 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:41805 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476Ab3KGQGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 11:06:10 -0500
Message-ID: <527BBA6E.2040609@gmail.com>
Date: Thu, 07 Nov 2013 09:06:06 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org, jolsa@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 4/4] perf record: mmap output file - v3
References: <1383763297-27066-1-git-send-email-dsahern@gmail.com> <1383763297-27066-5-git-send-email-dsahern@gmail.com> <20131107080313.GB31926@gmail.com>
In-Reply-To: <20131107080313.GB31926@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/7/13, 1:03 AM, Ingo Molnar wrote:
>
> * David Ahern <dsahern@gmail.com> wrote:
>
>> +--out-pages=::
>> +	Number of pages to mmap while writing data to file (must be a power of two).
>> +	Specification can be appended with unit character - B/K/M/G. The
>> +	size is rounded up to have nearest pages power of two value.
>
> So why doesn't the code automatically round down (or up) to the next power
> of 2 limit? We use computers to solve problems, not to introduce
> additional ones! ;-)

sure. It reuses perf_evlist__parse_mmap_pages which rounds so I will 
update the description.



>> +static int do_mmap_output(struct perf_record *rec, void *buf, size_t size)
>> +{
>> +	struct perf_data_file *file = &rec->file;
>> +	u64 remaining;
>> +	off_t offset;
>> +
>> +	if (rec->mmap_addr == NULL) {
>> +do_mmap:
>> +		offset = rec->session->header.data_offset + rec->bytes_written;
>> +		if (offset < (ssize_t) rec->mmap_out_size) {
>> +			rec->mmap_offset = offset;
>> +			offset = 0;
>> +		} else
>> +			rec->mmap_offset = 0;
>
> (Nit: unbalanced curly braces.)

I believe checkpatch.pl complains, but will add.


>> +	OPT_CALLBACK(0, "out-pages", &record.mmap_out_pages, "pages",
>> +		     "number of pages to use for output chunks.",
>> +		     perf_evlist__parse_mmap_pages),
>
> Nit: the short explanation here doesn't mention it at all to the user that
> these 'out pages' are used in mmap.
>
> Shouldn't it say:
>
> 		     "number of pages mmap()ed for output chunks."
>
> ?
>
> Also, what happens if a user sets it to zero?

I was intending to use that as a way of disabling the mmap output - go 
back to write(). I'll update the documentation.

Ack on all of the other comments.

David

