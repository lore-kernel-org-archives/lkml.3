Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071AbaLHKZl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 05:25:41 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:58333 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040AbaLHKZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 05:25:38 -0500
Date: Mon, 8 Dec 2014 11:25:33 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Rabin Vincent <rabin.vincent@axis.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-kernel@vger.kernel.org, rabin@rab.in,
        Rabin Vincent <rabinv@axis.com>
Subject: Re: [PATCH 3/3] perf: bench: fix memcpy/memset output
Message-ID: <20141208102533.GB19134@gmail.com>
References: <1417535441-3965-1-git-send-email-rabin.vincent@axis.com>
 <1417535441-3965-3-git-send-email-rabin.vincent@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417535441-3965-3-git-send-email-rabin.vincent@axis.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rabin Vincent <rabin.vincent@axis.com> wrote:

> The memcpy and memset benchmarks return bogus results when iterations >
> 0 because the iterations value is not taken into account when
> calculating the final result:
> 
>  $ perf bench mem memset --only-prefault --length 1GB --iterations 1
>  # Running 'mem/memset' benchmark:
>  # Copying 1GB Bytes ...
> 
>        20.798669 GB/Sec (with prefault)
>  $ perf bench mem memset --only-prefault --length 1GB --iterations 10
>  # Running 'mem/memset' benchmark:
>  # Copying 1GB Bytes ...
> 
>         2.086576 GB/Sec (with prefault)
>  $ perf bench mem memset --only-prefault --length 1GB --iterations 100
>  # Running 'mem/memset' benchmark:
>  # Copying 1GB Bytes ...
> 
>       212.840917 MB/Sec (with prefault)
> 
> Fix this.
> 
> Signed-off-by: Rabin Vincent <rabin.vincent@axis.com>

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
