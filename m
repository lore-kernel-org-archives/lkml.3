Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934097AbaEFGX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 02:23:57 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:38174 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933946AbaEFGX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 02:23:56 -0400
Date: Tue, 6 May 2014 08:23:50 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: jolsa@redhat.com, a.p.zijlstra@chello.nl, paulus@samba.org,
        acme@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] perf tools: Clarify the output of perf sched map.
Message-ID: <20140506062350.GA25208@gmail.com>
References: <20140505183736.GA15038@gmail.com>
 <1399336807-10698-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399336807-10698-1-git-send-email-yangds.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dongsheng Yang <yangds.fnst@cn.fujitsu.com> wrote:

> Example:
>               *A0       228836.978985 secs A0 => perf:23032
>           * .  A0       228836.979016 secs . => swapper:0
>             . *B0       228836.979099 secs B0 => migration/3:22
>   *A0       .  B0       228836.979115 secs
>    A0       . * .       228836.979115 secs
>    A0     *C0   .       228836.979225 secs C0 => ksoftirqd/2:18
>    A0     *D0   .       228836.979236 secs D0 => rcu_sched:7

One final thing I noticed, please keep vertical alignment intact, i.e. 
print:

>               *A0       228836.978985 secs A0 => perf:23032
>           * .  A0       228836.979016 secs .  => swapper:0
>             . *B0       228836.979099 secs B0 => migration/3:22

(note the extra space and how the arrows now align vertically.)

In the code this could be done via:

> +			sched_in->shortname[0] = ' ';
> +			sched_in->shortname[1] = '.';

Thanks,

	Ingo
