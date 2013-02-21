Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab3BUUxk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 15:53:40 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:60780 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246Ab3BUUxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 15:53:39 -0500
MIME-Version: 1.0
In-Reply-To: <1361479940-8078-1-git-send-email-vgupta@synopsys.com>
References: <CAE9FiQV20uj_kOViCOd4gdPFuAf28fEbjhGCrzNogQWx5T3+zg@mail.gmail.com>
	<1361479940-8078-1-git-send-email-vgupta@synopsys.com>
Date: Thu, 21 Feb 2013 12:53:38 -0800
X-Google-Sender-Auth: GzcTChrVeRvC6NUY0EpQQAqdc1s
Message-ID: <CAOS58YPUSmsj2OUNGH7-0709R7MrzWS1dMwCykL0tGsnpyG+ig@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] memblock: add assertion for zero allocation alignment
From: Tejun Heo <tj@kernel.org>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 12:52 PM, Vineet Gupta
<Vineet.Gupta1@synopsys.com> wrote:
> This came to light when calling memblock allocator from arc port (for
> copying flattended DT). If a "0" alignment is passed, the allocator
> round_up() call incorrectly rounds up the size to 0.
>
> round_up(num, alignto) => ((num - 1) | (alignto -1)) + 1
>
> While the obvious allocation failure causes kernel to panic, it is
> better to warn the caller to fix the code.
>
> Tejun suggested that instead of BUG_ON(!align) - which might be
> ineffective due to pending console init and such, it is better to
> WARN_ON, and continue the boot with a reasonable default align.
>
> Caller passing @size need not be handled similarly as the subsequent
> panic will indicate that anyhow.
>
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
