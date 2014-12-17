Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751277AbaLQQ1F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 11:27:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50860 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbaLQQ1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 11:27:03 -0500
From: Thomas Renninger <trenn@suse.de>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 2/2] Fix no idle state information return value
Date: Wed, 17 Dec 2014 17:27:01 +0100
Message-ID: <1494685.HIEjl338tW@skinner>
User-Agent: KMail/4.14.2 (Linux/3.16.6-2-desktop; KDE/4.14.2; x86_64; ; )
In-Reply-To: <1418565998-3701-3-git-send-email-prarit@redhat.com>
References: <1418565998-3701-1-git-send-email-prarit@redhat.com> <1418565998-3701-3-git-send-email-prarit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, December 14, 2014 09:06:38 AM Prarit Bhargava wrote:
> sysfs_get_idlestate_count() returns an unsigned int.  Returning -ENODEV
> is not the right thing to do here, and in any case is handled the same
> way as if there are no states found.
Yep, returning zero states instead of an error code makes a lot sense
here.

> 
> Cc: Thomas Renninger <trenn@suse.de>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Acked-by: Thomas Renninger <trenn@suse.de>

Thanks!

    Thomas

> ---
>  tools/power/cpupower/utils/helpers/sysfs.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/power/cpupower/utils/helpers/sysfs.c
> b/tools/power/cpupower/utils/helpers/sysfs.c index 09afe5d..4e8fe2c 100644
> --- a/tools/power/cpupower/utils/helpers/sysfs.c
> +++ b/tools/power/cpupower/utils/helpers/sysfs.c
> @@ -361,7 +361,7 @@ unsigned int sysfs_get_idlestate_count(unsigned int cpu)
> 
>  	snprintf(file, SYSFS_PATH_MAX, PATH_TO_CPU "cpuidle");
>  	if (stat(file, &statbuf) != 0 || !S_ISDIR(statbuf.st_mode))
> -		return -ENODEV;
> +		return 0;
> 
>  	snprintf(file, SYSFS_PATH_MAX, PATH_TO_CPU "cpu%u/cpuidle/state0", 
cpu);
>  	if (stat(file, &statbuf) != 0 || !S_ISDIR(statbuf.st_mode))

