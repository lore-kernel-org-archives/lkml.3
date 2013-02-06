Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318Ab3BFOKF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 09:10:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41257 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752296Ab3BFOKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 09:10:01 -0500
Date: Wed, 6 Feb 2013 15:09:59 +0100
From: Michal Hocko <mhocko@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Axel Lin <axel.lin@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] da9030_battery: include notifier.h
Message-ID: <20130206140959.GE10254@dhcp22.suse.cz>
References: <1360142098-13124-1-git-send-email-mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1360142098-13124-1-git-send-email-mhocko@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ohh, I have just noticed that this could be introduced by "mm: break
circular include from linux/mmzone.h" in mm tree.
Adding Andrew to CC.

On Wed 06-02-13 10:14:58, Michal Hocko wrote:
> randconfig complains about:
> drivers/power/da9030_battery.c:113: error: field ‘nb’ has incomplete type
> 
> because there is no direct include for notifier.h which defines
> struct notifier_block.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> ---
>  drivers/power/da9030_battery.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/power/da9030_battery.c b/drivers/power/da9030_battery.c
> index 94762e6..e8c5a39 100644
> --- a/drivers/power/da9030_battery.c
> +++ b/drivers/power/da9030_battery.c
> @@ -22,6 +22,7 @@
>  
>  #include <linux/debugfs.h>
>  #include <linux/seq_file.h>
> +#include <linux/notifier.h>
>  
>  #define DA9030_FAULT_LOG		0x0a
>  #define DA9030_FAULT_LOG_OVER_TEMP	(1 << 7)
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Michal Hocko
SUSE Labs
