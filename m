Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab3H0QRZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 12:17:25 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55908 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab3H0QRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 12:17:24 -0400
Message-ID: <521CD111.9030905@wwwdotorg.org>
Date: Tue, 27 Aug 2013 10:17:21 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with Linus' tree
References: <20130827182935.ff4005b60cc1ce80d32d5e46@canb.auug.org.au>
In-Reply-To: <20130827182935.ff4005b60cc1ce80d32d5e46@canb.auug.org.au>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2013 02:29 AM, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the arm-soc tree got a conflict in 
> arch/arm/boot/dts/tegra20-trimslice.dts between commit
> 30ca2226bea6 ("ARM: tegra: always enable USB VBUS regulators") from
> Linus' tree and commit 23f95ef2d951 ("ARM: tegra: use TEGRA_GPIO()
> in a couple more places") from the arm-soc tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no
> action is required).

> diff --cc arch/arm/boot/dts/tegra20-trimslice.dts

> usb@c5000000 { status = "okay"; -		nvidia,vbus-gpio = <&gpio
> TEGRA_GPIO(V, 2) GPIO_ACTIVE_HIGH>; };

That chunk isn't part of either of the two commits above.

It is however part of commit 103566e "arm: tegra: Remove obsolete
nvidia,vbus-gpio properties" from the USB tree, so it's fine that the
change is part of linux-next.

I'm just not sure if it's expected for that chunk to show up in this
merge resolution email? If it's normal, then there's no problem; the
issue would be with me not having too much git merge conflict
resolution experience:-)
