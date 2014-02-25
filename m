Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871AbaBYEya (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 23:54:30 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:58268 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbaBYEyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 23:54:08 -0500
Message-ID: <530C21E6.5020106@linux.vnet.ibm.com>
Date: Tue, 25 Feb 2014 10:23:58 +0530
From: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Cody P Schafer <cody@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Olof Johansson <olof@lixom.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Wang Dongsheng <dongsheng.wang@freescale.com>
CC: Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc: warn users of smt-snooze-delay that the API
 isn't there anymore
References: <1393028074-26797-1-git-send-email-cody@linux.vnet.ibm.com>
In-Reply-To: <1393028074-26797-1-git-send-email-cody@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022504-5564-0000-0000-00000C2F60FD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 22 February 2014 05:44 AM, Cody P Schafer wrote:
> /sys/devices/system/cpu/cpu*/smt-snooze-delay was converted into a NOP
> in commit 3fa8cad82b94d0bed002571bd246f2299ffc876b, and now does
> nothing. Add a pr_warn() to convince any users that they should stop
> using it.
> 
> The commit message from the removing commit notes that this
> functionality should move into the cpuidle driver, essentially by

Would prefer to cleanup the code since the functionality is moved,
instead of adding to it.

> adjusting target_residency to the specified value. At the moment,
> target_residency is not exposed by cpuidle's sysfs, so there isn't a
> drop in replacement for this.
> 
> Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
> ---
>  arch/powerpc/kernel/sysfs.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/powerpc/kernel/sysfs.c b/arch/powerpc/kernel/sysfs.c
> index 97e1dc9..84097b4 100644
> --- a/arch/powerpc/kernel/sysfs.c
> +++ b/arch/powerpc/kernel/sysfs.c
> @@ -50,6 +50,9 @@ static ssize_t store_smt_snooze_delay(struct device *dev,
>  	if (ret != 1)
>  		return -EINVAL;
>  
> +	pr_warn_ratelimited("%s (%d): /sys/devices/system/cpu/cpu%d/smt-snooze-delay is deprecated and is a NOP\n",
> +		  current->comm, task_pid_nr(current), cpu->dev.id);
> +
>  	per_cpu(smt_snooze_delay, cpu->dev.id) = snooze;
>  	return count;
>  }
> @@ -60,6 +63,9 @@ static ssize_t show_smt_snooze_delay(struct device *dev,
>  {
>  	struct cpu *cpu = container_of(dev, struct cpu, dev);
>  
> +	pr_warn_ratelimited("%s (%d): /sys/devices/system/cpu/cpu%d/smt-snooze-delay is deprecated and is a NOP\n",
> +		  current->comm, task_pid_nr(current), cpu->dev.id);
> +
>  	return sprintf(buf, "%ld\n", per_cpu(smt_snooze_delay, cpu->dev.id));
>  }
>  
> 

