Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384Ab3HFITX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 04:19:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:44348 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753315Ab3HFITV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 04:19:21 -0400
X-IronPort-AV: E=Sophos;i="4.89,825,1367942400"; 
   d="scan'208";a="8131747"
Message-ID: <5200B185.9010402@cn.fujitsu.com>
Date: Tue, 06 Aug 2013 16:19:17 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Xishi Qiu <qiuxishi@huawei.com>
CC: ebiederm@xmission.com, kexec@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kexec: remove unnecessary return
References: <5200AE50.2010108@huawei.com>
In-Reply-To: <5200AE50.2010108@huawei.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/06 16:17:56,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/06 16:17:56
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013/8/6 16:05, Xishi Qiu 写道:
> Code can not run here forever, so remove the unnecessary return.
> 
> Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
> ---
>  kernel/kexec.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index 59f7b55..c14e3ea 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -1477,8 +1477,6 @@ static int __init __parse_crashkernel(char *cmdline,
>  	else
>  		return parse_crashkernel_simple(ck_cmdline, crash_size,
>  				crash_base);
> -
> -	return 0;
>  }
>  
>  /*
> 

Hi Xishi,

change

1474         if (first_colon && (!first_space || first_colon < first_space))
1475                 return parse_crashkernel_mem(ck_cmdline, system_ram,
1476                                 crash_size, crash_base);
1477         else
1478                 return parse_crashkernel_simple(ck_cmdline, crash_size,
1479                                 crash_base);
1480 
1481         return 0;

to

1474         if (first_colon && (!first_space || first_colon < first_space))
1475                 return parse_crashkernel_mem(ck_cmdline, system_ram,
1476                                 crash_size, crash_base);

1478         return parse_crashkernel_simple(ck_cmdline, crash_size, crash_base);

seems better.
-- 
Thanks.
Zhang Yanfei
