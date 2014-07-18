Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946093AbaGRVGc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 17:06:32 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:54306 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755763AbaGRVGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 17:06:30 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.11.1407182339160.2273@ja.home.ssi.bg>
References: <1405697638-23767-1-git-send-email-andrey.krieger.utkin@gmail.com>
	<alpine.LFD.2.11.1407182339160.2273@ja.home.ssi.bg>
Date: Sat, 19 Jul 2014 00:06:28 +0300
Message-ID: <CANZNk83dJCXAWrQ+i5rh=sdUuiiD5ZhzDua-rjJpBZCzzNGDJA@mail.gmail.com>
Subject: Re: [PATCH 3/5] net/netfilter/ipvs/ip_vs_ctl.c: drop argument range
 check just before the check for equality
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: Julian Anastasov <ja@ssi.bg>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, coreteam@netfilter.org,
        netfilter-devel@vger.kernel.org, lvs-devel@vger.kernel.org,
        netdev@vger.kernel.org, dcb314@hotmail.com,
        David Miller <davem@davemloft.net>, kadlec@blackhole.kfki.hu,
        Patrick McHardy <kaber@trash.net>, pablo@netfilter.org,
        Simon Horman <horms@verge.net.au>, wensong@linux-vs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-07-18 23:48 GMT+03:00 Julian Anastasov <ja@ssi.bg>:
>         The above check ensures the set_arglen[] value (some
> struct size) does not exceed the arg[MAX_ARG_LEN] space. You can check
> commit 04bcef2a83f40c ("ipvs: Add boundary check on ioctl arguments")
> for more info.

Thanks for info.
What about static check at compilation time?

#if (DAEMON_ARG_LEN > MAX_ARG_LEN) \
 || (SERVICE_ARG_LEN > MAX_ARG_LEN) \
 || (SVCDEST_ARG_LEN > MAX_ARG_LEN)
#error MAX_ARG_LEN exceeded in set_arglen table
#endif

-- 
Andrey Utkin
