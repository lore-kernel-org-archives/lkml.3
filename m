Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759493AbaD3Vjd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 17:39:33 -0400
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:33790 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbaD3Vjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 17:39:31 -0400
Message-ID: <1398893412.1789.48.camel@misato.fc.hp.com>
Subject: Re: [PATCH v4 4/5] x86: log error on secondary CPU wakeup failure
 at ERR level
From: Toshi Kani <toshi.kani@hp.com>
To: Igor Mammedov <imammedo@redhat.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, bp@suse.de,
        paul.gortmaker@windriver.com, JBeulich@suse.com, prarit@redhat.com,
        drjones@redhat.com, riel@redhat.com, gong.chen@linux.intel.com,
        andi@firstfloor.org, lenb@kernel.org, rjw@rjwysocki.net,
        linux-acpi@vger.kernel.org
Date: Wed, 30 Apr 2014 15:30:12 -0600
In-Reply-To: <1397488277-14865-5-git-send-email-imammedo@redhat.com>
References: <1397488277-14865-1-git-send-email-imammedo@redhat.com>
	 <1397488277-14865-5-git-send-email-imammedo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-14 at 17:11 +0200, Igor Mammedov wrote:
> If system is running without debug level logging,
> it will not log error if do_boot_cpu() failed to
> wakeup AP. It may lead to silent AP bringup
> failures at boot time.
> Change message level to KERN_ERR to make error
> visible to user as it's done on other architectures.
> 
> Signed-off-by: Igor Mammedov <imammedo@redhat.com>
> ---
>  arch/x86/kernel/smpboot.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index 2988f69..ae2fd97 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -918,7 +918,7 @@ int native_cpu_up(unsigned int cpu, struct task_struct *tidle)
>  
>  	err = do_boot_cpu(apicid, cpu, tidle);
>  	if (err) {
> -		pr_debug("do_boot_cpu failed %d\n", err);
> +		pr_err("do_boot_cpu failed(%d) to wakeup CPU#%u\n", err, cpu);
>  		return -EIO;
>  	}
>  

Looks good.

Acked-by: Toshi Kani <toshi.kani@hp.com>

I will review patch 5/5 later (probably tomorrow).
Thanks,
-Toshi

