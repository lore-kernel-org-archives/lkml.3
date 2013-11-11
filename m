Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab3KKJh4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 04:37:56 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:64031 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab3KKJhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 04:37:51 -0500
Date: Mon, 11 Nov 2013 10:37:47 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf record: Delete file if a failure occurs writing the
 perf data file
Message-ID: <20131111093747.GA14810@gmail.com>
References: <1383928906-31470-1-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1383928906-31470-1-git-send-email-dsahern@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> If perf fails to write data to the data file (e.g., ENOSPC error) it fails
> with the message:
>   failed to write perf data, error: No space left on device
> 
> and stops — killing the workload too. The file is an unknown state. 
> Trying to read it (e.g., perf report) fails with a SIGBUS error.

Ouch - guys please first investiage that SIGBUS, we should not behave 
unexpectedly on _any_ (read: random) perf.data file contents. The SIGBUS 
likely suggests that the parsing isn't robust enough.

> Fix by deleting the file on a failure.

That only works around the issue - if the same data file is produced by 
some other method (or maliciously) then perf report will still SIGBUS ...

Thanks,

	Ingo
