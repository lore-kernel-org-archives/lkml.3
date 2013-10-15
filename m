Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430Ab3JOIRq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 04:17:46 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:61718 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab3JOIRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 04:17:44 -0400
X-AuditID: 9c93017e-b7c81ae000002d4e-66-525cfa266e76
From: Namhyung Kim <namhyung@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: David Ahern <dsahern@gmail.com>, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf record: mmap output file - v2
References: <1381805731-10398-1-git-send-email-dsahern@gmail.com>
	<20131015060200.GA3866@gmail.com> <8738o3au2g.fsf@sejong.aot.lge.com>
	<20131015072540.GE24584@gmail.com>
Date: Tue, 15 Oct 2013 17:17:42 +0900
In-Reply-To: <20131015072540.GE24584@gmail.com> (Ingo Molnar's message of
	"Tue, 15 Oct 2013 09:25:40 +0200")
Message-ID: <87ppr79cd5.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Oct 2013 09:25:40 +0200, Ingo Molnar wrote:
> * Namhyung Kim <namhyung@kernel.org> wrote:
>> No, st_size is bigger than rec->bytes_written due to the 
>> perf_file_header which is written without updating rec->bytes_written.
>
> Since all this is code that executes once during __cmd_record(), is this 
> all about the header writeout?
>
> That is what confused me about the stat() call and that's messy really: we 
> are the ones who write the file header, we have a very good idea about how 
> many bytes we wrote to the file! It should be entirely unnecessary to lose 
> that information and then execute a system call to recover that 
> information...

Right, I think session->header.data_offset has the info already.

Thanks,
Namhyung
