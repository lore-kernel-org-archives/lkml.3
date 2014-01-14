Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101AbaANQvL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:51:11 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:35450 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbaANQvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:51:09 -0500
Date: Tue, 14 Jan 2014 08:51:05 -0800
From: Stephen Hemminger <stephen@networkplumber.org>
To: Ying Xue <ying.xue@windriver.com>
Cc: <davem@davemloft.net>, <vfalico@redhat.com>, <john.r.fastabend@intel.com>,
        <antonio@meshcoding.com>, <dmitry.tarnyagin@lockless.no>,
        <socketcan@hartkopp.net>, <johannes@sipsolutions.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 06/10] vxlan: use __dev_get_by_index instead of
 dev_get_by_index to find interface
Message-ID: <20140114085105.706779c1@nehalam.linuxnetplumber.net>
In-Reply-To: <1389685269-18600-7-git-send-email-ying.xue@windriver.com>
References: <1389685269-18600-1-git-send-email-ying.xue@windriver.com>
	<1389685269-18600-7-git-send-email-ying.xue@windriver.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jan 2014 15:41:05 +0800
Ying Xue <ying.xue@windriver.com> wrote:

> The following call chains indicate that vxlan_fdb_parse() is
> under rtnl_lock protection. So if we use __dev_get_by_index()
> instead of dev_get_by_index() to find interface handler in it,
> this would help us avoid to change interface reference counter.
> 
> rtnetlink_rcv()
>   rtnl_lock()
>   netlink_rcv_skb()
>     rtnl_fdb_add()
>       vxlan_fdb_add()
>         vxlan_fdb_parse()
>   rtnl_unlock()
> 
> rtnetlink_rcv()
>   rtnl_lock()
>   netlink_rcv_skb()
>     rtnl_fdb_del()
>       vxlan_fdb_del()
>         vxlan_fdb_parse()
>   rtnl_unlock()
> 
> Cc: Stephen Hemminger <stephen@networkplumber.org>
> Signed-off-by: Ying Xue <ying.xue@windriver.com>

Acked-by: Stephen Hemminger <stephen@networkplumber.org>
