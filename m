Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481AbaBGUjy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 15:39:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500AbaBGUjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 15:39:53 -0500
Message-ID: <52F54484.8000009@redhat.com>
Date: Fri, 07 Feb 2014 15:39:32 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>
CC: linux-kernel@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Thomas Renninger <trenn@suse.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Alan Cox <alan@linux.intel.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] tools, cpupower Fix error condition in cmd_freq_set()
References: <1391799353-19517-1-git-send-email-prarit@redhat.com>
In-Reply-To: <1391799353-19517-1-git-send-email-prarit@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/07/2014 01:55 PM, Prarit Bhargava wrote:
> On a system which has only 4.00GHz set as the only available frequency,
> 
> [root@amd-pike-05 ~]# cpupower frequency-info
> <snip>
>   current policy: frequency should be within 4.00 GHz and 4.00 GHz.
>                   The governor "userspace" may decide which speed to use
>                   within this range.
> <snip>
> 
> setting the frequency to 2.8GHz does not return an error.
> 
> [root@amd-pike-05 ~]# cpupower frequency-set --freq 2800MHz
> Setting cpu: 0
> Setting cpu: 1
> Setting cpu: 2
> Setting cpu: 3
> Setting cpu: 4
> Setting cpu: 5
> Setting cpu: 6
> Setting cpu: 7
> [root@amd-pike-05 ~]#
> 
> The frequency set error should stop with an error message after the first
> failure.  Fix the error return in cmd_freq_set() to read errors as less
> than zero.
> 
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> Cc: Dominik Brodowski <linux@dominikbrodowski.net>
> Cc: Thomas Renninger <trenn@suse.de>
> Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
> Cc: Alan Cox <alan@linux.intel.com>
> Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
> ---
>  tools/power/cpupower/utils/cpufreq-set.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/power/cpupower/utils/cpufreq-set.c b/tools/power/cpupower/utils/cpufreq-set.c
> index a416de8..e5f78623 100644
> --- a/tools/power/cpupower/utils/cpufreq-set.c
> +++ b/tools/power/cpupower/utils/cpufreq-set.c
> @@ -320,7 +320,7 @@ int cmd_freq_set(int argc, char **argv)
>  
>  		printf(_("Setting cpu: %d\n"), cpu);
>  		ret = do_one_cpu(cpu, &new_pol, freq, policychange);
> -		if (ret)
> +		if (ret < 0)

Self-nack ... this won't work.

P.
>  			break;
>  	}
>  
