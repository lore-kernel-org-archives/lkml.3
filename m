Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751202Ab3FYEh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 00:37:59 -0400
Received: from us02smtp1.synopsys.com ([198.182.60.75]:48471 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab3FYEh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 00:37:58 -0400
Message-ID: <51C91E9A.9040006@synopsys.com>
Date: Tue, 25 Jun 2013 10:07:46 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/32] arc: delete __cpuinit usage from all arc files
References: <1372102237-8757-1-git-send-email-paul.gortmaker@windriver.com> <1372102237-8757-11-git-send-email-paul.gortmaker@windriver.com>
In-Reply-To: <1372102237-8757-11-git-send-email-paul.gortmaker@windriver.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.141]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2013 01:00 AM, Paul Gortmaker wrote:
> The __cpuinit type of throwaway sections might have made sense
> some time ago when RAM was more constrained, but now the savings
> do not offset the cost and complications.  For example, the fix in
> commit 5e427ec2d0 ("x86: Fix bit corruption at CPU resume time")
> is a good example of the nasty type of bugs that can be created
> with improper use of the various __init prefixes.
>
> After a discussion on LKML[1] it was decided that cpuinit should go
> the way of devinit and be phased out.  Once all the users are gone,
> we can then finally remove the macros themselves from linux/init.h.
>
> Note that some harmless section mismatch warnings may result, since
> notify_cpu_starting() and cpu_up() are arch independent (kernel/cpu.c)
> are flagged as __cpuinit  -- so if we remove the __cpuinit from
> arch specific callers, we will also get section mismatch warnings.
> As an intermediate step, we intend to turn the linux/init.h cpuinit
> content into no-ops as early as possible, since that will get rid
> of these warnings.  In any case, they are temporary and harmless.
>
> This removes all the arch/arc uses of the __cpuinit macros from
> all C files.  Currently arc does not have any __CPUINIT used in
> assembly files.
>
> [1] https://lkml.org/lkml/2013/5/20/589
>
> Cc: Vineet Gupta <vgupta@synopsys.com>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Applied to ARC for-curr (for 3.11)

Thx a bunch,
-Vineet
