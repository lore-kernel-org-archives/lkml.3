Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934284AbaEFHXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 03:23:14 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:56064 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934167AbaEFHXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 03:23:09 -0400
Date: Tue, 6 May 2014 09:23:04 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: jolsa@redhat.com, a.p.zijlstra@chello.nl, paulus@samba.org,
        acme@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] perf tools: Clarify the output of perf sched map.
Message-ID: <20140506072304.GA25402@gmail.com>
References: <20140506062350.GA25208@gmail.com>
 <1399354741-19522-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399354741-19522-1-git-send-email-yangds.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dongsheng Yang <yangds.fnst@cn.fujitsu.com> wrote:

> From: Dongsheng <yangds.fnst@cn.fujitsu.com>
> 
> In output of perf sched map, any shortname of thread will be explained
> at the first time when it appear.
> 
> Example:
>               *A0       228836.978985 secs A0 => perf:23032
>           *.   A0       228836.979016 secs B0 => swapper:0
>            .  *C0       228836.979099 secs C0 => migration/3:22
>   *A0      .   C0       228836.979115 secs
>    A0      .  *.        228836.979115 secs
> 
> But B0, which is explained as swapper:0 did not appear in the
> left part of output. Instead, we use '.' as the shortname of
> swapper:0. So the comment of "B0 => swapper:0" is not easy to
> understand.
> 
> This patch clarify the output of perf sched map with not allocating
> one letter-number shortname for swapper:0 and print ". => swapper:0"
> as the explaination for swapper:0.
> 
> Example:
>               *A0       228836.978985 secs A0 => perf:23032
>           * .  A0       228836.979016 secs .  => swapper:0
>             . *B0       228836.979099 secs B0 => migration/3:22
>   *A0       .  B0       228836.979115 secs
>    A0       . * .       228836.979115 secs
>    A0     *C0   .       228836.979225 secs C0 => ksoftirqd/2:18
>    A0     *D0   .       228836.979236 secs D0 => rcu_sched:7
> 
> Signed-off-by: Dongsheng <yangds.fnst@cn.fujitsu.com>
> Acked-by: Ingo Molnar <mingo@kernel.org>

Looks good to me, thanks!

	Ingo
