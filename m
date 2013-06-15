Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab3FOGGE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 02:06:04 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:43453 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423Ab3FOGGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 02:06:01 -0400
MIME-Version: 1.0
In-Reply-To: <CAM_iQpWu2U5UmHhvmnqNenbWyz7vng8W+b0AssE31FSgSd9DLg@mail.gmail.com>
References: <20130614220119.GA12954@localhost>
	<CAM_iQpWu2U5UmHhvmnqNenbWyz7vng8W+b0AssE31FSgSd9DLg@mail.gmail.com>
Date: Sat, 15 Jun 2013 14:06:00 +0800
Message-ID: <CAM_iQpW4VZNMo4_nBeH6Cu3E3etd72+MVsFMRWFsR0a9qV8OPw@mail.gmail.com>
Subject: Re: [netlink] WARNING: at mm/vmalloc.c:1487 __vunmap()
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 15, 2013 at 1:57 PM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> Hi, Fengguang,
>
> Could you try the following quick fix?
>
> diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
> index 8978755..d8c6c03 100644
> --- a/net/netlink/af_netlink.c
> +++ b/net/netlink/af_netlink.c
> @@ -750,7 +750,7 @@ static void netlink_skb_destructor(struct sk_buff *skb)
>                 skb->head = NULL;
>         }
>  #endif
> -       if (is_vmalloc_addr(skb->head)) {
> +       else if (is_vmalloc_addr(skb->head)) {


Never mind, skb->head is already set to NULL when it is
mmap skb... so please ignore it.
