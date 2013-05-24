Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760305Ab3EXJnO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 05:43:14 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:63361 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab3EXJnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 05:43:10 -0400
MIME-Version: 1.0
In-Reply-To: <1369387394-9453-3-git-send-email-maxime.ripard@free-electrons.com>
References: <1369387394-9453-1-git-send-email-maxime.ripard@free-electrons.com>
 <1369387394-9453-3-git-send-email-maxime.ripard@free-electrons.com>
From: Florian Fainelli <florian@openwrt.org>
Date: Fri, 24 May 2013 10:42:30 +0100
X-Google-Sender-Auth: e3Uy7G5BH_6rsWpGc0xi_b4wbKY
Message-ID: <CAGVrzcbyXiKCKxtOAj0gnG8eCQag8_xvmd9dUKACCbfW-2HN9Q@mail.gmail.com>
Subject: Re: [PATCHv3 2/6] net: Add MDIO bus driver for the Allwinner EMAC
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: David Miller <davem@davemloft.net>, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Roese <sr@denx.de>, Emilio Lopez <emilio@elopez.com.ar>,
        kevin@allwinnertech.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Maxime,

2013/5/24 Maxime Ripard <maxime.ripard@free-electrons.com>
>
> This patch adds a separate driver for the MDIO interface of the
> Allwinner ethernet controllers.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  .../bindings/net/allwinner,sun4i-mdio.txt          |  26 +++
>  drivers/net/ethernet/allwinner/Kconfig             |   8 +
>  drivers/net/ethernet/allwinner/Makefile            |   1 +
>  drivers/net/ethernet/allwinner/sun4i-mdio.c        | 191 +++++++++++++++++++++

Ok, so you probably followed Thomas's example here with mvneta/mvmdio,
but all other MDIO bus drivers live in drivers/net/phy. Unfortunately,
mvmdio lives in drivers/net/ethernet/marvell/mvmdio.c which I should
have noticed before. Whatever is good for you guys, but we should
probably start normalizing this now before more mdio drivers get
merged alongside their corresponding ethernet MAC users.
