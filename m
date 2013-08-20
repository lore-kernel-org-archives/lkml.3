Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab3HTEHJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 00:07:09 -0400
Received: from mail7.windriver.com ([128.224.252.3]:63333 "EHLO
	mail7.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086Ab3HTEHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 00:07:06 -0400
X-Greylist: delayed 6215 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Aug 2013 00:07:06 EDT
Message-ID: <5212D2B8.6090602@windriver.com>
Date: Tue, 20 Aug 2013 10:21:44 +0800
From: "Li.Wang" <Li.Wang@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: remove redundant local_irq_enable() after cpuidle_idle_call()
References: <1376446800-3778-1-git-send-email-li.wang@windriver.com>
In-Reply-To: <1376446800-3778-1-git-send-email-li.wang@windriver.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.162.186]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Anybody help me review this?

Thanks,
LiWang.

On 08/14/2013 10:20 AM, Li Wang wrote:
> When cpuidle_idle_call() return 0, it shows that linux system is using
> idle framwork driver. Now, local irq has already been enabled in
> cpuidle_idle_call(). So, it need not enable local irq again, when return 0.
>
> The code is introduced by commit:
> 97a5b81fa4d3a11dcdf224befc577f2e0abadc0b ("x86: Fix idle consolidation fallout")
> In that defect, it does not use idle framework driver, just call amd_e400_idle().
> That problem is that amd_e400_idle() does not enable irq.
>
> Signed-off-by: Li Wang <li.wang@windriver.com>
> ---
>   arch/x86/kernel/process.c |    2 --
>   1 file changed, 2 deletions(-)
>
> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> index 83369e5..cb55ee4 100644
> --- a/arch/x86/kernel/process.c
> +++ b/arch/x86/kernel/process.c
> @@ -300,8 +300,6 @@ void arch_cpu_idle(void)
>   {
>   	if (cpuidle_idle_call())
>   		x86_idle();
> -	else
> -		local_irq_enable();
>   }
>   
>   /*

