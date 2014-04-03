Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723AbaDCJ6D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 05:58:03 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:59776 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbaDCJ54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 05:57:56 -0400
Message-ID: <533D30A1.1060509@gmail.com>
Date: Thu, 03 Apr 2014 17:57:53 +0800
From: zhuyj <zyjzyj2000@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: sandeep.kumar@freescale.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Tao, Yue" <Yue.Tao@windriver.com>,
        "Yang, Zhangle (Eric)" <Zhangle.Yang@windriver.com>,
        guang.yang@windriver.com, joe@perches.com, festevam@gmail.com,
        linuxppc-dev@lists.ozlabs.org, richardcochran@gmail.com,
        clarocq@gmail.com, yongjun_wei@trendmicro.com.cn,
        Claudiu Manoil <claudiu.manoil@freescale.com>
Subject: Re: on kernel 2.6.34.15, vlan and raw packets can not be received
 with gfar-enet nic
References: <53310F4E.4080104@gmail.com> <533D25D4.4000607@gmail.com> <20140403092727.GD16158@1wt.eu>
In-Reply-To: <20140403092727.GD16158@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2014 05:27 PM, Willy Tarreau wrote:
> Hi Zhu,
>
> On Thu, Apr 03, 2014 at 05:11:48PM +0800, zhuyj wrote:
>> Hi, Claudiu
>>
>> Please help to review this patch. This patch is for kernel 2.6.x. Thanks
>> a lot.
>>
>> Hi, Willy
>>
>> Please help to merge this patch to longterm: 2.6.32.61 since this
>> problem also occurs on this kernel. Thanks a lot.
> Could you please send the reference to the equivalent mainline commit (the one
> which disables the tx vlan feature I'm assuming) ? I'll happily queue it for
> 2.6.32.62.
>
> Thanks,
> Willy
>
>
Hi, Willy

I reference the following 2 mainline commits. These 2 commits are based 
on the current kernel 3.x and ethtool.
If we only backport these 2 commits on kernel 2.6.x, this problem will 
not be fixed yet.

Best Regards!
Zhu Yanjun

1. commit 87c288c6e9aa31720b72e2bc2d665e24e1653c3e
Author: Jiri Pirko <jpirko@redhat.com>
Date:   Wed Jul 20 04:54:19 2011 +0000

     gianfar: do vlan cleanup

     - unify vlan and nonvlan rx path
     - kill priv->vlgrp and gfar_vlan_rx_register
     - allow to turn on/off rx/tx vlan accel via ethtool

     Signed-off-by: Jiri Pirko <jpirko@redhat.com>
     Signed-off-by: David S. Miller <davem@davemloft.net>

  drivers/net/gianfar.c |   55 
++++++++++++++++++++++++++-----------------------
  1 file changed, 29 insertions(+), 26 deletions(-)

2.commit b852b720877e6b8e12b95a7cb4e00ea351b8cbfc
Author: Sebastian Pöhn <sebastian.belden@googlemail.com>
Date:   Tue Jul 26 00:03:13 2011 +0000

     gianfar: fix bug caused by 87c288c6e9aa31720b72e2bc2d665e24e1653c3e

     commit 87c288c6e9aa31720b72e2bc2d665e24e1653c3e "gianfar: do vlan 
cleanup" has two issues:
     # permutation of rx and tx flags
     # enabling vlan tag insertion by default (this leads to unusable 
connections on some configurations)

     If VLAN insertion is requested (via ethtool) it will be set at an 
other point ...

     Signed-off-by: Sebastian Poehn <sebastian.poehn@belden.com>
     Signed-off-by: David S. Miller <davem@davemloft.net>

  drivers/net/gianfar.c |    6 +-----
  1 file changed, 1 insertion(+), 5 deletions(-)

