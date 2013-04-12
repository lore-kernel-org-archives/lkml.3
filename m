Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab3DLDyn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 23:54:43 -0400
Received: from sjdciscan02.udc.trendmicro.com ([66.180.82.18]:57717 "EHLO
	sjdciscan02.udc.trendmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751655Ab3DLDym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 23:54:42 -0400
X-Greylist: delayed 1560 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Apr 2013 23:54:42 EDT
From: "yongjun_wei@trendmicro.com.cn" <yongjun_wei@trendmicro.com.cn>
To: Eric Paris <eparis@redhat.com>, Wei Yongjun <weiyj.lk@gmail.com>
CC: "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH -next] audit: remove duplicated include from audit.c
Thread-Topic: [PATCH -next] audit: remove duplicated include from audit.c
Thread-Index: Ac43Lc94QGubB33dQHGvphSp1r0KFg==
Date: Fri, 12 Apr 2013 03:28:34 +0000
Message-ID: <A360F954C61C69449463B0606663711259EE4EBC@CDCEXMBX01.tw.trendnet.org>
References: <CAPgLHd-M-q-xf+mp3VTAabxXS3bOjZ4g8EWLeE2NdjC2O7qCSA@mail.gmail.com>
 <170253117.11083340.1365614765343.JavaMail.root@redhat.com>
In-Reply-To: <170253117.11083340.1365614765343.JavaMail.root@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.64.44.136]
Content-Type: text/plain;
	charset="utf-8"
MIME-Version: 1.0
X-TM-AS-MML: No
X-TM-AS-Product-Ver: IMSVA-8.2.0.1679-7.0.0.1014-19792.004
X-TMASE-Version: IMSVA-8.2.0.1679-7.0.1014-19792.004
X-TMASE-Result: 10--31.483400-5.000000
X-TMASE-MatchedRID: hye8xZuNxhC8GTsHd+EMkBk4wcN85RIuAya39voTToV7k1ZHmKLF7a6x
	L0KIHMvxyWCL+8tLbvb6viSyhRDzBf1BNBACQf6m81jB92PyJHSKOc/QAD5CQczWN98iBBeGKWP
	nYJ5Ay2pbIM8dAZrOYJBn0Y6NyRFoM21CreAEMZgQkEWOYEwCV94I2x3xsCoojhXy0Khej9JUEN
	BIMyKD0aq9wgXVNwtgmE/wZ0tmNYbz39bev2BML83cbPzvuBsp9JCRdcMOvVlWdBPqAOaXVavd3
	WuZF0KAAoI6+29MrRlXeicg/7kQMH2VMDa97gjg/tVkYhEwz5onJ7hwR4FMAE+4wmL9kCTxLi2d
	wKiMR9wUcciLnfRUUi57hWH2lkqmoTCA5Efyn8DeYfIaXhttiN0H8LFZNFG7JQhrLH5KSJ0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3C3skbO010431

Hi Eric,

Sorry reply on top.

>From the source code from linex-next.git tree, line 55~64:

#include <net/sock.h>
#include <net/netlink.h>            *******
#include <linux/skbuff.h>
#ifdef CONFIG_SECURITY
#include <linux/security.h>
#endif
#include <net/netlink.h>            *******
#include <linux/freezer.h>
#include <linux/tty.h>
#include <linux/pid_namespace.h>

net/netlink.h is included twice, and linux/netlink.h is not included by this file.

-----Original Message-----
From: Eric Paris [mailto:eparis@redhat.com] 
Sent: 2013å¹´4æœˆ11æ—¥ 1:26
To: Wei Yongjun
Cc: viro@zeniv.linux.org.uk; Yongjun Wei (RD-CN); linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] audit: remove duplicated include from audit.c

net/netlink.h includes linux/netlink.h but linux/netlink.h does not include net/netlink.h

since the audit code uses the nlmsg_* functions provided in net/netlink.h it seems we need this include.

since the audit code uses netlink_unicast provided in linux/netlink.h it seems we need that include.

I don't see duplication even if by chance one of them would have included the other...

----- Original Message -----
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Remove duplicated include.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  kernel/audit.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/kernel/audit.c b/kernel/audit.c index 488f85f..9377913 
> 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -58,7 +58,6 @@
>  #ifdef CONFIG_SECURITY
>  #include <linux/security.h>
>  #endif
> -#include <net/netlink.h>
>  #include <linux/freezer.h>
>  #include <linux/tty.h>
>  #include <linux/pid_namespace.h>
> 
> 

<table class="TM_EMAIL_NOTICE"><tr><td><pre>
TREND MICRO EMAIL NOTICE
The information contained in this email and any attachments is confidential 
and may be subject to copyright or other intellectual property protection. 
If you are not the intended recipient, you are not authorized to use or 
disclose this information, and we request that you notify us by reply mail or
telephone and delete the original message from your mail system.
</pre></td></tr></table>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
