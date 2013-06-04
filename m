Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab3FDQBN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 12:01:13 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:58943 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456Ab3FDQBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 12:01:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Florian Fainelli <florian@openwrt.org>,
        Russell King <linux@arm.linux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, alexandre.belloni@free-electrons.com,
        kernel@pengutronix.de, shawn.guo@linaro.org,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCHv2 1/3] net: phy: prevent linking breakage
Date: Tue, 04 Jun 2013 18:01:07 +0200
Message-ID: <1394174.ONngHnHYKL@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.3; x86_64; ; )
In-Reply-To: <CAGVrzcbRS3x5fgD1BfOk4-oTUsAY9FA2V621OvZLJQNZ01brCg@mail.gmail.com>
References: <1369741403-25315-2-git-send-email-alexandre.belloni@free-electrons.com> <6466898.RnYOe3jpGG@wuerfel> <CAGVrzcbRS3x5fgD1BfOk4-oTUsAY9FA2V621OvZLJQNZ01brCg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:/32GrPdRcfIh+p+ceEONYJeUh8P+Fkv8iVFUe+d2IJq
 oDzv6xy86/0ZBVxM5GaHRRioRwR5O+g55CC34I3bMQfml/jvFA
 2liGshEwzF70CoS2R+w/MwkCTc5MOxgcoL8ubYkFvET/zP3Czc
 HzPatEjUq9umZNPTgJeovKCqebB6lPcESbaJC11qD2XJzsf8M7
 ngepbhXTkMitPk/Yt60eN0Flw0fkMhEtc0Cj9CrV/DaLC9cGg0
 z+/oA04KtzNBZxk9jAwDuIffj4GZj5nVmhwR6u+z1ZnMwOAGvm
 uabObaD2zqisIC49bpuSvHKDXAWMLIQMKl9Ry+Lx/WvKikXNFB
 y1gXSuCnyjJcP0Er7VZs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 June 2013 16:36:50 Florian Fainelli wrote:
> It seems to me that what David proposes is to have say an
> arch/arm/mach-foo/phy-fixups.c file which is only enabled when
> CONFIG_PHYLIB is set (obj-$(CONFIG_PHYLIB) += phy-fixup.o), such that
> it does not need to have any conditionnals when calling
> phy_register_fixup. This sounds a little unusual, but why not.

I don't think it would actually help us, because then we still need
to declare a local function that gets called from the board init
code. Instead of doing

	if (IS_ENABLED(CONFIG_PHYLIB))
		 phy_register_fixup_for_uid(phy_id, foo_phy_fixup);

we would then do

	if (IS_ENABLED(CONFIG_PHYLIB))
		foo_phy_fixup_register();

which is not much different at all.

	Arnd
