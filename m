Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105Ab3FYPKt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 11:10:49 -0400
Received: from multi.imgtec.com ([194.200.65.239]:46712 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446Ab3FYPKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 11:10:48 -0400
Message-ID: <51C9B2F6.6020109@imgtec.com>
Date: Tue, 25 Jun 2013 16:10:46 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 15/32] metag: delete __cpuinit usage from all metag files
References: <1372102237-8757-1-git-send-email-paul.gortmaker@windriver.com> <1372102237-8757-16-git-send-email-paul.gortmaker@windriver.com>
In-Reply-To: <1372102237-8757-16-git-send-email-paul.gortmaker@windriver.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_06_25_16_10_47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/06/13 20:30, Paul Gortmaker wrote:
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
> This removes all the arch/metag uses of the __cpuinit macros from
> all C files.  Currently metag does not have any __CPUINIT used in
> assembly files.
> 
> [1] https://lkml.org/lkml/2013/5/20/589
> 
> Cc: James Hogan <james.hogan@imgtec.com>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Acked-by: James Hogan <james.hogan@imgtec.com>

Thanks
James

