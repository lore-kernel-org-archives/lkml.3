Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339Ab3HAUbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 16:31:17 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:58242 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab3HAUbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 16:31:15 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <4170130535e4ea14c66f8510042577be21941f4d.1375387593.git.joe@perches.com>
References: <cover.1375387593.git.joe@perches.com>
	<4170130535e4ea14c66f8510042577be21941f4d.1375387593.git.joe@perches.com>
Date: Thu, 1 Aug 2013 13:31:09 -0700
Message-ID: <CAOesGMhmxJTDjcPeD4b1FvRsbP8df369F01SQBK6dk4nXmRGjA@mail.gmail.com>
Subject: Re: [PATCH V2 3/3] ethernet: Convert mac address uses of 6 to ETH_ALEN
From: Olof Johansson <olof@lixom.net>
To: Joe Perches <joe@perches.com>
Cc: Network Development <netdev@vger.kernel.org>,
        Don Fry <pcnet32@frontier.com>,
        Grant Grundler <grundler@parisc-linux.org>,
        Sam Creasey <sammy@sammy.net>, Andrew Gallatin <gallatin@myri.com>,
        Wan ZongShun <mcuos.com@gmail.com>,
        Manish Chopra <manish.chopra@qlogic.com>,
        Sony Chacko <sony.chacko@qlogic.com>,
        Rajesh Borundia <rajesh.borundia@qlogic.com>,
        Shahed Shaikh <shahed.shaikh@qlogic.com>,
        Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>,
        Ron Mercer <ron.mercer@qlogic.com>, linux-driver@qlogic.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Aug 1, 2013 at 1:14 PM, Joe Perches <joe@perches.com> wrote:

> diff --git a/drivers/net/ethernet/pasemi/pasemi_mac.h b/drivers/net/ethernet/pasemi/pasemi_mac.h
> index e2f4efa..649fdb4 100644
> --- a/drivers/net/ethernet/pasemi/pasemi_mac.h
> +++ b/drivers/net/ethernet/pasemi/pasemi_mac.h
> @@ -79,11 +79,11 @@ struct pasemi_mac {
>         int             last_cs;
>         int             num_cs;
>         u32             dma_if;
> -       u8              type;
>  #define MAC_TYPE_GMAC  1
>  #define MAC_TYPE_XAUI  2
>
> -       u8              mac_addr[6];
> +       u8              mac_addr[ETH_ALEN];
> +       u8              type;

Just promote 'type' to u32 instead, saves you from moving the #defines
down, etc, etc.


-Olof
