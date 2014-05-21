Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbaEUNQX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 09:16:23 -0400
Received: from service87.mimecast.com ([91.220.42.44]:43030 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbaEUNQU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 09:16:20 -0400
Message-ID: <537CA726.5060909@arm.com>
Date: Wed, 21 May 2014 14:16:22 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>
CC: Sudeep Holla <sudeep.holla@arm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <Arvind.Chauhan@arm.com>,
        "inderpal.s@samsung.com" <inderpal.s@samsung.com>,
        "nm@ti.com" <nm@ti.com>,
        "chander.kashyap@linaro.org" <chander.kashyap@linaro.org>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "len.brown@intel.com" <len.brown@intel.com>
Subject: Re: [PATCH V2 1/7] opp: remove -ENOSYS from dummy implementation
 of of_init_opp_table()
References: <cover.1400670427.git.viresh.kumar@linaro.org> <ddf99132a9b2a6aabef61cba20fffbbf56ec0985.1400670427.git.viresh.kumar@linaro.org>
In-Reply-To: <ddf99132a9b2a6aabef61cba20fffbbf56ec0985.1400670427.git.viresh.kumar@linaro.org>
X-OriginalArrivalTime: 21 May 2014 13:16:17.0567 (UTC) FILETIME=[D96DEAF0:01CF74F6]
X-MC-Unique: 114052114161711901
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

$subject perhaps should be "replace/remove -EINVAL.." instead of "remove
-ENOSYS ..."

On 21/05/14 12:09, Viresh Kumar wrote:
> When any of CONFIG_PM_OPP or CONFIG_OF isn't enabled we have a dummy
> implementation of of_init_opp_table() routine, it returns -EINVAL currently.
> -EINVAL can be returned from other places within the real implementations of
> of_init_opp_table() and so caller wouldn't be able to differentiate between
> those two cases.
>
> Make it return -ENOSYS instead for better handling.
>
[Nit] How about "it's more appropriate to return -ENOSYS as since the function
is not implemented" ?

Otherwise it looks fine to me.
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>

> Suggested-by: Sudeep Holla <sudeep.holla@arm.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>   include/linux/pm_opp.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/linux/pm_opp.h b/include/linux/pm_opp.h
> index 0330217..6668150 100644
> --- a/include/linux/pm_opp.h
> +++ b/include/linux/pm_opp.h
> @@ -112,7 +112,7 @@ int of_init_opp_table(struct device *dev);
>   #else
>   static inline int of_init_opp_table(struct device *dev)
>   {
> -	return -EINVAL;
> +	return -ENOSYS;
>   }
>   #endif
>
>

