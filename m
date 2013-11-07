Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab3KGB3I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 20:29:08 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:39519 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752053Ab3KGB3G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 20:29:06 -0500
X-IronPort-AV: E=Sophos;i="4.93,647,1378828800"; 
   d="scan'208";a="8966375"
Message-ID: <527AE9A5.8080003@cn.fujitsu.com>
Date: Thu, 07 Nov 2013 09:15:17 +0800
From: Duan Jiong <duanj.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>, kernel@pengutronix.de,
        linux@arm.linux.org.uk, a.zummo@towertech.it, airlied@linux.ie
CC: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        Thierry Reding <treding@nvidia.com>,
        =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>
Subject: Re: [PATCH] drm/tegra: replace IS_ERR and PTR_ERR with PTR_ERR_OR_ZERO
References: <1383724435-15380-1-git-send-email-duanj.fnst@cn.fujitsu.com> <527A7333.9090409@wwwdotorg.org>
In-Reply-To: <527A7333.9090409@wwwdotorg.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/07 09:15:22,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/07 09:27:09
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年11月07日 00:49, Stephen Warren 写道:
> On 11/06/2013 12:53 AM, Duan Jiong wrote:
>> This patch fixes coccinelle error regarding usage of IS_ERR and
>> PTR_ERR instead of PTR_ERR_OR_ZERO.
> 
>> diff --git a/drivers/gpu/drm/tegra/gem.c b/drivers/gpu/drm/tegra/gem.c
> 
>> @@ -199,10 +199,7 @@ int tegra_bo_dumb_create(struct drm_file *file, struct drm_device *drm,
>>  
>>  	bo = tegra_bo_create_with_handle(file, drm, args->size, 0,
>>  					 &args->handle);
>> -	if (IS_ERR(bo))
>> -		return PTR_ERR(bo);
>> -
>> -	return 0;
>> +	return PTR_ERR_OR_ZERO(bo);
>>  }
> 
> I suppose that's fine, although I wonder if it'll cause churn should we
> ever need to add code to the tail end of the function.
> 
> BTW, why were all the similar patches that had nothing to do with Tegra
> sent to the linux-tegra@ mailing list? You also didn't CC the
> maintainers of drivers/gpu/drm/tegra/ on this patch. Plus this patch has
> nothing to do with the rtc-linux@ mailing list.

I'm sorry for that. i just get the maintainers and the mail lists by the script
get_maintainer.pl.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

