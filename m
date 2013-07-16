Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933068Ab3GPQNT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 12:13:19 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:56661 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932652Ab3GPQNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 12:13:17 -0400
Date: Tue, 16 Jul 2013 18:13:11 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] nohz: fix compile warning in tick_nohz_init()
Message-ID: <20130716161310.GC17900@somewhere.redhat.com>
References: <1373948327.15106.3.camel@ThinkPad-T5421>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373948327.15106.3.camel@ThinkPad-T5421>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 12:18:47PM +0800, Li Zhong wrote:
> cpu is not used after commit 5b8621a68fdcd2baf1d3b413726f913a5254d46a
> 
> Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>

Applied, thanks!

> ---
>  kernel/time/tick-sched.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index e80183f..8145860 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -343,8 +343,6 @@ static int tick_nohz_init_all(void)
>  
>  void __init tick_nohz_init(void)
>  {
> -	int cpu;
> -
>  	if (!have_nohz_full_mask) {
>  		if (tick_nohz_init_all() < 0)
>  			return;
> 
> 
